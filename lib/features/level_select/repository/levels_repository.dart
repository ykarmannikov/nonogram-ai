import 'package:nngram/core/engine/puzzle_engine.dart';
import 'package:nngram/core/utils/asset_loader.dart';
import 'package:nngram/entities/puzzle.dart';

/// Пути к asset-файлам уровней по сложности.
const _easyAssets = [
  'assets/puzzles/easy/level_1.json',
  'assets/puzzles/easy/level_2.json',
  'assets/puzzles/easy/level_3.json',
  'assets/puzzles/easy/level_4.json',
  'assets/puzzles/easy/level_5.json',
];

const _hardAssets = [
  'assets/puzzles/hard/level_1.json',
  'assets/puzzles/hard/level_2.json',
  'assets/puzzles/hard/level_3.json',
  'assets/puzzles/hard/level_4.json',
  'assets/puzzles/hard/level_5.json',
];

/// Репозиторий уровней.
///
/// Загружает уровни из JSON-файлов в assets и строит [Puzzle]
/// с подсказками, сгенерированными в runtime.
/// Результаты кэшируются в памяти — повторные вызовы не обращаются к assets.
class LevelsRepository {
  final _cache = <String, List<Puzzle>>{};

  /// Загружает уровни по сложности ('easy' или 'hard').
  Future<List<Puzzle>> loadByDifficulty(String difficulty) async {
    if (_cache.containsKey(difficulty)) return _cache[difficulty]!;

    final paths = switch (difficulty) {
      'easy' => _easyAssets,
      'hard' => _hardAssets,
      _ => <String>[],
    };

    final jsonList = await AssetLoader.loadJsonList(paths);
    final puzzles = jsonList.map(PuzzleEngine.buildFromJson).toList();
    _cache[difficulty] = puzzles;
    return puzzles;
  }
}
