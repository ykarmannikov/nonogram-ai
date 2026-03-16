import 'package:freezed_annotation/freezed_annotation.dart';

part 'puzzle.freezed.dart';
part 'puzzle.g.dart';

/// Уровень-головоломка.
///
/// Является иммутабельной моделью данных. Подсказки генерируются
/// из [solution] в runtime с помощью [PuzzleEngine] и не хранятся
/// в JSON-файлах или базе данных.
@freezed
class Puzzle with _$Puzzle {
  const factory Puzzle({
    /// Уникальный идентификатор уровня.
    required String id,

    /// Сложность: 'easy' или 'hard'.
    required String difficulty,

    /// Ширина поля (количество столбцов).
    required int width,

    /// Высота поля (количество строк).
    required int height,

    /// Решение: матрица размером [height x width].
    /// 1 — закрашенная ячейка, 0 — пустая.
    required List<List<int>> solution,

    /// Подсказки для строк. Генерируются из [solution].
    required List<List<int>> rowHints,

    /// Подсказки для столбцов. Генерируются из [solution].
    required List<List<int>> colHints,

    /// Правило разблокировки уровня (опционально).
    String? unlockRule,
  }) = _Puzzle;

  factory Puzzle.fromJson(Map<String, dynamic> json) => _$PuzzleFromJson(json);
}
