import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nngram/entities/cell_state.dart';
import 'package:nngram/entities/game_mode.dart';
import 'package:nngram/entities/puzzle.dart';

part 'game_state.freezed.dart';

/// Состояние активной игровой сессии.
///
/// Иммутабельный снимок всего, что нужно для отображения
/// текущей партии: сам пазл, сетка игрока, режим и флаг победы.
@freezed
class GameState with _$GameState {
  const factory GameState({
    /// Текущий пазл.
    required Puzzle puzzle,

    /// Сетка игрока размером [puzzle.height x puzzle.width].
    required List<List<CellState>> playerGrid,

    /// Текущий режим взаимодействия.
    required GameMode mode,

    /// Флаг победы: true, если [playerGrid] совпадает с [puzzle.solution].
    @Default(false) bool isSolved,
  }) = _GameState;
}
