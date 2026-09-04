// To parse this JSON data, do
//
//     final createOrderResponse = createOrderResponseFromMap(jsonString);

import 'dart:convert';

// import 'package:xtridelink/core/constants/enumerations.dart';

CreateOrderResponse createOrderResponseFromMap(String str) =>
    CreateOrderResponse.fromMap(json.decode(str));

String createOrderResponseToMap(CreateOrderResponse data) =>
    json.encode(data.toMap());

class CreateOrderResponse {
  final String? status;
  final String? message;
  final OrderDetails? data;

  CreateOrderResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CreateOrderResponse.fromMap(Map<String, dynamic> json) =>
      CreateOrderResponse(
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

class OrderDetails {
  String? id;
  CustomerDetails? customerDetails;
  RiderDetails? riderDetails;
  String? createdAt;
  String? updatedAt;
  String? trackingId;
  String? pickupAddress;
  double? pickupLatitude;
  double? pickupLongitude;
  String? deliveryAddress;
  double? deliveryLatitude;
  double? deliveryLongitude;
  String? orderType;
  String? deliveryType;
  String? packageType;
  String? vehicleType;
  String? recipientName;
  String? recipientPhone;
  String? recipientEmail;
  String? deliveryNotes;
  bool? enable2fa;
  String? deliveryCode;
  String? codeDeliveryMethod;
  String? basePrice;
  String? negotiatedPrice;
  String? finalPrice;
  String? status;
  String? customer;
  String? paymentMethod;
  String? rider;
  bool? isPaymentCompleted;
  String? paymentCompletedAt;

  OrderDetails({
    this.id,
    this.customerDetails,
    this.riderDetails,
    this.createdAt,
    this.updatedAt,
    this.trackingId,
    this.pickupAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.deliveryAddress,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.orderType,
    this.deliveryType,
    this.packageType,
    this.vehicleType,
    this.recipientName,
    this.recipientPhone,
    this.recipientEmail,
    this.deliveryNotes,
    this.enable2fa,
    this.deliveryCode,
    this.codeDeliveryMethod,
    this.basePrice,
    this.negotiatedPrice,
    this.finalPrice,
    this.status,
    this.customer,
    this.rider,
    this.paymentMethod,
    this.isPaymentCompleted,
    this.paymentCompletedAt,
  });

  OrderDetails.empty() : this();

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerDetails = json['customer_details'] != null
        ? CustomerDetails.fromJson(json['customer_details'])
        : null;
    riderDetails = json['rider_details'] != null
        ? RiderDetails.fromJson(json['rider_details'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    trackingId = json['tracking_id'];
    pickupAddress = json['pickup_address'];
    pickupLatitude = json['pickup_latitude'];
    pickupLongitude = json['pickup_longitude'];
    deliveryAddress = json['delivery_address'];
    deliveryLatitude = json['delivery_latitude'];
    deliveryLongitude = json['delivery_longitude'];
    orderType = json['order_type'];
    deliveryType = json['delivery_type'];
    packageType = json['package_type'];
    vehicleType = json['vehicle_type'];
    recipientName = json['recipient_name'];
    recipientPhone = json['recipient_phone'];
    recipientEmail = json['recipient_email'];
    deliveryNotes = json['delivery_notes'];
    enable2fa = json['enable_2fa'];
    deliveryCode = json['delivery_code'];
    codeDeliveryMethod = json['code_delivery_method'];
    basePrice = json['base_price'];
    negotiatedPrice = json['negotiated_price'];
    finalPrice = json['final_price'];
    status = json['status'];
    customer = json['customer'];
    rider = json['rider'];
    paymentMethod = json['payment_method'] ?? 'Transfer';
    isPaymentCompleted = json['is_payment_completed'];
    paymentCompletedAt = json['payment_completed_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (customerDetails != null) {
      data['customer_details'] = customerDetails!.toJson();
    }
    if (riderDetails != null) {
      data['rider_details'] = riderDetails!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['tracking_id'] = trackingId;
    data['pickup_address'] = pickupAddress;
    data['pickup_latitude'] = pickupLatitude;
    data['pickup_longitude'] = pickupLongitude;
    data['delivery_address'] = deliveryAddress;
    data['delivery_latitude'] = deliveryLatitude;
    data['delivery_longitude'] = deliveryLongitude;
    data['order_type'] = orderType;
    data['delivery_type'] = deliveryType;
    data['package_type'] = packageType;
    data['vehicle_type'] = vehicleType;
    data['recipient_name'] = recipientName;
    data['recipient_phone'] = recipientPhone;
    data['recipient_email'] = recipientEmail;
    data['delivery_notes'] = deliveryNotes;
    data['enable_2fa'] = enable2fa;
    data['delivery_code'] = deliveryCode;
    data['code_delivery_method'] = codeDeliveryMethod;
    data['base_price'] = basePrice;
    data['negotiated_price'] = negotiatedPrice;
    data['final_price'] = finalPrice;
    data['status'] = status;
    data['customer'] = customer;
    data['rider'] = rider;
    data['is_payment_completed'] = isPaymentCompleted;
    data['payment_completed_at'] = paymentCompletedAt;
    return data;
  }

  OrderDetails copyWith({
    String? id,
    CustomerDetails? customerDetails,
    RiderDetails? riderDetails,
    String? createdAt,
    String? updatedAt,
    String? trackingId,
    String? pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    String? deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String? orderType,
    String? deliveryType,
    String? packageType,
    String? vehicleType,
    String? recipientName,
    String? recipientPhone,
    String? recipientEmail,
    String? deliveryNotes,
    bool? enable2fa,
    Null deliveryCode,
    String? codeDeliveryMethod,
    String? basePrice,
    String? negotiatedPrice,
    String? finalPrice,
    String? status,
    String? customer,
    String? paymentMethod,
    String? rider,
    bool? isPaymentCompleted,
    String? paymentCompletedAt,
  }) {
    return OrderDetails(
      id: id ?? this.id,
      customerDetails: customerDetails ?? this.customerDetails,
      riderDetails: riderDetails ?? this.riderDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      trackingId: trackingId ?? this.trackingId,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
      deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
      orderType: orderType ?? this.orderType,
      deliveryType: deliveryType ?? this.deliveryType,
      packageType: packageType ?? this.packageType,
      vehicleType: vehicleType ?? this.vehicleType,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      enable2fa: enable2fa ?? this.enable2fa,
      deliveryCode: deliveryCode ?? this.deliveryCode,
      codeDeliveryMethod: codeDeliveryMethod ?? this.codeDeliveryMethod,
      basePrice: basePrice ?? this.basePrice,
      negotiatedPrice: negotiatedPrice ?? this.negotiatedPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      status: status ?? this.status,
      customer: customer ?? this.customer,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      rider: rider ?? this.rider,
      isPaymentCompleted: isPaymentCompleted ?? this.isPaymentCompleted,
      paymentCompletedAt: paymentCompletedAt ?? this.paymentCompletedAt,
    );
  }
}

class CustomerDetails {
  String? id;
  String? name;
  String? phoneNumber;
  String? email;

  CustomerDetails({this.id, this.name, this.phoneNumber, this.email});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    return data;
  }
}

class RiderDetails {
  String? id;
  String? name;
  String? phoneNumber;
  String? email;
  Null riderStuff;

  RiderDetails(
      {this.id, this.name, this.phoneNumber, this.email, this.riderStuff});

  RiderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    riderStuff = json['rider_stuff'];
  }

  String? get latitude => null;

  String? get longitude => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['rider_stuff'] = riderStuff;
    return data;
  }
}
