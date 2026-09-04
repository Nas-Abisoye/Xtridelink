// import 'package:xtridelink/domain/model/api/order_det.dart';

class TrackingResData {
  TrackingData data;

  TrackingResData({
    required this.data,
  });

  factory TrackingResData.fromJson(Map<String, dynamic> json) =>
      TrackingResData(
        data: TrackingData.fromJson(json['data'] ?? {}),
      );
}

class TrackingData {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String orderId;
  String otp;
  String riderId;
  String orderLocation;
  DateTime packagePicking;
  dynamic packagePickedup;
  dynamic packageOnTransit;
  dynamic packageDelivered;
  // OrderDetails order;

  TrackingData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.orderId,
    required this.riderId,
    required this.otp,
    required this.orderLocation,
    required this.packagePicking,
    required this.packagePickedup,
    required this.packageOnTransit,
    required this.packageDelivered,
    // required this.order,
  });

  factory TrackingData.fromJson(Map<String, dynamic> json) => TrackingData(
        id: json['id'] ?? '',
        createdAt: DateTime.parse(
            json['createdAt'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json['updatedAt'] ?? DateTime.now().toIso8601String()),
        orderId: json['orderId'] ?? '',
        riderId: json['riderId'] ?? '',
        otp: json['otp'].toString(),
        orderLocation: json['orderLocation'] ?? '',
        packagePicking: DateTime.parse(
            json['packagePicking'] ?? DateTime.now().toIso8601String()),
        packagePickedup: json['packagePickedup'] == null
            ? null
            : DateTime.parse(json['packagePickedup']),
        packageOnTransit: json['packageOnTransit'] == null
            ? null
            : DateTime.parse(json['packageOnTransit']),
        packageDelivered: json['packageDelivered'] == null
            ? null
            : DateTime.parse(json['packageDelivered']),
        // order: OrderDetails.fromJson(json['order'] ?? {}),
      );
}
