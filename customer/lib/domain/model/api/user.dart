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
  String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String countryCode;
  DateTime? dob;
  dynamic rating;
  String profileImg;
  String location;
  String longitude;
  String latitude;
  bool isOnline;
  bool isTrashed;
  bool isFlagged;
  List<String> roles;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> orders;
  List<dynamic> vehicle;
  List<dynamic> transactions;

  UserData({
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
    required this.longitude,
    required this.latitude,
    required this.isOnline,
    required this.isTrashed,
    required this.isFlagged,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
    required this.orders,
    required this.vehicle,
    required this.transactions,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      countryCode: json['countryCode'] ?? '+234',
      dob: DateTime.tryParse(json['DOB'] ?? ''),
      rating: json['rating'],
      profileImg: json['profileImg'] ?? '',
      location: json['location'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      isOnline: json['isOnline'] ?? false,
      isTrashed: json['isTrashed'] ?? false,
      isFlagged: json['isFlagged'] ?? false,
      roles: List<String>.from((json['roles'] ?? []).map((x) => x)),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      orders: List<dynamic>.from((json['orders'] ?? []).map((x) => x)),
      vehicle: List<dynamic>.from((json['vehicle'] ?? []).map((x) => x)),
      transactions:
          List<dynamic>.from((json['transactions'] ?? []).map((x) => x)));
}
