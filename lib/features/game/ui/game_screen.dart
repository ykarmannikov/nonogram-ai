import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nngram/features/game/state/game_provider.dart';
import 'package:nngram/features/game/ui/widgets/controls_widget.dart';
import 'package:nngram/features/game/ui/widgets/hints_panel.dart';
import 'package:nngram/features/game/ui/widgets/puzzle_grid.dart';
import 'package:nngram/features/level_select/state/levels_provider.dart';
import 'package:nngram/features/progress/state/progress_provider.dart';
import 'package:nngram/shared/ui/app_colors.dart';
import 'package:nngram/shared/ui/app_spacing.dart';
import 'package:nngram/shared/widgets/app_back_button.dart';

/// Экран игры.
///
/// Инициализирует игровую сессию из [selectedPuzzleProvider]
/// при первом открытии.
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  static const double _hintSize = 48.0;
  static const double _controlsHeight = 72.0;

  // AppSpacing.l(16) + button(44) + AppSpacing.s(8) = 68
  static const double _topBarReservation = 68.0;

  /// Флаг защиты от повторного показа диалога победы.
  ///
  /// Без флага: каждый rebuild при isSolved == true добавляет новый
  /// postFrameCallback → несколько диалогов поверх друг друга.
  bool _victoryHandled = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initGame());
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  void _initGame() {
    // Сбрасываем старый GameState до null — первый build нового уровня
    // увидит null → LoadingWidget, а не isSolved=true от предыдущей партии.
    ref.read(gameProvider.notifier).clearGame();
    final puzzle = ref.read(selectedPuzzleProvider);
    if (puzzle != null) {
      _victoryHandled = false;
      ref.read(gameProvider.notifier).startGame(puzzle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    if (gameState == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Обработка победы — ровно один раз за сессию.
    if (gameState.isSolved && !_victoryHandled) {
      _victoryHandled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleVictory(context);
      });
    }

    final puzzle = gameState.puzzle;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final gridAvailW = constraints.maxWidth - _hintSize;
            final gridAvailH = constraints.maxHeight -
                _hintSize -
                _controlsHeight -
                AppSpacing.xl -
                _topBarReservation;

            final cellSize = min(
              gridAvailW / puzzle.width,
              gridAvailH / puzzle.height,
            );

            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: _topBarReservation),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(width: _hintSize),
                                HintsPanel(
                                  hints: puzzle.colHints,
                                  cellSize: cellSize,
                                  axis: Axis.horizontal,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: _hintSize,
                                  child: HintsPanel(
                                    hints: puzzle.rowHints,
                                    cellSize: cellSize,
                                    axis: Axis.vertical,
                                  ),
                                ),
                                PuzzleGrid(
                                  gameState: gameState,
                                  cellSize: cellSize,
                                  onCellApply: (row, col, targetState) {
                                    ref
                                        .read(gameProvider.notifier)
                                        .applyDragMove(row, col, targetState);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        ModeControls(
                          currentMode: gameState.mode,
                          onModeChanged: (mode) {
                            ref.read(gameProvider.notifier).setMode(mode);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.l,
                  left: AppSpacing.l,
                  right: AppSpacing.l,
                  child: _GameTopBar(
                    title: _levelLabel(puzzle.id),
                    onBack: () => context.pop(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _levelLabel(String id) =>
      id.startsWith('easy') ? 'Easy' : 'Hard';

  Future<void> _handleVictory(BuildContext context) async {
    // Guard: состояние могло сброситься к тому моменту, как callback выполнился
    // (например, при быстром переходе на следующий уровень).
    final currentState = ref.read(gameProvider);
    if (currentState == null || !currentState.isSolved) return;

    final puzzle = currentState.puzzle;

    final easyIds = ref
            .read(levelsProvider('easy'))
            .valueOrNull
            ?.map((p) => p.id)
            .toList() ??
        [];
    final hardIds = ref
            .read(levelsProvider('hard'))
            .valueOrNull
            ?.map((p) => p.id)
            .toList() ??
        [];

    await ref.read(progressProvider.notifier).markCompletedAndUnlockNext(
          completedId: puzzle.id,
          easyIds: easyIds,
          hardIds: hardIds,
        );

    if (!context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Победа!'),
        content: const Text('Головоломка решена верно.'),
        actions: [
          TextButton(
            onPressed: () {
              ctx.pop();
              context.pop();
            },
            child: const Text('К уровням'),
          ),
        ],
      ),
    );
  }
}

class _GameTopBar extends StatelessWidget {
  const _GameTopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppBackButton(onTap: onBack),
        const Spacer(),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.hintText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const Spacer(),
        // Симметричный пустой блок, чтобы заголовок был по центру
        const SizedBox(width: 44),
      ],
    );
  }
}
