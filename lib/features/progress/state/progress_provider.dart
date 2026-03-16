import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nngram/core/database/database_provider.dart';
import 'package:nngram/entities/progress.dart';
import 'package:nngram/features/progress/repository/progress_repository.dart';
import 'package:nngram/features/progress/state/progress_notifier.dart';

/// Провайдер репозитория прогресса.
final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(appDatabaseProvider));
});

/// Провайдер состояния прогресса.
final progressProvider =
    StateNotifierProvider<ProgressNotifier, AsyncValue<List<Progress>>>((ref) {
  return ProgressNotifier(ref.watch(progressRepositoryProvider));
});
