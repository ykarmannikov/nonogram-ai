import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nngram/features/game/state/game_provider.dart';
import 'package:nngram/features/level_select/state/levels_provider.dart';
import 'package:nngram/features/progress/state/progress_provider.dart';
import 'package:nngram/shared/ui/app_colors.dart';
import 'package:nngram/shared/ui/app_spacing.dart';

/// Главный экран приложения.
///
/// Показывает кнопку "Играть" с текущим уровнем.
/// При нажатии открывает следующий доступный уровень напрямую.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final easyAsync = ref.watch(levelsProvider('easy'));

    // Инициализация прогресса при первом запуске.
    ref.listen(levelsProvider('easy'), (_, next) {
      next.whenData((puzzles) {
        ref.read(progressProvider.notifier).initializeIfNeeded(
          puzzles.map((p) => p.id).toList(),
          [],
        );
      });
    });

    final next = ref.watch(nextUnlockedLevelProvider);
    final isLoading = easyAsync.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Нонограмм',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.filled,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _PlayButton(
                levelLabel: next != null ? _buttonLabel(next.id) : null,
                isLoading: isLoading,
                onPressed: (isLoading || next == null)
                    ? null
                    : () {
                        ref.read(selectedPuzzleProvider.notifier).state = next;
                        context.push('/game');
                      },
              ),
              const SizedBox(height: AppSpacing.m),
              TextButton(
                onPressed: () => context.push('/levels/easy'),
                child: Text(
                  'Все уровни',
                  style: TextStyle(
                    color: AppColors.hintText.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _buttonLabel(String id) {
    final parts = id.split('_');
    final diff = parts[0] == 'easy' ? 'Easy' : 'Hard';
    return 'Level ${parts[1]} — $diff';
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.levelLabel,
    required this.isLoading,
    required this.onPressed,
  });

  final String? levelLabel;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 72,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.filled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Играть',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  if (levelLabel != null)
                    Text(
                      levelLabel!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        height: 1.3,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
