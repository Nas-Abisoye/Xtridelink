// To parse this JSON data, do
//
//     final defaultResponse = defaultResponseFromMap(jsonString);

import 'dart:convert';

DefaultResponse defaultResponseFromMap(String str) => DefaultResponse.fromMap(json.decode(str));

String defaultResponseToMap(DefaultResponse data) => json.encode(data.toMap());

class DefaultResponse {
    final String? status;
    final String? message;

    DefaultResponse({
        this.status,
        this.message,
    });

    factory DefaultResponse.fromMap(Map<String, dynamic> json) => DefaultResponse(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
    };
}
