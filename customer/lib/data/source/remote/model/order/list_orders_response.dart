// To parse this JSON data, do
//
//     final listOrdersResponse = listOrdersResponseFromMap(jsonString);

import 'dart:convert';

import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';

ListOrdersResponse listOrdersResponseFromMap(String str) =>
    ListOrdersResponse.fromMap(json.decode(str));

String listOrdersResponseToMap(ListOrdersResponse data) =>
    json.encode(data.toMap());

class ListOrdersResponse {
  final String? status;
  final String? message;
  final List<OrderDetails>? data;

  ListOrdersResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ListOrdersResponse.fromMap(Map<String, dynamic> json) =>
      ListOrdersResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null
            ? []
            : List<OrderDetails>.from(
                json['data']['orders']!.map((x) => OrderDetails.fromJson(x))),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
