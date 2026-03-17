import 'package:nngram/entities/cell_state.dart';
import 'package:nngram/entities/game_mode.dart';
import 'package:nngram/entities/game_state.dart';
import 'package:nngram/entities/puzzle.dart';

/// Игровой движок.
///
/// Содержит всю бизнес-логику игры: генерацию подсказок,
/// применение ходов и проверку победы.
/// Все методы — чистые функции (pure functions).
class PuzzleEngine {
  PuzzleEngine._();

  // ---------------------------------------------------------------------------
  // Построение пазла из JSON
  // ---------------------------------------------------------------------------

  /// Создаёт [Puzzle] из JSON-данных уровня.
  ///
  /// Генерирует подсказки из [solution] в runtime.
  static Puzzle buildFromJson(Map<String, dynamic> json) {
    final rawRows = json['solution'] as List<dynamic>;
    final solution = rawRows
        .map((row) => (row as List<dynamic>).map((c) => c as int).toList())
        .toList();

    return Puzzle(
      id: json['id'] as String,
      title: json['title'] as String,
      difficulty: json['difficulty'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      solution: solution,
      rowHints: generateRowHints(solution),
      colHints: generateColumnHints(solution),
    );
  }

  // ---------------------------------------------------------------------------
  // Генерация подсказок
  // ---------------------------------------------------------------------------

  /// Генерирует подсказки для каждой строки.
  static List<List<int>> generateRowHints(List<List<int>> solution) {
    return solution.map(_generateLineHints).toList();
  }

  /// Генерирует подсказки для каждого столбца.
  static List<List<int>> generateColumnHints(List<List<int>> solution) {
    if (solution.isEmpty) return [];
    final width = solution[0].length;
    return List.generate(width, (col) {
      final column = solution.map((row) => row[col]).toList();
      return _generateLineHints(column);
    });
  }

  /// Генерирует подсказки для одной линии (строки или столбца).
  ///
  /// Возвращает [0], если в линии нет закрашенных ячеек.
  static List<int> _generateLineHints(List<int> line) {
    final hints = <int>[];
    var count = 0;

    for (final cell in line) {
      if (cell == 1) {
        count++;
      } else if (count > 0) {
        hints.add(count);
        count = 0;
      }
    }

    if (count > 0) hints.add(count);
    if (hints.isEmpty) hints.add(0);

    return hints;
  }

  // ---------------------------------------------------------------------------
  // Игровые операции
  // ---------------------------------------------------------------------------

  /// Применяет ход игрока к ячейке (row, col).
  ///
  /// В режиме [GameMode.fill] переключает между [CellState.filled] и
  /// [CellState.empty]. В режиме [GameMode.cross] — между [CellState.cross]
  /// и [CellState.empty].
  static GameState applyMove(GameState state, int row, int col) {
    // Копируем сетку, чтобы не мутировать состояние.
    final grid = state.playerGrid.map((r) => List<CellState>.from(r)).toList();

    final current = grid[row][col];

    grid[row][col] = switch (state.mode) {
      GameMode.fill =>
        current == CellState.filled ? CellState.empty : CellState.filled,
      GameMode.cross =>
        current == CellState.cross ? CellState.empty : CellState.cross,
    };

    return state.copyWith(playerGrid: grid);
  }

  /// Проверяет, решена ли головоломка.
  ///
  /// Победа: все ячейки [playerGrid] с [CellState.filled] точно
  /// совпадают с ячейками [solution] со значением 1.
  static GameState checkSolved(GameState state) {
    final solution = state.puzzle.solution;
    final grid = state.playerGrid;

    for (var row = 0; row < solution.length; row++) {
      for (var col = 0; col < solution[row].length; col++) {
        final shouldBeFilled = solution[row][col] == 1;
        final isFilled = grid[row][col] == CellState.filled;
        if (shouldBeFilled != isFilled) {
          return state.copyWith(isSolved: false);
        }
      }
    }

    return state.copyWith(isSolved: true);
  }

  // ---------------------------------------------------------------------------
  // Вспомогательные операции
  // ---------------------------------------------------------------------------

  /// Создаёт пустую сетку игрока для заданного пазла.
  static List<List<CellState>> createEmptyGrid(Puzzle puzzle) {
    return List.generate(
      puzzle.height,
      (_) => List.generate(puzzle.width, (_) => CellState.empty),
    );
  }
}
