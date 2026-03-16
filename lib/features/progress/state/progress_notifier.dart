import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nngram/entities/progress.dart';
import 'package:nngram/features/progress/repository/progress_repository.dart';

/// Управляет состоянием списка пройденных уровней.
class ProgressNotifier extends StateNotifier<AsyncValue<List<Progress>>> {
  ProgressNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  final ProgressRepository _repository;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.getAll);
  }

  /// Сохраняет прохождение уровня и обновляет состояние.
  Future<void> markCompleted(String levelId) async {
    final progress = Progress(
      levelId: levelId,
      completedAt: DateTime.now(),
    );
    await _repository.save(progress);
    await _load();
  }

  /// Проверяет, пройден ли уровень.
  bool isCompleted(String levelId) {
    return state.valueOrNull?.any((p) => p.levelId == levelId) ?? false;
  }
}
