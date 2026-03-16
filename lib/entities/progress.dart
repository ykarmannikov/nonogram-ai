import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress.freezed.dart';

/// Запись о пройденном уровне.
///
/// Наличие записи означает, что уровень пройден.
/// Производные данные (разблокировка следующего уровня)
/// вычисляются динамически и не хранятся в БД.
@freezed
class Progress with _$Progress {
  const factory Progress({
    /// Идентификатор пройденного уровня.
    required String levelId,

    /// Время прохождения.
    required DateTime completedAt,
  }) = _Progress;
}
