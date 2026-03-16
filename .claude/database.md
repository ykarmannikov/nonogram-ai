# База данных

## Технология

SQLite через **Drift** (`drift` + `drift_flutter` + `sqlite3_flutter_libs`).

## Схема

### Таблица `progress_entries`

| Столбец        | Тип     | Ограничение  | Описание                          |
|----------------|---------|--------------|-----------------------------------|
| `level_id`     | TEXT    | PRIMARY KEY  | ID уровня                         |
| `completed_at` | INTEGER |              | Unix-время прохождения (ms epoch) |

### Почему такая минимальная схема

**Принцип: хранить только факты, не производные состояния.**

- **Подсказки не хранятся** — генерируются из `solution` при загрузке. Хранение привело бы к риску рассинхронизации.
- **Разблокованные уровни не хранятся** — вычисляются динамически на основе `progress`.
- **Состояние игры не хранятся** — нет сохранения прерванной партии в MVP. При возврате игра начинается заново.

### Почему INTEGER для времени

Dart `DateTime.millisecondsSinceEpoch` → хранить как `INTEGER`. При чтении: `DateTime.fromMillisecondsSinceEpoch(completedAt)`. Простой и эффективный формат без зависимостей от формата строки.

## Конфигурация Drift

**Файл:** `lib/core/database/app_database.dart`

```dart
@DriftDatabase(tables: [ProgressEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'nngram'));

  @override
  int get schemaVersion => 1;
}
```

`driftDatabase(name: 'nngram')` из пакета `drift_flutter` автоматически выбирает правильный путь для хранения файла БД на каждой платформе.

## Миграции

При изменении схемы:
1. Увеличить `schemaVersion`.
2. Добавить `MigrationStrategy` в `AppDatabase.migration`.
3. Задокументировать изменение в `decisions.md`.
