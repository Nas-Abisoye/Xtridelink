import 'package:injectable/injectable.dart';
import 'package:xtridelink_driver/core/network/api_result.dart';
import 'package:xtridelink_driver/core/network/http_service.dart';
import 'package:xtridelink_driver/data/source/remote/base_remote_source.dart';
import 'package:xtridelink_driver/data/source/remote/model/auth/get_user_details_response.dart';
import 'package:xtridelink_driver/data/source/remote/model/auth/login_response.dart';
import 'package:xtridelink_driver/data/source/remote/model/auth/password_reset_verify_response.dart';
import 'package:xtridelink_driver/data/source/remote/model/default_response.dart';
import 'package:xtridelink_driver/data/source/remote/model/notifications/user_notifications_response.dart';
import 'package:xtridelink_driver/domain/params/address_verification_params.dart';
import 'package:xtridelink_driver/domain/params/id_verification_params.dart';
import 'package:xtridelink_driver/domain/params/login_params.dart';
import 'package:xtridelink_driver/domain/params/register_params.dart';
import 'package:xtridelink_driver/domain/params/vehicle_verification_params.dart';
import 'package:xtridelink_driver/injector.dart';

class AuthenticationEndpoints {
  static const loginPath = '/users/login/';
  static const initiateRegistration = '/users/register/initiate/';
  static const completeRegistrationPath = '/users/register/complete/';
  static const verifyPhone = '/users/register/verify-phone/';
  static const verifyEmail = '/users/register/verify-email/';

  static const initialPasswordReset = '/users/password/reset/initiate/';
  static const verifyPasswordReset = '/users/password/reset/verify/';
  static const completePasswordReset = '/users/profiles/';
  static const userProfileDetails = '/users/profiles/';

  //Rider
  static const riderVehicleVerification = '/users/rider/verify/vehicle/';
  static const riderIdVerification = '/users/rider/verify/id/';
  static const riderAddressVerification = '/users/rider/verify/address/';
}

@Injectable()
class AuthenticationRemoteSource extends BaseRemoteSource {
  Future<ApiResult<DefaultResponse>> initiateRegistration(String phone) {
    return run(() async {
      final client = getIt<HttpService>().client();
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.initiateRegistration,
        data: {'phone_number': phone},
      );

      return ApiResult.success(data: DefaultResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<LoginResponse>> login(LoginParams params) {
    return run(() async {
      final client = getIt<HttpService>().client();
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.loginPath,
        data: params.toMap(),
      );

      return ApiResult.success(data: LoginResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<LoginResponse>> completeRegistration(RegisterParams params) {
    return run(() async {
      final client = getIt<HttpService>().client();
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.completeRegistrationPath,
        data: params.toMap(),
      );

      return ApiResult.success(
        data: LoginResponse.fromMap(response.data!),
      );
    });
  }

  // Future<ApiResult<TokenData>> refreshToken(
  //   String refreshToken,
  // ) async {
  //   return run(() async {
  //     final client = getIt<HttpService>().client();
  //     final response = await client.post<Map<String, dynamic>>(
  //       AuthenticationEndpoints.refreshTokenPath,
  //       data: {'refresh': refreshToken},
  //     );

  //     return ApiResult.success(
  //       data: TokenData.fromMap(response.data!),
  //     );
  //   });
  // }

  Future<ApiResult<DefaultResponse>> verifyPhoneNumber({
    required String phoneNumber,
    required String otp,
  }) async {
    return run(() async {
      final client = getIt<HttpService>().client();
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.verifyPhone,
        data: {'phone_number': phoneNumber, 'otp': otp},
      );

      return ApiResult.success(
        data: DefaultResponse.fromMap(response.data!),
      );
    });
  }

  Future<ApiResult<DefaultResponse>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    return run(() async {
      final client = getIt<HttpService>().client();
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.verifyEmail,
        data: {'email': email, 'otp': otp},
      );

      return ApiResult.success(
        data: DefaultResponse.fromMap(response.data!),
      );
    });
  }

  Future<ApiResult<DefaultResponse>> initialPasswordReset(String email) async {
    return run(() async {
      final client = getIt<HttpService>().client();
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.initialPasswordReset,
        data: {
          'email': email,
        },
      );

      return ApiResult.success(
        data: DefaultResponse.fromMap(response.data!),
      );
    });
  }

  Future<ApiResult<PasswordResetVerifyResponse>> verifyPasswordReset({
    required String email,
    required String otp,
  }) async {
    return run(() async {
      final client = getIt<HttpService>().client();
      final response = await client.post<Map<String, dynamic>>(
          AuthenticationEndpoints.verifyPasswordReset,
          data: {
            'email': email,
            'otp': otp,
          });

      return ApiResult.success(
        data: PasswordResetVerifyResponse.fromMap(response.data!),
      );
    });
  }

  Future<ApiResult<DefaultResponse>> completePasswordReset({
    required String email,
    required String resetToken,
    required String password,
    required String confirmPassword,
  }) async {
    return run(() async {
      final client = getIt<HttpService>().client();
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.completePasswordReset,
        data: {
          'email': email,
          'reset_token': resetToken,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );

      return ApiResult.success(
        data: DefaultResponse.fromMap(response.data!),
      );
    });
  }

  Future<ApiResult<GetUserDetailsResponse>> getUserProfileDetails() {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.get<Map<String, dynamic>>(
        AuthenticationEndpoints.userProfileDetails,
      );
      return ApiResult.success(
          data: GetUserDetailsResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<DefaultResponse>> riderVehicleVerification(
      VehicleVerificationParams params) {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.riderVehicleVerification,
        data: params.toMap(),
      );
      return ApiResult.success(data: DefaultResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<DefaultResponse>> riderIdVerification(
      IdVerificationParams params) {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.riderIdVerification,
        data: params.toMap(),
      );
      return ApiResult.success(data: DefaultResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<DefaultResponse>> riderAddressVerification(
      AddressVerificationParams params) {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.riderAddressVerification,
        data: params.toMap(),
      );
      return ApiResult.success(data: DefaultResponse.fromMap(response.data!));
    });
  }
}
