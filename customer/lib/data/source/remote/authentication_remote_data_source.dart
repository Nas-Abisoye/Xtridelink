import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/network/api_result.dart';
import 'package:xtridelink/core/network/http_service.dart';
import 'package:xtridelink/data/source/remote/base_remote_source.dart';
import 'package:xtridelink/data/source/remote/model/auth/get_user_details_response.dart';
import 'package:xtridelink/data/source/remote/model/auth/login_response.dart';
import 'package:xtridelink/data/source/remote/model/auth/password_reset_verify_response.dart';
import 'package:xtridelink/data/source/remote/model/default_response.dart';
import 'package:xtridelink/data/source/remote/model/notifications/user_notifications_response.dart';
import 'package:xtridelink/domain/params/address_verification_params.dart';
import 'package:xtridelink/domain/params/id_verification_params.dart';
import 'package:xtridelink/domain/params/login_params.dart';
import 'package:xtridelink/domain/params/register_params.dart';
import 'package:xtridelink/domain/params/vehicle_verification_params.dart';
import 'package:xtridelink/injector.dart';

class AuthenticationEndpoints {
  static const loginPath = '/users/login/';
  static const refreshTokenPath = '/users/token/refresh/';
  static const initiateRegistration = '/users/register/initiate/';
  static const completeRegistrationPath = '/users/register/complete/';
  static const verifyPhone = '/users/register/verify-phone/';
  static const verifyEmail = '/users/register/verify-email/';

  static const initialPasswordReset = '/users/password/reset/initiate/';
  static const verifyPasswordReset = '/users/password/reset/verify/';
  static const completePasswordReset = '/users/profiles/';
  static const userProfile = '/users/profiles/';
  static const registerDeviceId = '/notifications/register-device/';
  static const userNotifications = '/notifications/in-app/';
  static const markNotificationAsRead = '/notifications/in-app/mark-read/';
  static const notificationReadCount = '/notifications/in-app/unread-count/';

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

  Future<ApiResult<LoginResponse>> refreshToken(String refreshToken) {
    return run(() async {
      final client = getIt<HttpService>().client();
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.refreshTokenPath,
        data: {'refresh_token': refreshToken},
      );

      return ApiResult.success(data: LoginResponse.fromMap(response.data!));
    });
  }

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
        AuthenticationEndpoints.userProfile,
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

  Future<ApiResult<DefaultResponse>> registerFCMDeviceToken(
      {required String deviceToken,
      required String deviceType,
      required String deviceId}) {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.registerDeviceId,
        data: {
          'token': deviceToken,
          'device_type': deviceType, // ios
          'device_id': deviceId,
        },
      );
      return ApiResult.success(data: DefaultResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<UserNotificationsResponse>> getNotifications() {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.get<Map<String, dynamic>>(
        AuthenticationEndpoints.userNotifications,
      );
      return ApiResult.success(
          data: UserNotificationsResponse.fromJson(response.data!));
    });
  }

  Future<ApiResult<DefaultResponse>> markNotificationAsRead(
      String notificationId) {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.post<Map<String, dynamic>>(
        AuthenticationEndpoints.markNotificationAsRead,
        data: {
          'ids': [notificationId]
        },
      );
      return ApiResult.success(data: DefaultResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<DefaultResponse>> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? countryCode,
    String? location,
    num? latitude,
    num? longitude,
    DateTime? dob,
    String? profileImage,
  }) {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.put<Map<String, dynamic>>(
        AuthenticationEndpoints.userProfile,
        data: {
          if (location != null) 'location': location,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
        },
      );
      return ApiResult.success(data: DefaultResponse.fromMap(response.data!));
    });
  }
}
