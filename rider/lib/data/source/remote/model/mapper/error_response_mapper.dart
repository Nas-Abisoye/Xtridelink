import 'package:injectable/injectable.dart';
import 'package:xtridelink_driver/data/source/remote/model/error_response.dart';
import 'package:xtridelink_driver/data/source/remote/model/mapper/base_remote_data_mapper.dart';
import 'package:xtridelink_driver/domain/entity/server_error.dart';

@Injectable()
class ErrorResponseMapper
    extends BaseRemoteDataMapper<ErrorResponse, ServerError> {
  ErrorResponseMapper();

  @override
  ServerError mapToEntity(ErrorResponse? data) {
    return ServerError(
      status: data?.status ?? '',
      message: data?.message ?? '',
      errors: data?.errors ?? {},
    );
  }
}
