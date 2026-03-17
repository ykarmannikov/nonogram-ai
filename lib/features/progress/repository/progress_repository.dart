import 'package:nngram/core/database/app_database.dart';
import 'package:nngram/entities/progress.dart';

/// Репозиторий прогресса.
///
/// Абстрагирует доступ к БД от провайдеров и бизнес-логики.
class ProgressRepository {
  const ProgressRepository(this._db);

  final AppDatabase _db;

  Future<List<Progress>> getAll() => _db.getAllProgress();

  Future<void> setUnlocked(String levelId) => _db.setUnlocked(levelId);

  Future<void> setCompleted(String levelId) => _db.setCompleted(levelId);

  Future<void> initializeAll(List<String> levelIds, String firstUnlockedId) =>
      _db.initializeAll(levelIds, firstUnlockedId);

  Future<void> delete(String levelId) => _db.deleteProgress(levelId);
}
