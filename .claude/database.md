# База данных

## Технология

SQLite через **Drift** (`drift` + `drift_flutter` + `sqlite3_flutter_libs`).

## Схема (version 2)

### Таблица `progress_entries`

| Столбец        | Тип     | Ограничение  | Описание                              |
|----------------|---------|--------------|---------------------------------------|
| `level_id`     | TEXT    | PRIMARY KEY  | ID уровня                             |
| `is_completed` | INTEGER | DEFAULT 0    | 1 если уровень пройден                |
| `is_unlocked`  | INTEGER | DEFAULT 0    | 1 если уровень разблокирован          |
| `completed_at` | INTEGER | nullable     | Unix-время прохождения (ms epoch)     |

Запись создаётся при инициализации прогресса. Наличие записи не означает прохождение — нужно смотреть на `is_completed`.

## История миграций

### v1 → v2

Добавлены столбцы `is_completed` и `is_unlocked`.
Старые записи (все были completed) получают `is_completed=1, is_unlocked=1`.

```dart
MigrationStrategy(
  onUpgrade: (m, from, to) async {
    if (from < 2) {
      await m.addColumn(progressEntries, progressEntries.isCompleted);
      await m.addColumn(progressEntries, progressEntries.isUnlocked);
      await customStatement(
        'UPDATE progress_entries SET is_completed = 1, is_unlocked = 1',
      );
    }
  },
);
```

## Конфигурация Drift

**Файл:** `lib/core/database/app_database.dart`

```dart
@DriftDatabase(tables: [ProgressEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'nngram'));

  @override
  int get schemaVersion => 2;
}
```

`driftDatabase(name: 'nngram')` из пакета `drift_flutter` автоматически выбирает правильный путь для хранения файла БД на каждой платформе.

## Правила при изменении схемы

1. Увеличить `schemaVersion`.
2. Добавить ветку в `MigrationStrategy.onUpgrade`.
3. Задокументировать изменение в этом файле.
4. Запустить `build_runner build` для регенерации `app_database.g.dart`.
