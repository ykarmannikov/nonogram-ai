import 'package:flutter/material.dart';
import 'package:nngram/entities/cell_state.dart';
import 'package:nngram/entities/game_state.dart';
import 'package:nngram/shared/ui/app_colors.dart';

/// Игровое поле — сетка ячеек.
class PuzzleGrid extends StatelessWidget {
  const PuzzleGrid({
    super.key,
    required this.gameState,
    required this.cellSize,
    required this.onCellTap,
  });

  final GameState gameState;
  final double cellSize;

  /// Вызывается при нажатии на ячейку (row, col).
  final void Function(int row, int col) onCellTap;

  @override
  Widget build(BuildContext context) {
    final puzzle = gameState.puzzle;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(puzzle.height, (row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(puzzle.width, (col) {
            final cellState = gameState.playerGrid[row][col];
            return GestureDetector(
              onTap: () => onCellTap(row, col),
              child: _CellWidget(
                state: cellState,
                size: cellSize,
                border: _cellBorder(row, col, puzzle.height, puzzle.width),
              ),
            );
          }),
        );
      }),
    );
  }

  static Border _cellBorder(int row, int col, int rows, int cols) {
    const thin = BorderSide(color: AppColors.gridLine, width: 0.5);
    const thick = BorderSide(color: AppColors.gridLineThick, width: 1.5);

    return Border(
      top: row % 5 == 0 ? thick : thin,
      left: col % 5 == 0 ? thick : thin,
      bottom: row == rows - 1 ? thick : BorderSide.none,
      right: col == cols - 1 ? thick : BorderSide.none,
    );
  }
}

class _CellWidget extends StatelessWidget {
  const _CellWidget({
    required this.state,
    required this.size,
    required this.border,
  });

  final CellState state;
  final double size;
  final Border border;

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    Widget? child;

    switch (state) {
      case CellState.filled:
        bgColor = AppColors.filled;
      case CellState.cross:
        bgColor = AppColors.gridBackground;
        child = Center(
          child: Text(
            '✕',
            style: TextStyle(
              fontSize: size * 0.55,
              color: AppColors.cross,
              height: 1,
            ),
          ),
        );
      case CellState.empty:
        bgColor = AppColors.gridBackground;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bgColor, border: border),
      child: child,
    );
  }
}
