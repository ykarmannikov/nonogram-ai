import 'package:flutter/material.dart';
import 'package:nngram/entities/cell_state.dart';
import 'package:nngram/entities/game_state.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final puzzle = gameState.puzzle;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: puzzle.width,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: puzzle.width * puzzle.height,
      itemBuilder: (context, index) {
        final row = index ~/ puzzle.width;
        final col = index % puzzle.width;
        final cellState = gameState.playerGrid[row][col];

        return GestureDetector(
          onTap: () => onCellTap(row, col),
          child: _CellWidget(
            state: cellState,
            size: cellSize,
            filledColor: colorScheme.primary,
            emptyColor: colorScheme.surfaceContainerHighest,
          ),
        );
      },
    );
  }
}

class _CellWidget extends StatelessWidget {
  const _CellWidget({
    required this.state,
    required this.size,
    required this.filledColor,
    required this.emptyColor,
  });

  final CellState state;
  final double size;
  final Color filledColor;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: state == CellState.filled ? filledColor : emptyColor,
        border: Border.all(color: Colors.grey.shade400, width: 0.5),
      ),
      child: state == CellState.cross
          ? Icon(Icons.close, size: size * 0.6, color: Colors.red.shade400)
          : null,
    );
  }
}
