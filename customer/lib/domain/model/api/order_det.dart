import 'package:google_maps_flutter/google_maps_flutter.dart';

// class OrdersListResModel {
//   OrdersListModel data;

//   OrdersListResModel({
//     required this.data,
//   });

//   factory OrdersListResModel.fromJson(Map<String, dynamic> json) =>
//       OrdersListResModel(
//         data: OrdersListModel.fromJson(json['data'] ?? {}),
//       );
// }

// class OrdersListModel {
//   List<OrderDetails> data;

//   OrdersListModel({
//     required this.data,
//   });

//   factory OrdersListModel.fromJson(Map<String, dynamic> json) =>
//       OrdersListModel(
//         data: List<OrderDetails>.from(
//             (json['data'] ?? []).map((x) => OrderDetails.fromJson(x))),
//       );
// }

// class OrderDetResModel {
//   OrderDetails data;

//   OrderDetResModel({
//     required this.data,
//   });

//   factory OrderDetResModel.fromJson(Map<String, dynamic> json) =>
//       OrderDetResModel(
//         data: OrderDetails.fromJson(json['data'] ?? {}),
//       );
// }

// class OrderDetails {
//   String id;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String userId;
//   String title;
//   String status;
//   String type;
//   String paymentMethod;
//   String locationPickup;
//   String locationDelivery;
//   num? amount;
//   bool has2FaCode;
//   String otp;
//   String deliveryType;
//   String packageType;
//   String alertMethod;
//   String vehicleType;
//   int percentage;
//   OrderRecipientData? recipient;
//   OrderTrackData? trackingId;
//   OrderRiderData? rider;
//   final LatLng deliveryLocation;
//   final LatLng pickupLocation;

//   OrderDetails({
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.userId,
//     required this.title,
//     required this.status,
//     required this.type,
//     required this.paymentMethod,
//     required this.locationPickup,
//     required this.locationDelivery,
//     required this.has2FaCode,
//     required this.alertMethod,
//     required this.amount,
//     required this.otp,
//     required this.deliveryType,
//     required this.packageType,
//     required this.vehicleType,
//     required this.percentage,
//     required this.recipient,
//     required this.trackingId,
//     required this.deliveryLocation,
//     required this.pickupLocation,
//     required this.rider,
//   });

//   factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
//         id: json['id'] ?? '',
//         createdAt: DateTime.parse(
//             json['createdAt'] ?? DateTime.now().toIso8601String()),
//         updatedAt: DateTime.parse(
//             json['updatedAt'] ?? DateTime.now().toIso8601String()),
//         userId: json['userId'] ?? '',
//         title: json['title'] ?? '',
//         status: json['status'] ?? '',
//         type: json['type'] ?? '',
//         paymentMethod: json['paymentMethod'] ?? '',
//         locationPickup: json['locationPickup'] ?? '',
//         locationDelivery: json['locationDelivery'] ?? '',
//         amount: json['amount'],
//         has2FaCode: json['has2faCode'] ?? false,
//         otp: json['trackingId']?['otp'].toString() ?? '',
//         deliveryType: json['deliveryType'] ?? '',
//         alertMethod: json['alertMethod'] ?? '',
//         packageType: json['packageType'] ?? '',
//         vehicleType: json['vehicleType'] ?? '',
//         percentage: json['percentage'] ?? 0,
//         deliveryLocation: LatLng(
//             (num.tryParse(json['deliveryLocation']?['latitude'] ?? '') ?? 0)
//                 .toDouble(),
//             (num.tryParse(json['deliveryLocation']?['longitude'] ?? '') ?? 0)
//                 .toDouble()),
//         pickupLocation: LatLng(
//             (num.tryParse(json['pickupLocation']?['latitude'] ?? '') ?? 0)
//                 .toDouble(),
//             (num.tryParse(json['pickupLocation']?['longitude'] ?? '') ?? 0)
//                 .toDouble()),
//         trackingId: json['trackingId'] == null
//             ? null
//             : OrderTrackData.fromJson(json['trackingId']),
//         recipient: json['orderReciepient'] == null
//             ? null
//             : OrderRecipientData.fromJson(json['orderReciepient']),
//         rider: json['rider'] == null
//             ? null
//             : OrderRiderData.fromJson(json['rider']),
//       );
// }

