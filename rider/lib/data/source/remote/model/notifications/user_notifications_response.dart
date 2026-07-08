import 'package:xtridelink_driver/domain/model/api/notifications.dart';

class UserNotificationsResponse {
  String? status;
  String? message;
  Data? data;

  UserNotificationsResponse({this.status, this.message, this.data});

  UserNotificationsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<NotificationData>? results;
  int? page;
  int? pageSize;
  int? total;

  Data({this.results, this.page, this.pageSize, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <NotificationData>[];
      json['results'].forEach((v) {
        results!.add(NotificationData.fromJson(v));
      });
    }
    page = json['page'];
    pageSize = json['page_size'];
    total = json['total'];
  }
}

class Results {
  String? id;
  String? title;
  String? message;
  String? category;
  Map<String, dynamic>? data;
  bool? isRead;
  String? createdAt;

  Results(
      {this.id,
      this.title,
      this.message,
      this.category,
      this.data,
      this.isRead,
      this.createdAt});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    category = json['category'];
    data = json['data'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['message'] = message;
    data['category'] = category;
    data['data'] = this.data;
    data['is_read'] = isRead;
    data['created_at'] = createdAt;
    return data;
  }
}
