import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:nngram/entities/progress.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Таблицы
// ---------------------------------------------------------------------------

/// Таблица пройденных уровней.
///
/// Наличие записи означает, что уровень пройден.
/// Производные состояния (разблокировка) вычисляются в runtime.
class ProgressEntries extends Table {
  TextColumn get levelId => text()();
  IntColumn get completedAt => integer()();

  @override
  Set<Column> get primaryKey => {levelId};
}

// ---------------------------------------------------------------------------
// База данных
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [ProgressEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'nngram'));

  @override
  int get schemaVersion => 1;

  // ---------------------------------------------------------------------------
  // Запросы прогресса
  // ---------------------------------------------------------------------------

  /// Возвращает все пройденные уровни.
  Future<List<Progress>> getAllProgress() async {
    final entries = await select(progressEntries).get();
    return entries.map(_entryToProgress).toList();
  }

  /// Сохраняет запись о прохождении уровня.
  Future<void> saveProgress(Progress progress) async {
    await into(progressEntries).insertOnConflictUpdate(
      ProgressEntriesCompanion.insert(
        levelId: progress.levelId,
        completedAt: progress.completedAt.millisecondsSinceEpoch,
      ),
    );
  }

  /// Удаляет запись о прохождении уровня.
  Future<void> deleteProgress(String levelId) async {
    await (delete(progressEntries)..where((t) => t.levelId.equals(levelId)))
        .go();
  }

  // ---------------------------------------------------------------------------
  // Преобразование
  // ---------------------------------------------------------------------------

  Progress _entryToProgress(ProgressEntry entry) {
    return Progress(
      levelId: entry.levelId,
      completedAt: DateTime.fromMillisecondsSinceEpoch(entry.completedAt),
    );
  }
}
