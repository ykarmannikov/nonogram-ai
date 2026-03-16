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

              return _LevelCard(
                puzzle: puzzle,
                isCompleted: isCompleted,
                onTap: () => _openLevel(context, ref, puzzle),
              );
            },
          );
        },
      ),
    );
  }

  void _openLevel(BuildContext context, WidgetRef ref, Puzzle puzzle) {
    ref.read(selectedPuzzleProvider.notifier).state = puzzle;
    context.push('/game');
  }

  String _titleFor(String difficulty) =>
      difficulty == 'easy' ? 'Лёгкие уровни' : 'Сложные уровни';
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.puzzle,
    required this.isCompleted,
    required this.onTap,
  });

  final Puzzle puzzle;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: isCompleted
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCompleted)
                const Icon(Icons.check_circle, size: 24)
              else
                const Icon(Icons.grid_on, size: 24),
              const SizedBox(height: 4),
              Text(
                '${puzzle.width}×${puzzle.height}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
