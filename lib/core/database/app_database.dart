import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:nngram/entities/progress.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Таблицы
// ---------------------------------------------------------------------------

/// Таблица прогресса уровней.
///
/// Каждая запись хранит состояние разблокировки и прохождения уровня.
class ProgressEntries extends Table {
  TextColumn get levelId => text()();
  IntColumn get isCompleted => integer().withDefault(const Constant(0))();
  IntColumn get isUnlocked => integer().withDefault(const Constant(0))();
  IntColumn get completedAt => integer().nullable()();

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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(progressEntries, progressEntries.isCompleted);
            await m.addColumn(progressEntries, progressEntries.isUnlocked);
            // Старые записи (completed) получают isCompleted=1, isUnlocked=1
            await customStatement(
              'UPDATE progress_entries SET is_completed = 1, is_unlocked = 1',
            );
          }
        },
      );

  // ---------------------------------------------------------------------------
  // Запросы прогресса
  // ---------------------------------------------------------------------------

  /// Возвращает все записи прогресса.
  Future<List<Progress>> getAllProgress() async {
    final entries = await select(progressEntries).get();
    return entries.map(_entryToProgress).toList();
  }

  /// Разблокирует уровень (создаёт запись если её нет).
  Future<void> setUnlocked(String levelId) async {
    await into(progressEntries).insertOnConflictUpdate(
      ProgressEntriesCompanion(
        levelId: Value(levelId),
        isUnlocked: const Value(1),
      ),
    );
  }

  /// Помечает уровень как пройденный.
  Future<void> setCompleted(String levelId) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await into(progressEntries).insertOnConflictUpdate(
      ProgressEntriesCompanion(
        levelId: Value(levelId),
        isCompleted: const Value(1),
        isUnlocked: const Value(1),
        completedAt: Value(now),
      ),
    );
  }

  /// Инициализирует записи для всех уровней при первом запуске.
  Future<void> initializeAll(
    List<String> levelIds,
    String firstUnlockedId,
  ) async {
    for (final id in levelIds) {
      await into(progressEntries).insertOnConflictUpdate(
        ProgressEntriesCompanion(
          levelId: Value(id),
          isUnlocked: Value(id == firstUnlockedId ? 1 : 0),
        ),
      );
    }
  }

  /// Удаляет запись прогресса.
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
      isCompleted: entry.isCompleted == 1,
      isUnlocked: entry.isUnlocked == 1,
      completedAt: entry.completedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(entry.completedAt!)
          : null,
    );
  }
}
