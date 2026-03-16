import 'package:flutter_test/flutter_test.dart';
import 'package:nngram/core/engine/puzzle_engine.dart';
import 'package:nngram/entities/cell_state.dart';
import 'package:nngram/entities/game_mode.dart';

import 'puzzle_test_helpers.dart';

void main() {
  group('PuzzleEngine.applyMove', () {
    // Общий пазл 2×2 для всех тестов группы.
    late final puzzle = buildPuzzle([
      [1, 0],
      [0, 1]
    ]);

    test(
      'fill режим: тап по пустой ячейке закрашивает её (empty → filled)',
      () {
        final state = buildState(
          puzzle: puzzle,
          playerGrid: [
            [CellState.empty, CellState.empty],
            [CellState.empty, CellState.empty],
          ],
          mode: GameMode.fill,
        );

        final result = PuzzleEngine.applyMove(state, 0, 0);

        expect(result.playerGrid[0][0], CellState.filled);
      },
    );

    test(
      'fill режим: повторный тап по закрашенной ячейке снимает закраску (filled → empty)',
      () {
        final state = buildState(
          puzzle: puzzle,
          playerGrid: [
            [CellState.filled, CellState.empty],
            [CellState.empty, CellState.empty],
          ],
          mode: GameMode.fill,
        );

        final result = PuzzleEngine.applyMove(state, 0, 0);

        expect(result.playerGrid[0][0], CellState.empty);
      },
    );

    test(
      'cross режим: тап по пустой ячейке ставит крест (empty → cross)',
      () {
        final state = buildState(
          puzzle: puzzle,
          playerGrid: [
            [CellState.empty, CellState.empty],
            [CellState.empty, CellState.empty],
          ],
          mode: GameMode.cross,
        );

        final result = PuzzleEngine.applyMove(state, 1, 0);

        expect(result.playerGrid[1][0], CellState.cross);
      },
    );

    test(
      'cross режим: повторный тап по ячейке с крестом убирает крест (cross → empty)',
      () {
        final state = buildState(
          puzzle: puzzle,
          playerGrid: [
            [CellState.empty, CellState.empty],
            [CellState.cross, CellState.empty],
          ],
          mode: GameMode.cross,
        );

        final result = PuzzleEngine.applyMove(state, 1, 0);

        expect(result.playerGrid[1][0], CellState.empty);
      },
    );

    test(
      'только целевая ячейка изменяется, все остальные остаются нетронутыми',
      () {
        final state = buildState(
          puzzle: puzzle,
          playerGrid: [
            [CellState.empty, CellState.filled],
            [CellState.cross, CellState.empty],
          ],
          mode: GameMode.fill,
        );

        // Меняем только [0][0]
        final result = PuzzleEngine.applyMove(state, 0, 0);

        expect(result.playerGrid[0][0], CellState.filled,
            reason: 'целевая ячейка изменилась');
        expect(result.playerGrid[0][1], CellState.filled,
            reason: '[0][1] не затронута');
        expect(result.playerGrid[1][0], CellState.cross,
            reason: '[1][0] не затронута');
        expect(result.playerGrid[1][1], CellState.empty,
            reason: '[1][1] не затронута');
      },
    );
  });
}
