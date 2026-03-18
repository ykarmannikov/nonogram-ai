import 'package:flutter/material.dart';
import 'package:nngram/entities/cell_state.dart';
import 'package:nngram/entities/game_mode.dart';
import 'package:nngram/entities/game_state.dart';
import 'package:nngram/shared/ui/app_colors.dart';
import 'package:nngram/shared/utils/platform_utils.dart';

/// Игровое поле — сетка ячеек.
///
/// Поддерживает одиночный tap и drag-to-fill. При drag действие
/// определяется один раз по первой ячейке и применяется ко всем последующим.
class PuzzleGrid extends StatefulWidget {
  const PuzzleGrid({
    super.key,
    required this.gameState,
    required this.cellSize,
    required this.onCellApply,
  });

  final GameState gameState;
  final double cellSize;

  /// Вызывается при tap или drag на ячейку (row, col) с целевым состоянием.
  final void Function(int row, int col, CellState targetState) onCellApply;

  @override
  State<PuzzleGrid> createState() => _PuzzleGridState();
}

class _PuzzleGridState extends State<PuzzleGrid> {
  final _processed = <(int, int)>{};
  CellState? _dragTarget;

  /// Переводит локальную позицию в (row, col). Null если вне bounds.
  (int, int)? _cellAt(Offset local) {
    final col = (local.dx / widget.cellSize).floor();
    final row = (local.dy / widget.cellSize).floor();
    final puzzle = widget.gameState.puzzle;
    if (row < 0 || row >= puzzle.height || col < 0 || col >= puzzle.width) {
      return null;
    }
    return (row, col);
  }

  /// Целевое состояние по текущему значению ячейки и активному режиму.
  CellState _determineDragTarget(CellState current) {
    return switch (widget.gameState.mode) {
      GameMode.fill =>
        current == CellState.filled ? CellState.empty : CellState.filled,
      GameMode.cross =>
        current == CellState.cross ? CellState.empty : CellState.cross,
    };
  }

  void _onPointerDown(PointerDownEvent event) {
    final cell = _cellAt(event.localPosition);
    if (cell == null) return;
    final (row, col) = cell;
    final current = widget.gameState.playerGrid[row][col];
    _dragTarget = _determineDragTarget(current);
    _processed
      ..clear()
      ..add((row, col));
    PlatformUtils.triggerCellTap();
    widget.onCellApply(row, col, _dragTarget!);
  }

  void _onPointerMove(PointerMoveEvent event) {
    final target = _dragTarget;
    if (target == null) return;
    final cell = _cellAt(event.localPosition);
    if (cell == null) return;
    if (_processed.contains(cell)) return;
    _processed.add(cell);
    PlatformUtils.triggerCellTap();
    widget.onCellApply(cell.$1, cell.$2, target);
  }

  void _onPointerUp(PointerUpEvent event) {
    _processed.clear();
    _dragTarget = null;
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = widget.gameState.puzzle;

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(puzzle.height, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(puzzle.width, (col) {
              return _CellWidget(
                state: widget.gameState.playerGrid[row][col],
                size: widget.cellSize,
                border: _cellBorder(row, col, puzzle.height, puzzle.width),
              );
            }),
          );
        }),
      ),
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: size,
      height: size,
      decoration: BoxDecoration(color: bgColor, border: border),
      child: child,
    );
  }
}
