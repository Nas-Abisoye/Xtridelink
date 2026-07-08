import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:xtridelink_driver/core/constants/strings.dart';
import 'package:xtridelink_driver/core/helpers/device_helper.dart';
import 'package:xtridelink_driver/domain/model/api/auth.dart';
import 'package:xtridelink_driver/domain/model/api/user.dart';
import '../../../constants/helpers.dart';
import '../../storage/index.dart';
import '../request_helper.dart';

sealed class AuthApiService {
  Future<UserData?> signIn(
      {required String phoneNumber, required String password});

  Future<UserData?> signUp(
      {required email,
      required password,
      required firstName,
      required lastName,
      required phoneNumber,
      required String referralCode,
      required countryCode});

  Future<bool> forgotPassword({required String email});

  Future<bool> verifyEmail(
      {required String userId, required String otp, required bool isEmail});

  /// Verify phone number
  ///
  Future<bool> verifyPhoneNumber(
      {required String phoneNumber, required String otp});

  Future<bool> sendOtp({required String email});

  Future<UserData?> resetPassword(
      {required String code,
      required String newPassword,
      required String email});
  Future<void> updateDeviceToken({required String token});
  Future<void> sendOtpToNumber({required String phoneNo});
}

class AuthApiServiceImpl extends AuthApiService {
  RequestHelpersImpl requestHelpers;
  StorageServiceImpl storageServiceImpl;

  AuthApiServiceImpl(
      {required this.requestHelpers, required this.storageServiceImpl});

  @override
  Future<UserData?> signIn(
      {required String phoneNumber, required String password}) async {
    String url = '/users/login/';
    try {
      http.Response? res = await requestHelpers.post(
          useToken: false,
          url: url,
          body: {
            'phone_number': phoneNumber.replaceAll('+', ''),
            'password': password
          });
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        AuthResModel authResModel = AuthResModel.fromJson(body);
        await storageServiceImpl.setUserToken(authResModel.data.accessToken);
        if (authResModel.data.refreshToken.isNotEmpty) {
          await storageServiceImpl
              .setRefreshToken(authResModel.data.refreshToken);
        }
        await storageServiceImpl.setUserId(authResModel.data.user.id!);
        HelperFunc.toast('Signed in successfully');
        return authResModel.data.user;
      } else {
        HelperFunc.toast(body['message']?.toString() ?? 'Failed to sign in.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to sign in');
    }
    return null;
  }

  @override
  Future<UserData?> signUp({
    required email,
    required password,
    required firstName,
    required lastName,
    required phoneNumber,
    required String referralCode,
    required countryCode,
  }) async {
    String url = '/users/register/complete/';
    try {
      http.Response? res =
          await requestHelpers.post(useToken: false, url: url, body: {
        'user_type': 'rider', // customer, rider, admin
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber.replaceAll('+', ''),
        'password': password,
        'confirm_password': password,
        'location': 'Nigeria',
      });
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        AuthResModel authResModel = AuthResModel.fromJson(body);
        await storageServiceImpl.setUserToken(authResModel.data.accessToken);
        if (authResModel.data.refreshToken.isNotEmpty) {
          await storageServiceImpl
              .setRefreshToken(authResModel.data.refreshToken);
        }
        await storageServiceImpl.setUserId(authResModel.data.user.userId!);
        HelperFunc.toast('Account created successfully');
        return authResModel.data.user;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to create account.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to create account');
    }
    return null;
  }

  @override
  Future<bool> forgotPassword({required String email}) async {
    try {
      String url = '/v1/auth/password-forgot';
      http.Response? response = await requestHelpers.post(
          useToken: false,
          url: url,
          body: {
            'email': email,
            'url': 'https://${GlobalStrings.webUrl}/reset-password'
          });
      if (response == null) return false;
      var body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        HelperFunc.toast(body['message']?.toString() ??
            'A code has been sent to your email.');
        return true;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to reset password.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to reset password');
    }
    return false;
  }

  @override
  Future<bool> verifyEmail(
      {required String userId,
      required String otp,
      required bool isEmail}) async {
    try {
      String url = isEmail ? '/v1/auth/verify-email' : '/v1/auth/verify-number';
      http.Response? response = await requestHelpers.post(
          useToken: false, url: url, body: {'otp': otp, 'userId': userId});
      if (response == null) return false;
      var body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        HelperFunc.toast('${isEmail ? 'Email' : 'Number'} has been verified.');
        return true;
      } else {
        HelperFunc.toast(body['message']?.toString() ??
            'Failed to verify ${isEmail ? 'email' : 'number'}.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to verify ${isEmail ? 'email' : 'number'}.');
    }
    return false;
  }

  @override
  Future<bool> verifyPhoneNumber({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      String url = '/users/register/verify-phone/';
      http.Response? response = await requestHelpers.post(
          useToken: false,
          url: url,
          body: {'otp': otp, 'phone_number': phoneNumber.replaceAll('+', '')});
      if (response == null) return false;
      var body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        HelperFunc.toast('$phoneNumber has been verified.');
        return true;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to verify $phoneNumber.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to verify $phoneNumber.');
    }
    return false;
  }

  @override
  Future<bool> sendOtpToNumber({required String phoneNo}) async {
    try {
      String url = '/users/register/initiate/';
      http.Response? response = await requestHelpers.post(
          useToken: false,
          url: url,
          body: {'phone_number': phoneNo.replaceAll('+', '')});
      if (response == null) return false;
      var body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        HelperFunc.toast('An otp has been sent to your number.');
        return true;
      } else {
        HelperFunc.toast(body['message']?.toString() ?? 'Failed to send otp.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to send otp.');
    }
    return false;
  }

  @override
  Future<bool> sendOtp({required String email}) async {
    try {
      String url = '/v1/auth/send-otp';
      http.Response? response = await requestHelpers
          .post(useToken: false, url: url, body: {'email': email});
      if (response == null) return false;
      var body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        HelperFunc.toast('An otp has been sent to your email.');
        return true;
      } else {
        HelperFunc.toast(body['message']?.toString() ?? 'Failed to send otp.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to send otp.');
    }
    return false;
  }

  @override
  Future<UserData?> resetPassword(
      {required String code,
      required String newPassword,
      required String email}) async {
    try {
      String url = '/v1/auth/password-reset';
      http.Response? response = await requestHelpers.post(
          useToken: false,
          url: url,
          body: {'password': newPassword, 'code': code, 'email': email});
      if (response == null) return null;
      var body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        HelperFunc.toast('Password reset successful.');
        AuthResModel authResModel = AuthResModel.fromJson(body);
        await storageServiceImpl.setUserToken(authResModel.data.accessToken);
        return authResModel.data.user;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to reset password.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to reset password');
    }
    return null;
  }

  @override
  Future<void> updateDeviceToken({required String token}) async {
    final deviceId = await DeviceHelper.getDeviceUniqueId();
    try {
      String url = '/notifications/register-device/';
      await requestHelpers.post(url: url, body: {
        'token': token,
        'device_type': Platform.operatingSystem,
        'device_id': deviceId,
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
