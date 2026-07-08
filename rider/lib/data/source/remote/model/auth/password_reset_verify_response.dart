// To parse this JSON data, do
//
//     final passwordResetVerifyResponse = passwordResetVerifyResponseFromMap(jsonString);

import 'dart:convert';

PasswordResetVerifyResponse passwordResetVerifyResponseFromMap(String str) => PasswordResetVerifyResponse.fromMap(json.decode(str));

String passwordResetVerifyResponseToMap(PasswordResetVerifyResponse data) => json.encode(data.toMap());

class PasswordResetVerifyResponse {
    final String? status;
    final String? message;
    final Data? data;

    PasswordResetVerifyResponse({
        this.status,
        this.message,
        this.data,
    });

    factory PasswordResetVerifyResponse.fromMap(Map<String, dynamic> json) => PasswordResetVerifyResponse(
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
    final String? resetToken;

    Data({
        this.resetToken,
    });

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        resetToken: json["reset_token"],
    );

    Map<String, dynamic> toMap() => {
        "reset_token": resetToken,
    };
}
