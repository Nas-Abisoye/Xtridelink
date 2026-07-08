import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:xtridelink/core/helpers/exception/mapper/http_request_exception_mapper.dart';
import 'package:xtridelink/core/network/api_result.dart';

abstract class BaseRemoteSource {
  final HttpRequestExceptionMapper httpRequestExceptionMapper =
      GetIt.instance.get();
  final logger = Logger();

  Future<ApiResult<R>> run<R>(Future<ApiResult<R>> Function() runner) async {
    try {
      return await runner.call();
    } catch (e, stack) {
      logger.e('RemoteSource Error', error: e, stackTrace: stack);
      return ApiResult.failure(error: httpRequestExceptionMapper.map(e));
    }
  }
}
