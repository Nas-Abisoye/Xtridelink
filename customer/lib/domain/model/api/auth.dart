import 'package:xtridelink/domain/model/api/user.dart';

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
  String token;

  AuthData({
    required this.user,
    required this.token,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        user: UserData.fromJson(json['user'] ?? {}),
        token: json['token'] ?? '',
      );
}
