import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xtridelink/core/helpers/exception/remote_exception.dart';

part 'api_result.freezed.dart';

@freezed
class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success({required T data}) = Success<T>;

  const factory ApiResult.failure({required RemoteException error}) =
      Failure<T>;
}
