import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:xtridelink_driver/domain/model/api/user.dart';
import '../../../constants/helpers.dart';
import '../request_helper.dart';

sealed class ProfileApiService {
  Future<UserData?> getUserDetails();
  Future<UserData?> updateUserDetails({required Map<String, dynamic> map});
  Future<RiderAnalytics?> updateRiderAnalytics(
      {required Map<String, dynamic> map});
  Future<RiderAnalytics?> getRiderAnalytics();
  Future<RiderAnalytics?> setNegotiationRate(
      {required num up, required num down});
  Future<bool> contactSupport(
      {required String subject, required String message});
  Future<bool> changePassword(
      {required String newPassword,
      required String oldPassword,
      required String email});

  Future<void> addVehicleInformation({required Map<String, dynamic> map});

  Future<void> addIdInformation({required Map<String, dynamic> map});

  Future<void> addAddressInformation({required Map<String, dynamic> map});
  Future<void> addNINInformation({required Map<String, dynamic> map});

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
    required String location,
  });

  Future<void> changeAvailability({required bool isAvailable});
}

class ProfileApiServiceImpl extends ProfileApiService {
  RequestHelpersImpl requestHelpers;
  ProfileApiServiceImpl({required this.requestHelpers});

  @override
  Future<UserData?> getUserDetails() async {
    String url = '/users/profiles/';

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
    String url = '/v1/user/update-profile';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: map);
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
  Future<RiderAnalytics?> getRiderAnalytics() async {
    // String url = '/v1/rider/rider-analytics';
    // try {
    //   http.Response? res = await requestHelpers.get(url: url);
    //   if (res == null) return null;
    //   var body = jsonDecode(res.body);
    //   if (res.statusCode == 200 || res.statusCode == 201) {
    //     RiderAnalyticsRes riderAnalyticsRes = RiderAnalyticsRes.fromJson(body);
    //     return riderAnalyticsRes.data;
    //   } else {
    //     HelperFunc.toast(
    //         body['message']?.toString() ?? 'Failed to get rider info.');
    //   }
    // } catch (e) {
    //   log(e.toString());
    //   HelperFunc.toast('Failed to get rider info.');
    // }
    return null;
  }

  @override
  Future<RiderAnalytics?> updateRiderAnalytics(
      {required Map<String, dynamic> map}) async {
    String url = '/v1/rider/update-profile';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: map);
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Updated successfully.');
        RiderAnalyticsRes riderAnalyticsRes = RiderAnalyticsRes.fromJson(body);
        return riderAnalyticsRes.data;
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
  Future<RiderAnalytics?> setNegotiationRate(
      {required num up, required num down}) async {
    String url = '/v1/rider/profile/payment/settings';
    try {
      http.Response? res = await requestHelpers.patch(
          url: url,
          body: {'upNegotiationRate': up, 'downNegotiationRate': down});
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Negotiation rate updated successfully.');
        RiderAnalyticsRes riderAnalyticsRes = RiderAnalyticsRes.fromJson(body);
        return riderAnalyticsRes.data;
      } else {
        HelperFunc.toast(body['message']?.toString() ??
            'Failed to update negotiation rate.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to update negotiation rate.');
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
        return false;
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
        return false;
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to contact support.');
    }
    return false;
  }

  @override
  Future<bool> addAddressInformation(
      {required Map<String, dynamic> map}) async {
    String url = '/users/rider/address/verify/';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: map);
      if (res == null) {
        HelperFunc.toast('Could not make the request');
        return false;
      }
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Updated successfully.');
        return true;
      } else {
        HelperFunc.toast(body['message']?.toString() ?? 'Failed to update.');
        return false;
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to update.');
    }

    return false;
  }

  @override
  Future<bool> addIdInformation({required Map<String, dynamic> map}) async {
    String url = '/users/rider/id/verify/';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: map);
      if (res == null) {
        HelperFunc.toast('Could not make the request');
        return false;
      }
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Updated successfully.');
        return true;
      } else {
        HelperFunc.toast(body['message']?.toString() ?? 'Failed to update.');
        return false;
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to update.');
    }
    return false;
  }

  @override
  Future<bool> addNINInformation({required Map<String, dynamic> map}) async {
    String url = '/wallets/kyc/nin/';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: map);
      if (res == null) {
        HelperFunc.toast('Could not make the request');
        return false;
      }
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Updated successfully.');
        return true;
      } else {
        HelperFunc.toast(body['message']?.toString() ?? 'Failed to update.');
        return false;
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to update.');
    }
    return false;
  }

  @override
  Future<bool> addVehicleInformation(
      {required Map<String, dynamic> map}) async {
    String url = '/users/rider/vehicle/verify/';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: map);
      if (res == null) {
        HelperFunc.toast('Could not make the request');
        return false;
      }
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Updated successfully.');
        return true;
      } else {
        HelperFunc.toast(body['message']?.toString() ?? 'Failed to update.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to update.');
    }
    return false;
  }

  @override
  Future<bool> updateLocation({
    required double latitude,
    required double longitude,
    required String location,
  }) async {
    String url = '/users/rider/location/';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: {
        'latitude': latitude,
        'longitude': longitude,
        'location': location,
      });
      if (res == null) {
        HelperFunc.toast('Failed to send location');
        return false;
      }
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Updated successfully.');
        return true;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to update location.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to update.');
    }

    return false;
  }

  @override
  Future<bool> changeAvailability({required bool isAvailable}) async {
    String url = '/users/rider/availability/';
    try {
      http.Response? res = await requestHelpers
          .post(url: url, body: {'is_available': isAvailable});
      if (res == null) {
        HelperFunc.toast('Failed to send location');
        return false;
      }
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Changed availability successfully.');
        return true;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to update availability.');
        return false;
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to update.');
      return false;
    }
  }
}
