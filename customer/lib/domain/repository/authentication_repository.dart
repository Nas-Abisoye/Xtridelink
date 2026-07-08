import 'package:xtridelink/data/source/remote/model/auth/get_user_details_response.dart';
import 'package:xtridelink/data/source/remote/model/auth/login_response.dart';
import 'package:xtridelink/data/source/remote/model/default_response.dart';
import 'package:xtridelink/data/source/remote/model/notifications/user_notifications_response.dart';
import 'package:xtridelink/domain/model/api/notifications.dart';
import 'package:xtridelink/domain/params/address_verification_params.dart';
import 'package:xtridelink/domain/params/id_verification_params.dart';
import 'package:xtridelink/domain/params/login_params.dart';
import 'package:xtridelink/domain/params/register_params.dart';
import 'package:xtridelink/core/network/api_result.dart';
import 'package:xtridelink/domain/params/vehicle_verification_params.dart';

abstract class AuthenticationRepository {
  Future<ApiResult<LoginResponse>> login(LoginParams params);

  Future<ApiResult<DefaultResponse>> initiateRegistration(String phone);

  Future<ApiResult<LoginResponse>> completeRegistration(
    RegisterParams params,
  );

  Future<ApiResult<bool>> refreshToken(String refreshToken);

  Future<ApiResult<DefaultResponse>> verifyPhonenumber({
    required String phone,
    required String otp,
  });

  Future<ApiResult<DefaultResponse>> verifyEmail({
    required String email,
    required String otp,
  });

  Future<void> logout();

  User? getUserAccountDetails();

  String? getAccessToken();

  String? getRefreshToken();

  String? userEmail();

  bool get isUserLoggedIn;

  void toggleRememberMe();

  Future<ApiResult<DefaultResponse>> riderVehicleVerification(
      VehicleVerificationParams params);

  Future<ApiResult<DefaultResponse>> riderIdVerification(
      IdVerificationParams params);

  Future<ApiResult<DefaultResponse>> riderAddressVerification(
      AddressVerificationParams params);

  Future<ApiResult<GetUserDetailsResponse>> fetchUserAccountDetails();

  Future<void> storeFCMDeviceToken(String token);

  String? getFCMDeviceToken();

  Future<ApiResult<DefaultResponse>> registerDeviceToken(
      {required String deviceToken,
      required String deviceType,
      required String deviceId});

  Future<ApiResult<UserNotificationsResponse>> getUserNotifications();

  Future<ApiResult<DefaultResponse>> updateUserProfile(
      {String? firstName,
      String? lastName,
      String? phoneNumber,
      String? countryCode,
      String? location,
      num? latitude,
      num? longitude,
      DateTime? dob,
      String? profileImage});
}
