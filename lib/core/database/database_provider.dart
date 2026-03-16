import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nngram/core/database/app_database.dart';

/// Провайдер базы данных.
///
/// Определён в слое [core], а не в [features], чтобы любая фича
/// могла использовать БД без нарушения архитектурных зависимостей.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
