import 'dart:convert';

import 'package:flutter/foundation.dart';

class GetUserDetailsResponse {
  final String? status;
  final String? message;
  final User? data;

  GetUserDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetUserDetailsResponse.fromMap(Map<String, dynamic> json) =>
      GetUserDetailsResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null ? null : User.fromJson(json['data']),
      );
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? countryCode;
  DateTime? dob;
  dynamic rating;
  dynamic profileImg;
  String? location;
  String? latitude;
  String? longitude;
  bool? isAvailable;
  bool? isVerified;
  bool? isTrashed;
  bool? isFlagged;
  List<String>? roles;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? orders;
  List<dynamic>? vehicle;
  List<dynamic>? transactions;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.dob,
    required this.rating,
    required this.profileImg,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
    this.isVerified = false,
    required this.isTrashed,
    required this.isFlagged,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
    required this.orders,
    required this.vehicle,
    required this.transactions,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['user_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone_number'] ?? '',
      countryCode: json['country_code'] ?? '+234',
      dob: DateTime.tryParse(json['date_of_birth'] ?? ''),
      rating: json['rating'] ?? 'ZERO',
      profileImg: json['profile_img'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      isAvailable: json['is_available'] ?? false,
      isVerified: json['is_verified'] ?? false,
      isTrashed: json['is_trashed'] ?? false,
      isFlagged: json['is_flagged'] ?? false,
      roles: List<String>.from((json['roles'] ?? []).map((x) => x)),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      orders: List<dynamic>.from((json['orders'] ?? []).map((x) => x)),
      vehicle: List<dynamic>.from((json['vehicle'] ?? []).map((x) => x)),
      transactions:
          List<dynamic>.from((json['transactions'] ?? []).map((x) => x)));

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'firstName': firstName});
    result.addAll({'lastName': lastName});
    result.addAll({'email': email});
    result.addAll({'phone': phone});
    result.addAll({'countryCode': countryCode});
    if (dob != null) {
      result.addAll({'dob': dob!.millisecondsSinceEpoch});
    }
    result.addAll({'rating': rating});
    result.addAll({'profileImg': profileImg});
    result.addAll({'location': location});
    result.addAll({'latitude': latitude});
    result.addAll({'longitude': longitude});
    result.addAll({'isAvailable': isAvailable});
    result.addAll({'isVerified': isVerified});
    result.addAll({'isTrashed': isTrashed});
    result.addAll({'isFlagged': isFlagged});
    result.addAll({'roles': roles});
    result.addAll({'createdAt': createdAt?.millisecondsSinceEpoch});
    result.addAll({'updatedAt': updatedAt?.millisecondsSinceEpoch});
    result.addAll({'orders': orders});
    result.addAll({'vehicle': vehicle});
    result.addAll({'transactions': transactions});

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      countryCode: map['countryCode'] ?? '',
      dob: map['dob'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dob'])
          : null,
      rating: map['rating'],
      profileImg: map['profileImg'],
      location: map['location'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      isAvailable: map['isAvailable'] ?? false,
      isVerified: map['isVerified'] ?? false,
      isTrashed: map['isTrashed'] ?? false,
      isFlagged: map['isFlagged'] ?? false,
      roles: map['roles'] != null ? List<String>.from(map['roles']) : [],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      orders: map['orders'] != null ? List<dynamic>.from(map['orders']) : [],
      vehicle: map['vehicle'] != null ? List<dynamic>.from(map['vehicle']) : [],
      transactions: map['transactions'] != null
          ? List<dynamic>.from(map['transactions'])
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, countryCode: $countryCode, dob: $dob, rating: $rating, profileImg: $profileImg, location: $location, latitude: $latitude, longitude: $longitude, isAvailable: $isAvailable, isVerified: $isVerified, isTrashed: $isTrashed, isFlagged: $isFlagged, roles: $roles, createdAt: $createdAt, updatedAt: $updatedAt, orders: $orders, vehicle: $vehicle, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phone == phone &&
        other.countryCode == countryCode &&
        other.dob == dob &&
        other.rating == rating &&
        other.profileImg == profileImg &&
        other.location == location &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.isAvailable == isAvailable &&
        other.isVerified == isVerified &&
        other.isTrashed == isTrashed &&
        other.isFlagged == isFlagged &&
        listEquals(other.roles, roles) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        listEquals(other.orders, orders) &&
        listEquals(other.vehicle, vehicle) &&
        listEquals(other.transactions, transactions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        countryCode.hashCode ^
        dob.hashCode ^
        rating.hashCode ^
        profileImg.hashCode ^
        location.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        isAvailable.hashCode ^
        isVerified.hashCode ^
        isTrashed.hashCode ^
        isFlagged.hashCode ^
        roles.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        orders.hashCode ^
        vehicle.hashCode ^
        transactions.hashCode;
  }
}
