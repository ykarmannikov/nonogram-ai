import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nngram/entities/puzzle.dart';
import 'package:nngram/features/level_select/repository/levels_repository.dart';
import 'package:nngram/features/progress/state/progress_provider.dart';

/// Провайдер репозитория уровней.
final levelsRepositoryProvider = Provider<LevelsRepository>((ref) {
  return LevelsRepository();
});

/// Провайдер уровней для заданной сложности.
///
/// Использование: `ref.watch(levelsProvider('easy'))`
final levelsProvider =
    FutureProvider.family<List<Puzzle>, String>((ref, difficulty) {
  return ref.watch(levelsRepositoryProvider).loadByDifficulty(difficulty);
});

/// Следующий доступный для игры уровень.
///
/// Первый разблокированный, но не пройденный уровень (easy → hard).
/// Если все пройдены — возвращает первый easy уровень для повторного прохождения.
final nextUnlockedLevelProvider = Provider<Puzzle?>((ref) {
  final easy = ref.watch(levelsProvider('easy')).valueOrNull ?? [];
  final hard = ref.watch(levelsProvider('hard')).valueOrNull ?? [];
  final progress = ref.watch(progressProvider).valueOrNull ?? [];

  for (final puzzle in [...easy, ...hard]) {
    final entry = progress.where((p) => p.levelId == puzzle.id).firstOrNull;
    if (entry != null && entry.isUnlocked && !entry.isCompleted) return puzzle;
  }
  return easy.isNotEmpty ? easy.first : null;
});

/// Провайдер флага разблокировки режима Hard.
///
/// Hard разблокируется, когда хотя бы один hard-уровень помечен isUnlocked.
/// Это происходит после прохождения всех easy уровней.
final hardUnlockedProvider = Provider<bool>((ref) {
  final progress = ref.watch(progressProvider).valueOrNull ?? [];
  return progress.any((p) => p.levelId.startsWith('hard_') && p.isUnlocked);
});
