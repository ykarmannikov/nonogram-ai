import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nngram/entities/puzzle.dart';
import 'package:nngram/features/game/state/game_provider.dart';
import 'package:nngram/features/level_select/state/levels_provider.dart';
import 'package:nngram/features/progress/state/progress_provider.dart';
import 'package:nngram/shared/widgets/app_error_widget.dart';
import 'package:nngram/shared/widgets/loading_widget.dart';

/// Экран выбора уровня для заданной сложности.
class LevelSelectScreen extends ConsumerWidget {
  const LevelSelectScreen({super.key, required this.difficulty});

  final String difficulty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsProvider(difficulty));
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleFor(difficulty)),
      ),
      body: levelsAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(message: e.toString()),
        data: (levels) {
          final completedIds =
              progressAsync.valueOrNull?.map((p) => p.levelId).toSet() ?? {};

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: levels.length,
            itemBuilder: (context, index) {
              final puzzle = levels[index];
              final isCompleted = completedIds.contains(puzzle.id);
              final isLocked = _isLocked(index, levels, completedIds);

              return _LevelCard(
                puzzle: puzzle,
                isCompleted: isCompleted,
                isLocked: isLocked,
                onTap: isLocked ? null : () => _openLevel(context, ref, puzzle),
              );
            },
          );
        },
      ),
    );
  }

  /// Уровень заблокирован если:
  /// - Easy: никогда
  /// - Hard: каждый следующий открывается только после прохождения предыдущего
  bool _isLocked(
    int index,
    List<Puzzle> levels,
    Set<String> completedIds,
  ) {
    if (difficulty == 'easy') return false;
    if (index == 0) return false;
    return !completedIds.contains(levels[index - 1].id);
  }

  void _openLevel(BuildContext context, WidgetRef ref, Puzzle puzzle) {
    ref.read(selectedPuzzleProvider.notifier).state = puzzle;
    context.push('/game');
  }

  String _titleFor(String diff) =>
      diff == 'easy' ? 'Лёгкие уровни' : 'Сложные уровни';
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.puzzle,
    required this.isCompleted,
    required this.isLocked,
    required this.onTap,
  });

  final Puzzle puzzle;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color cardColor;
    final IconData icon;

    if (isLocked) {
      cardColor = colorScheme.surfaceContainerLow;
      icon = Icons.lock;
    } else if (isCompleted) {
      cardColor = colorScheme.primaryContainer;
      icon = Icons.check_circle;
    } else {
      cardColor = colorScheme.surfaceContainerHighest;
      icon = Icons.grid_on;
    }

    return Card(
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isLocked ? colorScheme.outline : null,
              ),
              const SizedBox(height: 4),
              Text(
                '${puzzle.width}×${puzzle.height}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isLocked ? colorScheme.outline : null,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
