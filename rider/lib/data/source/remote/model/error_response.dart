import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xtridelink_driver/data/source/remote/model/base_remote_data.dart';

part 'error_response.freezed.dart';
part 'error_response.g.dart';

@freezed
class ErrorResponse extends BaseRemoteData with _$ErrorResponse {
  factory ErrorResponse({
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'errors') Map<String, dynamic>? errors,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}
