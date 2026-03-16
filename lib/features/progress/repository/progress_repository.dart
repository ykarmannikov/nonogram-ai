import 'package:nngram/core/database/app_database.dart';
import 'package:nngram/entities/progress.dart';

/// Репозиторий прогресса.
///
/// Абстрагирует доступ к БД от провайдеров и бизнес-логики.
class ProgressRepository {
  const ProgressRepository(this._db);

  final AppDatabase _db;

  Future<List<Progress>> getAll() => _db.getAllProgress();

  Future<void> save(Progress progress) => _db.saveProgress(progress);

  Future<void> delete(String levelId) => _db.deleteProgress(levelId);
}
