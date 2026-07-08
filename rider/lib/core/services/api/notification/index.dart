import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:xtridelink_driver/data/source/remote/model/notifications/user_notifications_response.dart';
import 'package:xtridelink_driver/domain/model/api/notifications.dart';
import '../../../constants/helpers.dart';
import '../request_helper.dart';

sealed class NotificationApiService {
  Future<List<NotificationData>?> getNotifications();
}

class NotificationApiServiceImpl extends NotificationApiService {
  RequestHelpersImpl requestHelpers;
  NotificationApiServiceImpl({required this.requestHelpers});

  @override
  Future<List<NotificationData>?> getNotifications() async {
    String url = '/notifications/in-app/';
    try {
      http.Response? res = await requestHelpers.get(url: url);
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        UserNotificationsResponse notificationResModel =
            UserNotificationsResponse.fromJson(body);
        return notificationResModel.data?.results;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to get notifications.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to get notifications.');
    }
    return null;
  }
}
