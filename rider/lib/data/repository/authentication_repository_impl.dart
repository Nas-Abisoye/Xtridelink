import 'package:injectable/injectable.dart';
import 'package:xtridelink_driver/data/source/local/authentication_local_source.dart';
import 'package:xtridelink_driver/data/source/remote/authentication_remote_data_source.dart';
import 'package:xtridelink_driver/data/source/remote/model/auth/get_user_details_response.dart';
import 'package:xtridelink_driver/data/source/remote/model/auth/login_response.dart';
import 'package:xtridelink_driver/data/source/remote/model/default_response.dart';
import 'package:xtridelink_driver/domain/params/address_verification_params.dart';
import 'package:xtridelink_driver/domain/params/id_verification_params.dart';

import 'package:xtridelink_driver/domain/params/login_params.dart';
import 'package:xtridelink_driver/domain/params/register_params.dart';
import 'package:xtridelink_driver/domain/params/vehicle_verification_params.dart';
import 'package:xtridelink_driver/domain/repository/authentication_repository.dart';
import 'package:xtridelink_driver/core/helpers/exception/remote_exception.dart';
import 'package:xtridelink_driver/core/network/api_result.dart';

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
  bool get isUserLoggedIn => _authenticationLocalSource.accessToken != null;

  @override
  Future<ApiResult<LoginResponse>> login(LoginParams params) async {
    final response = await _authenticationRemoteSource.login(params);
    return response.map(
      success: (value) {
        try {
          _saveToken(value.data.data!.accessToken!);
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

  Future<void> _saveToken(String token) {
    return Future.wait([
      _authenticationLocalSource.saveAccessToken(token),
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
    // final response =
    //     await _authenticationRemoteSource.refreshToken(refreshToken);
    // return response.map(
    //   success: (value) {
    //     try {
    //       _saveToken(value.data.access!);
    //       return const ApiResult.success(data: true);
    //     } catch (e) {
    //       return ApiResult.failure(error: RemoteException.unexpectedError(e));
    //     }
    //   },
    //   failure: (value) {
    //     return ApiResult.failure(error: value.error);
    //   },
    // );

    return const ApiResult.failure(error: RemoteException.cancellationError());
  }

  @override
  UserAccountData? getUserAccountDetails() {
    return _authenticationLocalSource.userData;
  }

  @override
  Future<ApiResult<LoginResponse>> completeRegistration(
    RegisterParams params,
  ) =>
      _authenticationRemoteSource.completeRegistration(params);

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
}
