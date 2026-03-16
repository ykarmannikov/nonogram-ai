# Git Workflow

## Ветковая стратегия

Проект использует **Feature Branch Workflow**.

- `main` — защищённая ветка. Всегда содержит стабильный, прошедший CI код.
- Вся разработка ведётся в **feature-ветках**.

### Именование веток

```
feature/<краткое-описание>
```

Примеры:
```
feature/new-level-system
feature/ui-improvements
feature/puzzle-engine-refactor
feature/progress-sync
```

---

## Стандартный процесс разработки

```bash
# 1. Создать feature-ветку от актуального main
git checkout main
git pull origin main
git checkout -b feature/my-change

# 2. Реализовать изменения
# ... код ...

# 3. Убедиться, что CI пройдёт локально
flutter pub run build_runner build --delete-conflicting-outputs
dart format lib/ test/
flutter analyze --fatal-infos
flutter test

# 4. Запушить ветку
git push origin feature/my-change

# 5. Открыть Pull Request на GitHub: feature/my-change → main
# 6. Дождаться зелёного CI
# 7. Смержить PR (squash или merge commit)
```

---

## Требования к Pull Request

Каждый PR должен:

| Проверка | Команда в CI |
|----------|-------------|
| Форматирование | `dart format --set-exit-if-changed lib/ test/` |
| Статический анализ | `flutter analyze --fatal-infos` |
| Тесты | `flutter test` |
| Генерация кода | `build_runner build` (перед analyze/test) |

**PR нельзя смержить, если CI красный.**

---

## Защита ветки main (Branch Protection Rules)

Настраивается вручную в GitHub UI:

**Settings → Branches → Add branch protection rule → Branch name pattern: `main`**

Включить следующие опции:

| Опция | Зачем |
|-------|-------|
| ✅ Require a pull request before merging | Запрещает прямые пуши в main |
| ✅ Require approvals (1+) | Код-ревью перед мержем |
| ✅ Require status checks to pass before merging | CI должен быть зелёным |
| ✅ Require branches to be up to date before merging | Ветка должна быть актуальной |
| ✅ Do not allow bypassing the above settings | Даже для администраторов |

**Status checks для добавления:**
- `Analyze & Test` (из `flutter_ci.yml`)

---

## Запреты

- **Нельзя** пушить напрямую в `main`
- **Нельзя** мержить PR с красным CI
- **Нельзя** использовать `--force` push на `main`
- **Нельзя** коммитить `build/`, `.dart_tool/`, `*.g.dart` (покрыты `.gitignore`)

---

## CI pipeline

Описан в `ci.md`. Запускается автоматически на каждый `push` и `pull_request`.