class OrderTrackEventData {
  OrderTrackData data;

  OrderTrackEventData({
    required this.data,
  });

  factory OrderTrackEventData.fromJson(Map<String, dynamic> json) =>
      OrderTrackEventData(data: OrderTrackData.fromJson(json['data'] ?? {}));
}

class OrderTrackData {
  String id;
  String orderId;
  String riderId;
  String otp;
  String orderLocation;
  DateTime? packagePicking;
  DateTime? packagePickedup;
  DateTime? packageOnTransit;
  DateTime? packageDelivered;

  OrderTrackData({
    required this.id,
    required this.orderId,
    required this.riderId,
    required this.otp,
    required this.orderLocation,
    required this.packagePicking,
    required this.packagePickedup,
    required this.packageOnTransit,
    required this.packageDelivered,
  });

  factory OrderTrackData.fromJson(Map<String, dynamic> json) => OrderTrackData(
      id: json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      riderId: json['riderId'] ?? '',
      otp: json['otp'].toString(),
      orderLocation: json['orderLocation'] ?? '',
      packagePicking: json['packagePicking'] == null
          ? null
          : DateTime.parse(json['packagePicking']),
      packagePickedup: json['packagePickedup'] == null
          ? null
          : DateTime.parse(json['packagePickedup']),
      packageOnTransit: json['packageOnTransit'] == null
          ? null
          : DateTime.parse(json['packageOnTransit']),
      packageDelivered: json['packageDelivered'] == null
          ? null
          : DateTime.parse(json['packageDelivered']));
}

class OrderRiderData {
  String id;
  String userId;
  bool isActive;
  dynamic businessId;
  String rating;
  String? vehicleName;
  String? vehiclePlateNo;
  num upNegotiationRate;
  num downNegotiationRate;
  RiderUserData user;

  OrderRiderData({
    required this.id,
    required this.userId,
    required this.isActive,
    required this.businessId,
    required this.rating,
    required this.vehicleName,
    required this.vehiclePlateNo,
    required this.upNegotiationRate,
    required this.downNegotiationRate,
    required this.user,
  });

  factory OrderRiderData.fromJson(Map<String, dynamic> json) => OrderRiderData(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        isActive: json['isActive'] ?? false,
        businessId: json['businessId'],
        vehicleName: json['vehicle']?['name'],
        vehiclePlateNo: json['vehicle']?['plateNo'],
        rating: json['rating'] ?? '',
        upNegotiationRate: json['upNegotiationRate'] ?? 0,
        downNegotiationRate: json['downNegotiationRate'] ?? 0,
        user: RiderUserData.fromJson(json['user'] ?? {}),
      );
}

class RiderUserData {
  String id;
  String firstName;
  String lastName;
  String phone;
  String profileImg;
  String countryCode;
  String email;
  String latitude;
  String longitude;
  String location;

  RiderUserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImg,
    required this.phone,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.location,
  });

  factory RiderUserData.fromJson(Map<String, dynamic> json) => RiderUserData(
        id: json['id'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        profileImg: json['profileImg'] ?? '',
        countryCode: json['countryCode'] ?? '',
        latitude: json['latitude'] ?? '',
        longitude: json['longitude'] ?? '',
        location: json['location'] ?? '',
      );
}

class OrderRecipientData {
  String id;
  String name;
  String email;
  String phone;
  String comment;

  OrderRecipientData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.comment,
  });

  factory OrderRecipientData.fromJson(Map<String, dynamic> json) =>
      OrderRecipientData(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        comment: json['comment'] ?? '',
      );
}
