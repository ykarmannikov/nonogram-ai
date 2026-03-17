# UI Guidelines

## 1. Общие принципы

- **Минимализм** — никаких лишних декораций. Только то, что помогает игроку.
- **Читаемость** — контраст текста, чёткие границы ячеек, предсказуемые состояния.
- **Консистентность** — одинаковые цвета, отступы и компоненты везде в приложении.

---

## 2. Цвета

Использовать только `AppColors` (`lib/shared/ui/app_colors.dart`). Хардкод цветов запрещён.

| Константа            | Hex         | Назначение                        |
|----------------------|-------------|-----------------------------------|
| `background`         | `#F5F5F5`   | Фон экранов                       |
| `gridBackground`     | `#FFFFFF`   | Пустая ячейка, фон кросс-ячейки   |
| `filled`             | `#2C3E50`   | Закрашенная ячейка                |
| `gridLine`           | `#D0D0D0`   | Тонкая линия сетки                |
| `gridLineThick`      | `#9E9E9E`   | Толстая линия сетки (каждые 5)    |
| `cross`              | `#B0BEC5`   | Символ крестика                   |
| `hintText`           | `#546E7A`   | Цифры подсказок                   |

---

## 3. Отступы

Использовать только `AppSpacing` (`lib/shared/ui/app_spacing.dart`). Числа в `EdgeInsets` запрещены.

| Константа  | Значение | Когда использовать            |
|------------|----------|-------------------------------|
| `xs`       | 4.0      | Мелкие паддинги (hints)       |
| `s`        | 8.0      | Вертикальный паддинг toolbar  |
| `m`        | 12.0     | Средние промежутки            |
| `l`        | 16.0     | Горизонтальный паддинг toolbar, экранные паддинги |
| `xl`       | 24.0     | Крупные секции                |

---

## 4. Grid

- Тонкие линии: `AppColors.gridLine`, ширина `0.5`
- Толстые линии: `AppColors.gridLineThick`, ширина `1.5`
- Толстая линия ставится: сверху/слева если индекс кратен 5, снизу/справа у последней ячейки
- Реализация: `PuzzleGrid` использует `Column` + `Row` с `BoxDecoration.border` на каждой ячейке
- **Grid адаптивный** — `cellSize` вычисляется через `LayoutBuilder`, не хардкодится
- **Scroll запрещён** — grid всегда помещается в экран
- Формула: `cellSize = min(availW / cols, availH / rows)` — не `clamp`, не деление с фиксированным числом
- Все размеры в формуле — именованные константы (`_hintSize`, `_controlsHeight`, `AppSpacing.xl`)

---

## 5. Состояния ячейки

| Состояние  | Цвет фона              | Содержимое                              |
|------------|------------------------|-----------------------------------------|
| `empty`    | `AppColors.gridBackground` | —                                   |
| `filled`   | `AppColors.filled`     | —                                       |
| `cross`    | `AppColors.gridBackground` | Текст `'✕'`, цвет `AppColors.cross` |

Символ крестика — текст `'✕'`, размер `cellSize * 0.55`. Не использовать `Icons.close`.

---

## 6. Кнопки

Использовать `AppButton` (`lib/shared/ui/app_button.dart`).

```dart
// Primary (filled)
AppButton(label: 'Действие', onPressed: ..., icon: Icon(...))

// Secondary (outlined)
AppButton.secondary(label: 'Сброс', onPressed: ..., icon: Icon(...))
```

Не использовать `FilledButton` / `OutlinedButton` напрямую.

---

## 7. Переключатель режима ввода

Использовать `ModeControls` (`lib/features/game/ui/widgets/controls_widget.dart`).

- Всегда располагается **инлайн под гридом** — `Column(mainAxisSize: min)` с `SizedBox(height: AppSpacing.xl)` между гридом и controls
- Не использовать fixed bottom navigation bar или `bottomNavigationBar`
- Две кнопки: Fill (■) и Cross (✕), 56×56px, borderRadius 14
- **Toggle обязателен** — текущий режим всегда визуально выделен (filled bg + shadow)
- **Reset запрещён** — кнопку сброса не добавлять в UI

---

## 8. Запрещено

- Хардкод цветов: `Colors.red`, `Color(0xFF...)` вне `AppColors`
- Магические числа в отступах: `EdgeInsets.all(16)` → `EdgeInsets.all(AppSpacing.l)`
- Прямое использование `FilledButton` / `OutlinedButton` вне `AppButton`
- `SingleChildScrollView` в `GameScreen`
- Хардкод `cellSize` — только через `LayoutBuilder`
- Кнопка сброса поля в UI
- `clamp()` для вычисления `cellSize` — только `min()`
- Добавление новых стилей без обновления этого файла
