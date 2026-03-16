import 'dart:convert';

import 'package:flutter/services.dart';

/// Утилита для загрузки файлов из assets.
class AssetLoader {
  AssetLoader._();

  /// Загружает JSON-файл из assets и возвращает декодированный объект.
  static Future<Map<String, dynamic>> loadJson(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Загружает список JSON-файлов из assets.
  static Future<List<Map<String, dynamic>>> loadJsonList(
    List<String> assetPaths,
  ) async {
    final results = <Map<String, dynamic>>[];
    for (final path in assetPaths) {
      results.add(await loadJson(path));
    }
    return results;
  }
}
