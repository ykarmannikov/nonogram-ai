import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nngram/entities/game_state.dart';
import 'package:nngram/entities/puzzle.dart';
import 'package:nngram/features/game/state/game_notifier.dart';

/// Провайдер игрового состояния.
final gameProvider = StateNotifierProvider<GameNotifier, GameState?>((ref) {
  return GameNotifier();
});

/// Провайдер выбранного пазла.
///
/// Используется для передачи пазла между экранами
/// без сериализации в URL (GoRouter extra).
final selectedPuzzleProvider = StateProvider<Puzzle?>((ref) => null);
