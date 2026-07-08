import 'ongoing_orders.dart';

class AllOffersResModel {
  List<OfferData> data;

  AllOffersResModel({
    required this.data,
  });

  factory AllOffersResModel.fromJson(Map<String, dynamic> json) =>
      AllOffersResModel(
        data: List<OfferData>.from((json['data']?['offers'] ?? []).map(
            (offer) => OfferData.fromJson(
                json: offer,
                order: ((json['data']?['orders'] ?? []) as List).firstWhere(
                    (order) => order?['id'] == offer['orderId'],
                    orElse: () => null) as Map<String, dynamic>?))),
      );
}

class OfferData {
  String id;
  String senderId;
  String receiverId;
  DateTime createdAt;
  String orderId;
  num amount;
  String status;
  // OrderDetails? order;

  OfferData({
    required this.id,
    required this.createdAt,
    required this.senderId,
    required this.receiverId,
    required this.orderId,
    required this.amount,
    required this.status,
    // required this.order,
  });

  factory OfferData.fromJson(
          {required Map<String, dynamic> json,
          required Map<String, dynamic>? order}) =>
      OfferData(
        id: json['id'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '')?.toLocal() ??
            DateTime.now(),
        senderId: json['senderId'] ?? '',
        receiverId: json['recieverId'] ?? '',
        orderId: json['orderId'] ?? '',
        amount: json['amount'] ?? 0,
        status: json['status'] ?? '',
        // order: order == null ? null : OrderDetails.fromJson(order),
      );
}

// class OrderOfferResModel {
//   OrderOfferData data;
//
//   OrderOfferResModel({
//     required this.data,
//   });
//
//   factory OrderOfferResModel.fromJson(Map<String, dynamic> json) =>
//       OrderOfferResModel(
//         data: OrderOfferData.fromJson(json['data'] ?? {}),
//       );
// }
//
// class OrderOfferData {
//   List<OfferData> offers;
//   List<OrderDetails> orders;
//
//   OrderOfferData({
//     required this.offers,
//     required this.orders,
//   });
//
//   factory OrderOfferData.fromJson(Map<String, dynamic> json) => OrderOfferData(
//         offers: List<OfferData>.from(
//             (json['offers'] ?? []).map((x) => OfferData.fromJson(x))),
//         orders: List<OrderDetails>.from(
//             (json['orders'] ?? []).map((x) => OrderDetails.fromJson(x))),
//       );
// }
