# CI/CD

## Пайплайн

Файл: `.github/workflows/flutter_ci.yml`

Триггеры: `push` и `pull_request` на любую ветку.

### Шаги в порядке выполнения

| № | Шаг | Команда |
|---|-----|---------|
| 1 | Checkout | `actions/checkout@v4` |
| 2 | Кэш pub | `actions/cache@v3` по хэшу `pubspec.lock` |
| 3 | Flutter stable | `subosito/flutter-action@v2` |
| 4 | Зависимости | `flutter pub get` |
| 5 | Кодогенерация | `flutter pub run build_runner build --delete-conflicting-outputs` |
| 6 | Форматирование | `dart format --set-exit-if-changed lib/ test/` |
| 7 | Анализ | `flutter analyze --fatal-infos` |
| 8 | Тесты | `flutter test` |

### Почему `build_runner` идёт до analyze и test

`PuzzleState`, `Puzzle`, `Progress` — `@freezed`-классы. Без `.freezed.dart`-файлов компилятор не найдёт `copyWith`, `==`, `hashCode` и `.g.dart`-файлы Drift. Анализатор и тесты упадут с ошибками импорта.

**Порядок нарушать нельзя:** `pub get` → `build_runner` → `format/analyze/test`.

---

## Локальный запуск

```bash
# Полный цикл как в CI
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
dart format --set-exit-if-changed lib/ test/
flutter analyze --fatal-infos
flutter test
```

```bash
# Только тесты (если генерация уже выполнена)
flutter test
```

---

## Добавление нового шага в CI

1. Открой `.github/workflows/flutter_ci.yml`
2. Добавь шаг после `flutter pub get` (но до `format/analyze/test` если требует сборки)
3. Документируй изменение в этом файле

---

## Форматирование в CI

`dart format --set-exit-if-changed lib/ test/` возвращает exit code 1, если хоть один файл отформатировался иначе.

**Правило:** перед коммитом всегда запускай `dart format lib/ test/` локально.
