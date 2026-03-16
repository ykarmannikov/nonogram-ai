import 'package:flutter_test/flutter_test.dart';
import 'package:nngram/core/engine/puzzle_engine.dart';

void main() {
  group('PuzzleEngine.generateRowHints', () {
    test(
      'паттерн «крест» 5×5: каждая строка даёт верную подсказку',
      () {
        final solution = [
          [0, 0, 1, 0, 0],
          [0, 0, 1, 0, 0],
          [1, 1, 1, 1, 1],
          [0, 0, 1, 0, 0],
          [0, 0, 1, 0, 0],
        ];

        final hints = PuzzleEngine.generateRowHints(solution);

        expect(hints[0], equals([1]), reason: 'строка 0: одна ячейка в центре');
        expect(hints[1], equals([1]), reason: 'строка 1: одна ячейка в центре');
        expect(hints[2], equals([5]),
            reason: 'строка 2: все 5 ячеек заполнены');
        expect(hints[3], equals([1]), reason: 'строка 3: одна ячейка в центре');
        expect(hints[4], equals([1]), reason: 'строка 4: одна ячейка в центре');
      },
    );

    test(
      'строка полностью пустая (все нули) → подсказка [0]',
      () {
        final hints = PuzzleEngine.generateRowHints([
          [0, 0, 0, 0]
        ]);

        expect(hints[0], equals([0]));
      },
    );

    test(
      'строка полностью заполнена → подсказка равна длине строки [5]',
      () {
        final hints = PuzzleEngine.generateRowHints([
          [1, 1, 1, 1, 1]
        ]);

        expect(hints[0], equals([5]));
      },
    );

    test(
      'несколько групп в строке: [1,1,0,1,0,1,1,1] → подсказка [2, 1, 3]',
      () {
        final hints = PuzzleEngine.generateRowHints([
          [1, 1, 0, 1, 0, 1, 1, 1]
        ]);

        expect(hints[0], equals([2, 1, 3]));
      },
    );

    test(
      'пустой solution → результат пустой список (нечего считать)',
      () {
        expect(PuzzleEngine.generateRowHints([]), isEmpty);
      },
    );

    test(
      'единственная заполненная ячейка посреди пустых → подсказка [1]',
      () {
        final hints = PuzzleEngine.generateRowHints([
          [0, 1, 0]
        ]);

        expect(hints[0], equals([1]));
      },
    );
  });
}
