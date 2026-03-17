import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress.freezed.dart';
part 'progress.g.dart';

/// Запись о прогрессе по уровню.
///
/// Хранит состояние разблокировки и прохождения.
/// Наличие записи означает, что уровень известен системе прогресса.
@freezed
class Progress with _$Progress {
  const factory Progress({
    /// Идентификатор уровня.
    required String levelId,

    /// Уровень пройден.
    required bool isCompleted,

    /// Уровень разблокирован (доступен для игры).
    required bool isUnlocked,

    /// Время прохождения (null если ещё не пройден).
    DateTime? completedAt,
  }) = _Progress;

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);
}
