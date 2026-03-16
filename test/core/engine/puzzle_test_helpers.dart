import 'package:nngram/core/engine/puzzle_engine.dart';
import 'package:nngram/entities/cell_state.dart';
import 'package:nngram/entities/game_mode.dart';
import 'package:nngram/entities/game_state.dart';
import 'package:nngram/entities/puzzle.dart';

/// Строит [Puzzle] из матрицы решения.
///
/// Подсказки генерируются через [PuzzleEngine] — их корректность
/// проверяется отдельными тестами в generate_row_hints_test.dart
/// и generate_column_hints_test.dart.
Puzzle buildPuzzle(List<List<int>> solution) {
  return Puzzle(
    id: 'test',
    difficulty: 'easy',
    width: solution.isEmpty ? 0 : solution[0].length,
    height: solution.length,
    solution: solution,
    rowHints: PuzzleEngine.generateRowHints(solution),
    colHints: PuzzleEngine.generateColumnHints(solution),
  );
}

/// Строит [GameState] из заданной сетки игрока.
GameState buildState({
  required Puzzle puzzle,
  required List<List<CellState>> playerGrid,
  GameMode mode = GameMode.fill,
}) {
  return GameState(
    puzzle: puzzle,
    playerGrid: playerGrid,
    mode: mode,
  );
}
