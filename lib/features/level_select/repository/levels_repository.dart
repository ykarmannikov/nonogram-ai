import 'package:nngram/core/engine/puzzle_engine.dart';
import 'package:nngram/core/utils/asset_loader.dart';
import 'package:nngram/entities/puzzle.dart';

/// Пути к asset-файлам уровней по сложности.
const _easyAssets = [
  'assets/puzzles/easy/level_1.json',
];

const _hardAssets = [
  'assets/puzzles/hard/level_1.json',
];

/// Репозиторий уровней.
///
/// Загружает уровни из JSON-файлов в assets и строит [Puzzle]
/// с подсказками, сгенерированными в runtime.
class LevelsRepository {
  /// Загружает уровни по сложности ('easy' или 'hard').
  Future<List<Puzzle>> loadByDifficulty(String difficulty) async {
    final paths = switch (difficulty) {
      'easy' => _easyAssets,
      'hard' => _hardAssets,
      _ => <String>[],
    };

    final jsonList = await AssetLoader.loadJsonList(paths);
    return jsonList.map(PuzzleEngine.buildFromJson).toList();
  }
}
