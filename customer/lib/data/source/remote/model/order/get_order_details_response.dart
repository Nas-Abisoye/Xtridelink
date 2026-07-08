// To parse this JSON data, do
//
//     final getOrderDetailsResponse = getOrderDetailsResponseFromMap(jsonString);

import 'dart:convert';

import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';

GetOrderDetailsResponse getOrderDetailsResponseFromMap(String str) =>
    GetOrderDetailsResponse.fromMap(json.decode(str));

String getOrderDetailsResponseToMap(GetOrderDetailsResponse data) =>
    json.encode(data.toMap());

class GetOrderDetailsResponse {
  final String? status;
  final String? message;
  final OrderDetails? data;

  GetOrderDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetOrderDetailsResponse.fromMap(Map<String, dynamic> json) =>
      GetOrderDetailsResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null ? null : OrderDetails.fromJson(json['data']),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
