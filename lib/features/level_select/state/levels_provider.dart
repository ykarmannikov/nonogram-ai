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

/// Провайдер флага разблокировки режима Hard.
///
/// Hard разблокируется, когда все Easy уровни пройдены.
final hardUnlockedProvider = Provider<bool>((ref) {
  final easyLevels = ref.watch(levelsProvider('easy')).valueOrNull ?? [];
  final progress = ref.watch(progressProvider).valueOrNull ?? [];
  if (easyLevels.isEmpty) return false;
  final completedIds = progress.map((p) => p.levelId).toSet();
  return easyLevels.every((p) => completedIds.contains(p.id));
});
