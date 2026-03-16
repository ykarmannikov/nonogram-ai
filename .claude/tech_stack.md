# Технологический стек

## Flutter

- Версия: Flutter 3.x, Dart >= 3.0
- Material 3 (`useMaterial3: true`)
- Целевые платформы: Android, iOS (возможно Desktop в будущем)

## Управление состоянием: flutter_riverpod ^2.5.1

Riverpod выбран за:
- Compile-safe провайдеры (нет `context.read` с рисками runtime-ошибок)
- `StateNotifier` для сложного мутабельного состояния (`GameNotifier`, `ProgressNotifier`)
- `FutureProvider.family` для асинхронной загрузки уровней по параметру

## Навигация: go_router ^13.2.0

GoRouter выбран за:
- Декларативные маршруты
- Поддержку deep links
- Простую интеграцию с Riverpod через `ref.read` вне контекста навигации

## База данных: drift ^2.18.0

Drift (ранее Moor) выбран за:
- Типобезопасные SQL-запросы
- Кодогенерацию (нет raw strings для таблиц)
- Простую интеграцию с Flutter через `drift_flutter`

Зависимости: `drift_flutter ^0.2.0`, `sqlite3_flutter_libs ^0.5.24`

## Иммутабельные модели: freezed ^2.5.2

Freezed обеспечивает:
- `copyWith` без boilerplate
- `==` и `hashCode` по значению
- `@Default` для опциональных полей
- JSON-сериализацию через `json_serializable`

## Кодогенерация

Запуск: `flutter pub run build_runner build --delete-conflicting-outputs`

Генерирует:
- `*.freezed.dart` — иммутабельные классы
- `*.g.dart` — JSON-сериализация и Drift DAL

## Анализ кода

`flutter_lints ^3.0.0` + правила в `analysis_options.yaml`.
