# Антипаттерны

## 1. Бизнес-логика в виджетах

**Нельзя** вычислять победу, генерировать подсказки или фильтровать уровни прямо в `build()`.

Вся логика — в `PuzzleEngine`, `GameNotifier`, репозиториях.

---

## 2. Мутация состояния напрямую

**Нельзя:**
```dart
state.playerGrid[row][col] = CellState.filled; // мутация!
```

**Нужно:**
```dart
final grid = state.playerGrid.map((r) => List<CellState>.from(r)).toList();
grid[row][col] = CellState.filled;
state = state.copyWith(playerGrid: grid);
```

---

## 3. Хранение производных данных в БД

Не сохранять в `progress_entries` данные, которые можно вычислить:
- Подсказки
- Количество ходов
- Флаг «доступен ли следующий уровень»

---

## 4. Фичи импортируют другие фичи напрямую

**Нельзя:**
```dart
// В features/game/
import 'package:nngram/features/progress/repository/progress_repository.dart';
```

**Нужно:** использовать `progressProvider` из `features/progress/state/progress_provider.dart`.

---

## 5. `shared` знает о фичах

Виджеты в `shared/widgets/` не должны принимать `Puzzle`, `GameState` или другие доменные типы. Они работают с примитивами и коллбэками.

---

## 6. Нарушение направления зависимостей

```
entities → core       ← НЕЛЬЗЯ
features → shared     ← НЕЛЬЗЯ
app → entities        ← НЕЛЬЗЯ напрямую (только через features)
```

---

## 7. Оверинжиниринг для MVP

Не добавлять:
- Абстрактные интерфейсы для репозиториев (достаточно конкретных классов)
- Dependency Injection фреймворки поверх Riverpod
- Generic-решения для одиночных случаев
