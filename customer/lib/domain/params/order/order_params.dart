import 'package:equatable/equatable.dart';

import 'package:xtridelink/core/constants/enumerations.dart';

class OrderParams extends Equatable {
  final String? pickupAddress;
  final String? pickupLatitude;
  final String? pickupLongitude;
  final String? deliveryAddress;
  final String? deliveryLatitude;
  final String? deliveryLongitude;
  final OrderType? orderType;
  final DeliveryType? deliveryType;
  final PackageType? packageType;
  final VehicleType? vehicleType;
  final String? recipientName;
  final String? recipientPhone;
  final String? recipientEmail;
  final String? deliveryNotes;
  final bool? enable2Fa;
  final String? codeDeliveryMethod;
  final String? basePrice;

  OrderParams({
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
    this.enable2Fa,
    this.codeDeliveryMethod,
    this.basePrice,
  });

  Map<String, dynamic> toMap() => {
        'pickup_address': pickupAddress,
        'pickup_latitude': pickupLatitude,
        'pickup_longitude': pickupLongitude,
        'delivery_address': deliveryAddress,
        'delivery_latitude': deliveryLatitude,
        'delivery_longitude': deliveryLongitude,
        'order_type': orderType?.name,
        'delivery_type': deliveryType?.name,
        'package_type': packageType?.name,
        'vehicle_type': vehicleType?.name,
        'recipient_name': recipientName,
        'recipient_phone': recipientPhone,
        'recipient_email': recipientEmail,
        'delivery_notes': deliveryNotes,
        'enable_2fa': enable2Fa ?? false,
        'code_delivery_method': codeDeliveryMethod,
        'base_price': basePrice,
      };

  OrderParams copyWith({
    String? pickupAddress,
    String? pickupLatitude,
    String? pickupLongitude,
    String? deliveryAddress,
    String? deliveryLatitude,
    String? deliveryLongitude,
    OrderType? orderType,
    DeliveryType? deliveryType,
    PackageType? packageType,
    VehicleType? vehicleType,
    String? recipientName,
    String? recipientPhone,
    String? recipientEmail,
    String? deliveryNotes,
    bool? enable2Fa,
    String? codeDeliveryMethod,
    String? basePrice,
  }) {
    return OrderParams(
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
      enable2Fa: enable2Fa ?? this.enable2Fa,
      codeDeliveryMethod: codeDeliveryMethod ?? this.codeDeliveryMethod,
      basePrice: basePrice ?? this.basePrice,
    );
  }

  @override
  String toString() {
    return 'OrderParams(pickupAddress: $pickupAddress, pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, deliveryAddress: $deliveryAddress, deliveryLatitude: $deliveryLatitude, deliveryLongitude: $deliveryLongitude, orderType: $orderType, deliveryType: $deliveryType, packageType: $packageType, vehicleType: $vehicleType, recipientName: $recipientName, recipientPhone: $recipientPhone, recipientEmail: $recipientEmail, deliveryNotes: $deliveryNotes, enable2Fa: $enable2Fa, codeDeliveryMethod: $codeDeliveryMethod, basePrice: $basePrice)';
  }

  @override
  List<Object?> get props {
    return [
      pickupAddress,
      pickupLatitude,
      pickupLongitude,
      deliveryAddress,
      deliveryLatitude,
      deliveryLongitude,
      orderType,
      deliveryType,
      packageType,
      vehicleType,
      recipientName,
      recipientPhone,
      recipientEmail,
      deliveryNotes,
      enable2Fa,
      codeDeliveryMethod,
      basePrice,
    ];
  }
}

// enum VehicleType { bicycle, motorcycle, car, van, truck }

// enum PackageType { parcel, groceries, general }

enum DeliveryType { express, normal }

// enum OrderType { send, receive }
