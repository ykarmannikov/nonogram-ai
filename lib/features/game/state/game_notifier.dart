import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nngram/core/engine/puzzle_engine.dart';
import 'package:nngram/entities/game_mode.dart';
import 'package:nngram/entities/game_state.dart';
import 'package:nngram/entities/puzzle.dart';

/// Управляет состоянием активной игровой сессии.
class GameNotifier extends StateNotifier<GameState?> {
  GameNotifier() : super(null);

  /// Инициализирует новую игровую сессию для [puzzle].
  void startGame(Puzzle puzzle) {
    state = GameState(
      puzzle: puzzle,
      playerGrid: PuzzleEngine.createEmptyGrid(puzzle),
      mode: GameMode.fill,
    );
  }

  /// Применяет ход к ячейке (row, col) и проверяет победу.
  void applyMove(int row, int col) {
    if (state == null) return;
    final afterMove = PuzzleEngine.applyMove(state!, row, col);
    state = PuzzleEngine.checkSolved(afterMove);
  }

  /// Переключает режим взаимодействия (fill ↔ cross).
  void toggleMode() {
    if (state == null) return;
    final newMode =
        state!.mode == GameMode.fill ? GameMode.cross : GameMode.fill;
    state = state!.copyWith(mode: newMode);
  }

  /// Очищает состояние игры при переходе на новый уровень.
  ///
  /// Вызывать до [startGame] — гарантирует, что первый build нового экрана
  /// видит null и не триггерит диалог победы от предыдущего уровня.
  void clearGame() => state = null;

  /// Сбрасывает поле до начального состояния.
  void resetGame() {
    if (state == null) return;
    state = GameState(
      puzzle: state!.puzzle,
      playerGrid: PuzzleEngine.createEmptyGrid(state!.puzzle),
      mode: GameMode.fill,
    );
  }
}
