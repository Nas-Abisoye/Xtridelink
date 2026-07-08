class UserResModel {
  UserData data;

  UserResModel({
    required this.data,
  });

  factory UserResModel.fromJson(Map<String, dynamic> json) => UserResModel(
        data: UserData.fromJson(json['data'] ?? {}),
      );
}

class UserData {
  String? id;
  String? userId;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? gender;
  DateTime? dob;
  String? userType;
  bool? isActive;
  bool? isVerified;
  String? profileImg;
  VerificationStatus? verificationStatus;
  dynamic location;
  dynamic longitude;
  dynamic latitude;
  dynamic rating;
  bool? isAvailable;
  int? totalDeliveries;
  String? currentVehicle;
  String? countryCode;

  UserData(
      {this.id,
      this.userId,
      this.email,
      this.firstName,
      this.lastName,
      this.phone,
      this.gender,
      this.dob,
      this.userType,
      this.isActive,
      this.isVerified,
      this.verificationStatus,
      this.location,
      this.profileImg,
      this.longitude,
      this.latitude,
      this.rating,
      this.isAvailable,
      this.totalDeliveries,
      this.countryCode,
      this.currentVehicle});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone_number'];
    gender = json['gender'];
    dob = json['date_of_birth'] != null
        ? DateTime.parse(json['date_of_birth'])
        : null;
    userType = json['user_type'];
    isActive = json['is_active'];
    profileImg = json['profile_img'];
    isVerified = json['is_verified'];
    verificationStatus = json['verification_status'] != null
        ? VerificationStatus.fromJson(json['verification_status'])
        : null;
    location = json['location'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    rating = json['rating'];
    isAvailable = json['is_available'];
    totalDeliveries = json['total_deliveries'];
    currentVehicle = json['current_vehicle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone_number'] = phone;
    data['gender'] = gender;
    data['date_of_birth'] = dob;
    data['user_type'] = userType;
    data['is_active'] = isActive;
    data['is_verified'] = isVerified;
    if (verificationStatus != null) {
      data['verification_status'] = verificationStatus!.toJson();
    }
    data['location'] = location;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['rating'] = rating;
    data['is_available'] = isAvailable;
    data['total_deliveries'] = totalDeliveries;
    data['current_vehicle'] = currentVehicle;
    return data;
  }
}

class VerificationStatus {
  bool? accountVerified;
  bool? accountActive;
  bool? vehicleVerified;
  String? vehicleStatus;
  bool? idVerified;
  String? idStatus;
  bool? addressVerified;
  String? addressStatus;
  bool? fullyVerified;

  VerificationStatus(
      {this.accountVerified,
      this.accountActive,
      this.vehicleVerified,
      this.vehicleStatus,
      this.idVerified,
      this.idStatus,
      this.addressVerified,
      this.addressStatus,
      this.fullyVerified});

  VerificationStatus.fromJson(Map<String, dynamic> json) {
    accountVerified = json['account_verified'];
    accountActive = json['account_active'];
    vehicleVerified = json['vehicle_verified'];
    vehicleStatus = json['vehicle_status'];
    idVerified = json['id_verified'];
    idStatus = json['id_status'];
    addressVerified = json['address_verified'];
    addressStatus = json['address_status'];
    fullyVerified = json['fully_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_verified'] = accountVerified;
    data['account_active'] = accountActive;
    data['vehicle_verified'] = vehicleVerified;
    data['vehicle_status'] = vehicleStatus;
    data['id_verified'] = idVerified;
    data['id_status'] = idStatus;
    data['address_verified'] = addressVerified;
    data['address_status'] = addressStatus;
    data['fully_verified'] = fullyVerified;
    return data;
  }
}

class RiderAnalyticsRes {
  RiderAnalytics data;

  RiderAnalyticsRes({
    required this.data,
  });

  factory RiderAnalyticsRes.fromJson(Map<String, dynamic> json) =>
      RiderAnalyticsRes(
        data: RiderAnalytics.fromJson(json['data'] ?? {}),
      );
}

class RiderAnalytics {
  String id;
  num orderCompleted;
  String userId;
  num distanceCovered;
  dynamic idVerification;
  dynamic license;
  bool isActive;
  dynamic addressVerification;
  dynamic businessId;
  String rating;
  String kycVerified;
  String withdrawalAccountId;
  String payoutType;
  num upNegotiationRate;
  num downNegotiationRate;
  String status;

  RiderAnalytics({
    required this.id,
    required this.orderCompleted,
    required this.userId,
    required this.distanceCovered,
    required this.idVerification,
    required this.license,
    required this.isActive,
    required this.addressVerification,
    required this.businessId,
    required this.rating,
    required this.kycVerified,
    required this.withdrawalAccountId,
    required this.payoutType,
    required this.upNegotiationRate,
    required this.downNegotiationRate,
    required this.status,
  });

  factory RiderAnalytics.fromJson(Map<String, dynamic> json) => RiderAnalytics(
        id: json['id'] ?? '',
        orderCompleted: json['orderCompoleted'] ?? 0,
        userId: json['userId'] ?? '',
        distanceCovered: json['distanceCovered'] ?? 0,
        idVerification: json['idVerification'],
        license: json['license'],
        isActive: json['isActive'] ?? false,
        addressVerification: json['addressVerification'],
        businessId: json['businessId'],
        rating: json['rating'] ?? '',
        kycVerified: json['kycVerified'] ?? '',
        withdrawalAccountId: json['withdrawalAccountId'] ?? '',
        payoutType: json['payoutType'] ?? '',
        upNegotiationRate: json['upNegotiationRate'] ?? 0,
        downNegotiationRate: json['downNegotiationRate'] ?? 0,
        status: json['status'] ?? '',
      );
}
