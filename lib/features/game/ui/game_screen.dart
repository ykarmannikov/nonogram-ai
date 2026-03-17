import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nngram/features/game/state/game_provider.dart';
import 'package:nngram/features/game/ui/widgets/game_toolbar.dart';
import 'package:nngram/features/game/ui/widgets/hints_panel.dart';
import 'package:nngram/features/game/ui/widgets/puzzle_grid.dart';
import 'package:nngram/features/level_select/state/levels_provider.dart';
import 'package:nngram/features/progress/state/progress_provider.dart';

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
  static const double _cellSize = 36.0;
  static const double _hintWidth = 48.0;

  /// Флаг защиты от повторного показа диалога победы.
  ///
  /// Без флага: каждый rebuild при isSolved == true добавляет новый
  /// postFrameCallback → несколько диалогов поверх друг друга.
  bool _victoryHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initGame());
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
    final totalWidth = _hintWidth + puzzle.width * _cellSize;

    return Scaffold(
      appBar: AppBar(
        title: Text('Уровень ${puzzle.id}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Верхний ряд: пустой угол + подсказки столбцов
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(width: _hintWidth),
                            HintsPanel(
                              hints: puzzle.colHints,
                              cellSize: _cellSize,
                              axis: Axis.horizontal,
                            ),
                          ],
                        ),
                        // Нижний ряд: подсказки строк + игровое поле
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: _hintWidth,
                              child: HintsPanel(
                                hints: puzzle.rowHints,
                                cellSize: _cellSize,
                                axis: Axis.vertical,
                              ),
                            ),
                            SizedBox(
                              width: puzzle.width * _cellSize,
                              child: PuzzleGrid(
                                gameState: gameState,
                                cellSize: _cellSize,
                                onCellTap: (row, col) {
                                  ref
                                      .read(gameProvider.notifier)
                                      .applyMove(row, col);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Панель инструментов
            GameToolbar(
              currentMode: gameState.mode,
              onToggleMode: () => ref.read(gameProvider.notifier).toggleMode(),
              onReset: () {
                _victoryHandled = false;
                ref.read(gameProvider.notifier).resetGame();
              },
            ),
          ],
        ),
      ),
    );
  }

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
