# Контекст разработки

## Текущая стадия

**Скелет проекта.** Вся архитектура и файловая структура созданы. Кодогенерация ещё не запущена.

## Что сделано

- Файловая структура всех слоёв (`app`, `core`, `entities`, `features`, `shared`)
- Все доменные модели (`Puzzle`, `GameState`, `Progress`, `CellState`, `GameMode`)
- Игровой движок (`PuzzleEngine`)
- База данных (`AppDatabase` с таблицей `progress_entries`)
- Все провайдеры Riverpod
- Все три экрана (`DifficultyScreen`, `LevelSelectScreen`, `GameScreen`)
- Виджеты игрового поля (`PuzzleGrid`, `HintsPanel`, `GameToolbar`)
- Навигация через GoRouter
- Два примерных уровня в `assets/puzzles/`
- База знаний `.claude/`

## Что нужно сделать для запуска

1. `flutter pub get` — установить зависимости
2. `flutter pub run build_runner build --delete-conflicting-outputs` — кодогенерация Freezed и Drift
3. `flutter run` — запуск

## Следующие шаги MVP

Смотри `tasks.md`.

## Известные ограничения скелета

- Нет обработки ошибок при загрузке assets (если файл не найден — краш)
- `GridView` в `GameScreen` использует `shrinkWrap: true` — для больших сеток возможна неоптимальная производительность
- Нет локализации (только русский язык в UI)
