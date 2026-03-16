# CI/CD

## Пайплайны

В проекте два pipeline:

| Файл | Назначение | Триггер |
|------|-----------|---------|
| `flutter_ci.yml` | Полная проверка + сборка APK | push и PR на любую ветку |
| `pr_checks.yml` | Быстрые проверки перед мержем | PR → `main` |

---

## flutter_ci.yml — Полная проверка

**Триггеры:** `push` и `pull_request` на любую ветку.

**Шаги:**

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
| 9 | Сборка APK | `flutter build apk --debug` |
| 10 | Upload artifact | `actions/upload-artifact@v4` → `debug-apk` |

**Зачем APK artifact:**
Скомпилированный `.apk` доступен для скачивания прямо из интерфейса GitHub Actions (вкладка Summary → Artifacts). Позволяет тестировать реальную сборку без локальной компиляции — удобно для QA и ревьюеров PR.

Путь артефакта: `build/app/outputs/flutter-apk/app-debug.apk`

---

## pr_checks.yml — Быстрые PR-проверки

**Триггер:** `pull_request` → `main` (только при мерже в main).

**Шаги:**

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

Без сборки APK — пайплайн завершается быстрее. Именно этот пайплайн должен быть зелёным, чтобы PR можно было смержить (branch protection rule).

**Почему build_runner нельзя убрать:**
Freezed и Drift генерируют `.freezed.dart` и `.g.dart` файлы. Они исключены из `.gitignore`, поэтому в репозитории отсутствуют. Без генерации `flutter analyze` и `flutter test` падают с ошибками компиляции.

---

## Почему `build_runner` идёт до analyze и test

`Puzzle`, `GameState`, `Progress` — `@freezed`-классы. Без `.freezed.dart`-файлов компилятор не найдёт `copyWith`, `==`, `hashCode`. Аналогично для Drift-таблиц (`.g.dart`).

**Порядок нарушать нельзя:** `pub get` → `build_runner` → `format/analyze/test`.

---

## Кэш pub-зависимостей

Оба пайплайна кэшируют `~/.pub-cache` по ключу `pubspec.lock`. При неизменных зависимостях шаги `pub get` и `build_runner` работают значительно быстрее.

---

## Локальный запуск

```bash
# Полный цикл как в flutter_ci.yml
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
dart format --set-exit-if-changed lib/ test/
flutter analyze --fatal-infos
flutter test
flutter build apk --debug
```

```bash
# Только тесты (если генерация уже выполнена)
flutter test
```

---

## Добавление нового шага в CI

1. Открой нужный workflow (`.github/workflows/`)
2. Добавь шаг в нужную позицию (шаги, требующие сборки — после `build_runner`)
3. Задокументируй изменение в этом файле

---

## Форматирование в CI

`dart format --set-exit-if-changed lib/ test/` возвращает exit code 1, если хоть один файл отформатировался иначе.

**Правило:** перед коммитом всегда запускай `dart format lib/ test/` локально.
