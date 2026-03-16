import 'package:flutter_test/flutter_test.dart';
import 'package:nngram/core/engine/puzzle_engine.dart';

void main() {
  group('PuzzleEngine.generateColumnHints', () {
    test(
      'паттерн «крест» 5×5: каждый столбец даёт верную подсказку',
      () {
        final solution = [
          [0, 0, 1, 0, 0],
          [0, 0, 1, 0, 0],
          [1, 1, 1, 1, 1],
          [0, 0, 1, 0, 0],
          [0, 0, 1, 0, 0],
        ];

        final hints = PuzzleEngine.generateColumnHints(solution);

        expect(hints[0], equals([1]),
            reason: 'столбец 0: одна ячейка в центре');
        expect(hints[1], equals([1]),
            reason: 'столбец 1: одна ячейка в центре');
        expect(hints[2], equals([5]),
            reason: 'столбец 2: все 5 ячеек заполнены');
        expect(hints[3], equals([1]),
            reason: 'столбец 3: одна ячейка в центре');
        expect(hints[4], equals([1]),
            reason: 'столбец 4: одна ячейка в центре');
      },
    );

    test(
      'столбец полностью пустой → подсказка [0]',
      () {
        final hints = PuzzleEngine.generateColumnHints([
          [0],
          [0],
          [0]
        ]);

        expect(hints[0], equals([0]));
      },
    );

    test(
      'столбец полностью заполнен → подсказка равна высоте столбца [4]',
      () {
        final hints = PuzzleEngine.generateColumnHints([
          [1],
          [1],
          [1],
          [1]
        ]);

        expect(hints[0], equals([4]));
      },
    );

    test(
      'несколько групп по вертикали: [1,1,0,1,0,1,1] → подсказка [2, 1, 2]',
      () {
        final solution = [
          [1],
          [1],
          [0],
          [1],
          [0],
          [1],
          [1]
        ];
        final hints = PuzzleEngine.generateColumnHints(solution);

        expect(hints[0], equals([2, 1, 2]));
      },
    );

    test(
      'пустой solution → результат пустой список (нет столбцов для обработки)',
      () {
        expect(PuzzleEngine.generateColumnHints([]), isEmpty);
      },
    );
  });
}
