import 'package:xtridelink_driver/domain/model/api/user.dart';

class AuthResModel {
  AuthData data;

  AuthResModel({
    required this.data,
  });

  factory AuthResModel.fromJson(Map<String, dynamic> json) => AuthResModel(
        data: AuthData.fromJson(json['data'] ?? {}),
      );
}

class AuthData {
  UserData user;
  String accessToken;
  String refreshToken;

  AuthData({
    required this.user,
    required this.accessToken,
    this.refreshToken = '',
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        user: UserData.fromJson(json['user'] ?? {}),
        accessToken: json['access_token'] ?? '',
        refreshToken: json['refresh_token'] ?? '',
      );
}
