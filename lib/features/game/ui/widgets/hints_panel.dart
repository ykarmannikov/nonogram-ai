import 'package:flutter/material.dart';
import 'package:nngram/shared/ui/app_colors.dart';
import 'package:nngram/shared/ui/app_spacing.dart';

/// Виджет подсказок для одной линии (строки или столбца).
///
/// Отображает числа подсказок, разделённые пробелом.
class HintsPanel extends StatelessWidget {
  const HintsPanel({
    super.key,
    required this.hints,
    required this.cellSize,
    required this.axis,
  });

  /// Подсказки: список списков чисел.
  final List<List<int>> hints;

  /// Размер одной ячейки игрового поля.
  final double cellSize;

  /// [Axis.horizontal] — столбцовые подсказки (сверху),
  /// [Axis.vertical] — строчные подсказки (слева).
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (axis == Axis.horizontal) {
      // Подсказки для столбцов — горизонтальный ряд.
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: hints.map((colHints) {
          return SizedBox(
            width: cellSize,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: colHints
                  .map(
                    (n) => Text(
                      '$n',
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.hintText),
                      textAlign: TextAlign.center,
                    ),
                  )
                  .toList(),
            ),
          );
        }).toList(),
      );
    } else {
      // Подсказки для строк — вертикальный столбец.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: hints.map((rowHints) {
          return SizedBox(
            height: cellSize,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: rowHints
                  .map(
                    (n) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      child: Text(
                        '$n',
                        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.hintText),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }).toList(),
      );
    }
  }
}
