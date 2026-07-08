// To parse this JSON data, do
//
//     final getUserDetailsResponse = getUserDetailsResponseFromMap(jsonString);

import 'dart:convert';

GetUserDetailsResponse getUserDetailsResponseFromMap(String str) =>
    GetUserDetailsResponse.fromMap(json.decode(str));

String getUserDetailsResponseToMap(GetUserDetailsResponse data) =>
    json.encode(data.toMap());

class GetUserDetailsResponse {
  final String? status;
  final String? message;
  final UserAccountData? data;

  GetUserDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetUserDetailsResponse.fromMap(Map<String, dynamic> json) =>
      GetUserDetailsResponse(
        status: json['status'],
        message: json['message'],
        data:
            json['data'] == null ? null : UserAccountData.fromMap(json['data']),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'data': data?.toMap(),
      };
}

class UserAccountData {
  final String? id;
  final User? user;
  final dynamic location;
  final dynamic longitude;
  final dynamic latitude;
  final dynamic rating;
  final bool? isAvailable;
  final int? totalDeliveries;
  final dynamic currentVehicle;

  UserAccountData({
    this.id,
    this.user,
    this.location,
    this.longitude,
    this.latitude,
    this.rating,
    this.isAvailable,
    this.totalDeliveries,
    this.currentVehicle,
  });

  factory UserAccountData.fromMap(Map<String, dynamic> json) => UserAccountData(
        id: json['id'],
        user: json['user'] == null ? null : User.fromMap(json['user']),
        location: json['location'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        rating: json['rating'],
        isAvailable: json['is_available'],
        totalDeliveries: json['total_deliveries'],
        currentVehicle: json['current_vehicle'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user': user?.toMap(),
        'location': location,
        'longitude': longitude,
        'latitude': latitude,
        'rating': rating,
        'is_available': isAvailable,
        'total_deliveries': totalDeliveries,
        'current_vehicle': currentVehicle,
      };
}

class User {
  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? gender;
  final dynamic dateOfBirth;
  final String? userType;
  final bool? isActive;
  final bool? isVerified;

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.userType,
    this.isActive,
    this.isVerified,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        phoneNumber: json['phone_number'],
        gender: json['gender'],
        dateOfBirth: json['date_of_birth'],
        userType: json['user_type'],
        isActive: json['is_active'],
        isVerified: json['is_verified'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'user_type': userType,
        'is_active': isActive,
        'is_verified': isVerified,
      };
}
