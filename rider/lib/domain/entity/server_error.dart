import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xtridelink_driver/domain/entity/base_entity.dart';

part 'server_error.freezed.dart';

@freezed
class ServerError extends BaseEntity with _$ServerError {
  const factory ServerError({
    @Default('') String status,
    @Default('') String message,
    @Default({}) Map<String, dynamic> errors,
  }) = _ServerError;
}
