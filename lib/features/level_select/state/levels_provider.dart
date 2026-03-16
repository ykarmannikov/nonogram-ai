import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nngram/entities/puzzle.dart';
import 'package:nngram/features/level_select/repository/levels_repository.dart';

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
