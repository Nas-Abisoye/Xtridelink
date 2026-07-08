import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:xtridelink/domain/model/api/user.dart';
import '../../../constants/helpers.dart';
import '../request_helper.dart';

sealed class ProfileApiService {
  Future<UserData?> getUserDetails();
  Future<UserData?> updateUserDetails({required Map<String, dynamic> map});
  Future<bool> contactSupport(
      {required String subject, required String message});
  Future<bool> changePassword(
      {required String newPassword,
      required String oldPassword,
      required String email});
}

@Injectable()
class ProfileApiServiceImpl extends ProfileApiService {
  RequestHelpersImpl requestHelpers;
  ProfileApiServiceImpl({required this.requestHelpers});

  @override
  Future<UserData?> getUserDetails() async {
    String url = '/v1/auth/profile';
    try {
      http.Response? res = await requestHelpers.get(url: url);
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        UserResModel userResModel = UserResModel.fromJson(body);
        return userResModel.data;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to get user details.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to get user details.');
    }
    return null;
  }

  @override
  Future<UserData?> updateUserDetails(
      {required Map<String, dynamic> map}) async {
    String url = '/v1/auth/update-profile/';
    log('PUT => $url, data: $map');
    try {
      http.Response? res = await requestHelpers.put(url: url, body: map);
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Updated successfully.');
        UserResModel userResModel = UserResModel.fromJson(body);
        return userResModel.data;
      } else {
        HelperFunc.toast(body['message']?.toString() ?? 'Failed to update.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to update.');
    }
    return null;
  }

  @override
  Future<bool> changePassword(
      {required String newPassword,
      required String oldPassword,
      required String email}) async {
    try {
      String url = '/v1/auth/change-password';
      http.Response? response = await requestHelpers.post(url: url, body: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'email': email
      });
      if (response == null) return false;
      var body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        HelperFunc.toast('Password change successful.');
        return true;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to change password.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to change password');
    }
    return false;
  }

  @override
  Future<bool> contactSupport(
      {required String subject, required String message}) async {
    try {
      String url = '/v1/support/ticket';
      http.Response? response = await requestHelpers
          .post(url: url, body: {'subject': subject, 'content': message});
      if (response == null) return false;
      var body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        HelperFunc.toast(
            'Support has been contacted.\nYou\'ll get a reply soon.');
        return true;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to contact support.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to contact support.');
    }
    return false;
  }
}
