import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/helpers/exception/remote_exception.dart';
import 'package:xtridelink/core/network/api_result.dart';
import 'package:xtridelink/data/source/local/authentication_local_source.dart';
import 'package:xtridelink/data/source/remote/authentication_remote_data_source.dart';
import 'package:xtridelink/data/source/remote/model/auth/get_user_details_response.dart';
import 'package:xtridelink/data/source/remote/model/auth/login_response.dart';
import 'package:xtridelink/data/source/remote/model/default_response.dart';
import 'package:xtridelink/data/source/remote/model/notifications/user_notifications_response.dart';
// import 'package:xtridelink/domain/model/api/notifications.dart';
import 'package:xtridelink/domain/params/address_verification_params.dart';
import 'package:xtridelink/domain/params/id_verification_params.dart';
import 'package:xtridelink/domain/params/login_params.dart';
import 'package:xtridelink/domain/params/register_params.dart';
import 'package:xtridelink/domain/params/vehicle_verification_params.dart';
import 'package:xtridelink/domain/repository/authentication_repository.dart';

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(
    this._authenticationLocalSource,
    this._authenticationRemoteSource,
  );

  final AuthenticationLocalSource _authenticationLocalSource;
  final AuthenticationRemoteSource _authenticationRemoteSource;

  @override
  String? getAccessToken() {
    return _authenticationLocalSource.accessToken;
  }

  @override
  String? getRefreshToken() {
    return _authenticationLocalSource.refreshToken;
  }

  @override
  bool get isUserLoggedIn => _authenticationLocalSource.accessToken != null;

  @override
  Future<ApiResult<LoginResponse>> login(LoginParams params) async {
    final response = await _authenticationRemoteSource.login(params);
    return response.map(
      success: (value) {
        try {
          _saveToken(
            value.data.data!.accessToken!,
            value.data.data!.refreshToken,
          );
          return value;
        } catch (e) {
          return ApiResult.failure(error: RemoteException.unexpectedError(e));
        }
      },
      failure: (value) {
        return value;
      },
    );
  }

  Future<void> _saveToken(String token, [String? refreshToken]) {
    return Future.wait([
      _authenticationLocalSource.saveAccessToken(token),
      if (refreshToken != null && refreshToken.isNotEmpty)
        _authenticationLocalSource.saveRefreshToken(refreshToken),
    ]);
  }

  @override
  Future<void> logout() {
    return _authenticationLocalSource.clearUserData();
  }

  @override
  void toggleRememberMe() {
    // TODO: implement toggleRememberMe
  }

  @override
  Future<ApiResult<bool>> refreshToken(String refreshToken) async {
    final response =
        await _authenticationRemoteSource.refreshToken(refreshToken);
    // Note: callbacks are async and awaited so the new access token is
    // fully persisted before the caller retries the original request.
    return response.map(
      success: (value) async {
        try {
          final newAccessToken = value.data.data?.accessToken;
          if (newAccessToken == null || newAccessToken.isEmpty) {
            return ApiResult.failure(
              error: RemoteException.unexpectedError(
                'Refresh response contained no access token',
              ),
            );
          }
          await _authenticationLocalSource.saveAccessToken(newAccessToken);
          return const ApiResult<bool>.success(data: true);
        } catch (e) {
          return ApiResult<bool>.failure(
            error: RemoteException.unexpectedError(e),
          );
        }
      },
      failure: (value) async {
        return ApiResult<bool>.failure(error: value.error);
      },
    );
  }

  @override
  User? getUserAccountDetails() {
    return _authenticationLocalSource.userData;
  }

  @override
  Future<ApiResult<LoginResponse>> completeRegistration(
    RegisterParams params,
  ) async {
    final response =
        await _authenticationRemoteSource.completeRegistration(params);
    return response.map(
      success: (value) {
        try {
          _saveToken(
            value.data.data!.accessToken!,
            value.data.data!.refreshToken,
          );
          _authenticationLocalSource.saveUserEmail(params.email!);
          return value;
        } catch (e) {
          return ApiResult.failure(error: RemoteException.unexpectedError(e));
        }
      },
      failure: (value) {
        return value;
      },
    );
  }

  @override
  String? userEmail() => _authenticationLocalSource.userEmail;

  @override
  Future<ApiResult<DefaultResponse>> initiateRegistration(String phoneNumber) {
    return _authenticationRemoteSource.initiateRegistration(phoneNumber);
  }

  @override
  Future<ApiResult<DefaultResponse>> riderAddressVerification(
      AddressVerificationParams params) {
    return _authenticationRemoteSource.riderAddressVerification(params);
  }

  @override
  Future<ApiResult<DefaultResponse>> riderIdVerification(
      IdVerificationParams params) {
    return _authenticationRemoteSource.riderIdVerification(params);
  }

  @override
  Future<ApiResult<DefaultResponse>> riderVehicleVerification(
      VehicleVerificationParams params) {
    return _authenticationRemoteSource.riderVehicleVerification(params);
  }

  @override
  Future<ApiResult<DefaultResponse>> verifyEmail(
      {required String email, required String otp}) {
    return _authenticationRemoteSource.verifyEmail(email: email, otp: otp);
  }

  @override
  Future<ApiResult<DefaultResponse>> verifyPhonenumber(
      {required String phone, required String otp}) {
    return _authenticationRemoteSource.verifyPhoneNumber(
        phoneNumber: phone, otp: otp);
  }

  @override
  Future<ApiResult<GetUserDetailsResponse>> fetchUserAccountDetails() {
    return _authenticationRemoteSource.getUserProfileDetails();
  }

  @override
  String? getFCMDeviceToken() => _authenticationLocalSource.fcmDeviceToken;

  @override
  Future<ApiResult<DefaultResponse>> registerDeviceToken(
          {required String deviceToken,
          required String deviceType,
          required String deviceId}) =>
      _authenticationRemoteSource.registerFCMDeviceToken(
          deviceToken: deviceToken, deviceType: deviceType, deviceId: deviceId);

  @override
  Future<void> storeFCMDeviceToken(String token) =>
      _authenticationLocalSource.storeFCMDeviceToken(token);

  @override
  Future<ApiResult<UserNotificationsResponse>> getUserNotifications() {
    return _authenticationRemoteSource.getNotifications();
  }

  @override
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
  }) =>
      _authenticationRemoteSource.updateUserProfile(
        latitude: latitude,
        longitude: longitude,
        location: location,
      );
}
