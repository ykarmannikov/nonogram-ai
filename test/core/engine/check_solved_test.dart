import 'package:flutter_test/flutter_test.dart';
import 'package:nngram/core/engine/puzzle_engine.dart';
import 'package:nngram/entities/cell_state.dart';

import 'puzzle_test_helpers.dart';

void main() {
  group('PuzzleEngine.checkSolved', () {
    test(
      'сетка точно совпадает с решением → isSolved = true',
      () {
        final puzzle = buildPuzzle([
          [1, 0],
          [0, 1]
        ]);
        final state = buildState(
          puzzle: puzzle,
          playerGrid: [
            [CellState.filled, CellState.empty],
            [CellState.empty, CellState.filled],
          ],
        );

        expect(PuzzleEngine.checkSolved(state).isSolved, isTrue);
      },
    );

    test(
      'полностью пустая сетка при непустом решении → isSolved = false',
      () {
        final puzzle = buildPuzzle([
          [1, 0],
          [0, 1]
        ]);
        final state = buildState(
          puzzle: puzzle,
          playerGrid: [
            [CellState.empty, CellState.empty],
            [CellState.empty, CellState.empty],
          ],
        );

        expect(PuzzleEngine.checkSolved(state).isSolved, isFalse);
      },
    );

    test(
      'одна лишняя закрашенная ячейка блокирует победу → isSolved = false',
      () {
        // Решение: [0][0] и [1][1]. Игрок закрасил лишнюю [0][1].
        final puzzle = buildPuzzle([
          [1, 0],
          [0, 1]
        ]);
        final state = buildState(
          puzzle: puzzle,
          playerGrid: [
            [CellState.filled, CellState.filled], // [0][1] — лишняя
            [CellState.empty, CellState.filled],
          ],
        );

        expect(PuzzleEngine.checkSolved(state).isSolved, isFalse);
      },
    );

    test(
      'кресты на пустых по решению ячейках не мешают победе → isSolved = true',
      () {
        // Игрок правильно пометил пустые ячейки крестами — это допустимо.
        final puzzle = buildPuzzle([
          [1, 0],
          [0, 1]
        ]);
        final state = buildState(
          puzzle: puzzle,
          playerGrid: [
            [CellState.filled, CellState.cross], // cross на пустой
            [CellState.cross, CellState.filled], // cross на пустой
          ],
        );

        expect(PuzzleEngine.checkSolved(state).isSolved, isTrue);
      },
    );

    test(
      'полностью решённый 5×5 паттерн «крест» → isSolved = true',
      () {
        final solution = [
          [0, 0, 1, 0, 0],
          [0, 0, 1, 0, 0],
          [1, 1, 1, 1, 1],
          [0, 0, 1, 0, 0],
          [0, 0, 1, 0, 0],
        ];
        final puzzle = buildPuzzle(solution);
        final playerGrid = solution
            .map(
              (row) => row
                  .map((c) => c == 1 ? CellState.filled : CellState.empty)
                  .toList(),
            )
            .toList();
        final state = buildState(puzzle: puzzle, playerGrid: playerGrid);

        expect(PuzzleEngine.checkSolved(state).isSolved, isTrue);
      },
    );
  });
}
