import 'package:xtridelink_driver/data/source/remote/model/auth/get_user_details_response.dart';
import 'package:xtridelink_driver/data/source/remote/model/auth/login_response.dart';
import 'package:xtridelink_driver/data/source/remote/model/default_response.dart';
import 'package:xtridelink_driver/domain/params/address_verification_params.dart';
import 'package:xtridelink_driver/domain/params/id_verification_params.dart';
import 'package:xtridelink_driver/domain/params/login_params.dart';
import 'package:xtridelink_driver/domain/params/register_params.dart';
import 'package:xtridelink_driver/core/network/api_result.dart';
import 'package:xtridelink_driver/domain/params/vehicle_verification_params.dart';

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

  UserAccountData? getUserAccountDetails();

  String? getAccessToken();

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
}
