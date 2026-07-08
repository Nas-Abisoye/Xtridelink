// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromMap(jsonString);

import 'dart:convert';

import 'package:xtridelink/data/source/remote/model/auth/get_user_details_response.dart';

LoginResponse loginResponseFromMap(String str) =>
    LoginResponse.fromMap(json.decode(str));

String loginResponseToMap(LoginResponse data) => json.encode(data.toMap());

class LoginResponse {
  final String? status;
  final String? message;
  final Data? data;

  LoginResponse({
    this.status,
    this.message,
    this.data,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data?.toMap(),
      };
}

class Data {
  final String? accessToken;
  final String? refreshToken;
  final User? user;

  Data({
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "user": user?.toMap(),
      };
}
