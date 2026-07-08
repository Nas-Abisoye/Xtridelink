import 'package:xtridelink/domain/model/api/order_det.dart';

class OfferAcceptedCheckData {
  OfferAcceptData data;

  OfferAcceptedCheckData({
    required this.data,
  });
  factory OfferAcceptedCheckData.fromJson(Map<String, dynamic> json) =>
      OfferAcceptedCheckData(
        data: OfferAcceptData.fromJson(json['data'] ?? {}),
      );
}

class OfferAcceptData {
  OfferData offer;
  OrderTrackData orderTracking;

  OfferAcceptData({
    required this.offer,
    required this.orderTracking,
  });

  factory OfferAcceptData.fromJson(Map<String, dynamic> json) =>
      OfferAcceptData(
        offer: OfferData.fromJson(json['offer'] ?? {}),
        orderTracking: OrderTrackData.fromJson(json['orderTracking'] ?? {}),
      );
}

class OfferData {
  String id;
  String senderId;
  String recieverId;
  String orderId;
  num amount;
  String status;

  OfferData({
    required this.id,
    required this.senderId,
    required this.recieverId,
    required this.orderId,
    required this.amount,
    required this.status,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) => OfferData(
        id: json['id'] ?? '',
        senderId: json['senderId'] ?? '',
        recieverId: json['recieverId'] ?? '',
        orderId: json['orderId'] ?? '',
        amount: json['amount'] ?? 0,
        status: json['status'] ?? '',
      );
}
