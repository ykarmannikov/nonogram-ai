import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nngram/entities/progress.dart';
import 'package:nngram/features/progress/repository/progress_repository.dart';

/// Управляет состоянием прогресса уровней.
class ProgressNotifier extends StateNotifier<AsyncValue<List<Progress>>> {
  ProgressNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  final ProgressRepository _repository;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.getAll);
  }

  /// Инициализирует прогресс при первом запуске.
  ///
  /// Создаёт записи для всех уровней: только первый easy разблокирован.
  /// Безопасно вызывать повторно — пропускает если уже инициализировано.
  Future<void> initializeIfNeeded(
    List<String> easyIds,
    List<String> hardIds,
  ) async {
    final all = state.valueOrNull ?? [];
    if (all.isNotEmpty) return;
    await _repository.initializeAll([...easyIds, ...hardIds], easyIds.first);
    await _load();
  }

  /// Помечает уровень пройденным и разблокирует следующий.
  ///
  /// Логика разблокировки:
  /// - Easy N пройден → unlock Easy N+1
  /// - Последний Easy пройден → unlock Hard 1
  /// - Hard N пройден → unlock Hard N+1
  Future<void> markCompletedAndUnlockNext({
    required String completedId,
    required List<String> easyIds,
    required List<String> hardIds,
  }) async {
    await _repository.setCompleted(completedId);

    final easyIdx = easyIds.indexOf(completedId);
    if (easyIdx >= 0) {
      if (easyIdx + 1 < easyIds.length) {
        await _repository.setUnlocked(easyIds[easyIdx + 1]);
      } else if (hardIds.isNotEmpty) {
        await _repository.setUnlocked(hardIds.first);
      }
    }

    final hardIdx = hardIds.indexOf(completedId);
    if (hardIdx >= 0 && hardIdx + 1 < hardIds.length) {
      await _repository.setUnlocked(hardIds[hardIdx + 1]);
    }

    await _load();
  }

  /// Проверяет, пройден ли уровень.
  bool isCompleted(String levelId) {
    return state.valueOrNull
            ?.any((p) => p.levelId == levelId && p.isCompleted) ??
        false;
  }

  /// Проверяет, разблокирован ли уровень.
  bool isUnlocked(String levelId) {
    return state.valueOrNull
            ?.any((p) => p.levelId == levelId && p.isUnlocked) ??
        false;
  }
}
