class SettingsState {
  String email, password;
  bool biometricsLogin, useEnglish;
  List<RecentLocationData> recentLocations;

  SettingsState(
      {required this.email,
      required this.password,
      required this.biometricsLogin,
      required this.recentLocations,
      required this.useEnglish});

  // SettingsState copyWith(
  //         {String? email,
  //         String? password,
  //         bool? biometricsLogin,
  //         bool? useEnglish}) =>
  //     SettingsState(
  //         email: email ?? this.email,
  //         password: password ?? this.password,
  //         biometricsLogin: biometricsLogin ?? this.biometricsLogin,
  //         useEnglish: useEnglish ?? this.useEnglish);

  factory SettingsState.fromJson(Map<String, dynamic> json) => SettingsState(
      recentLocations: List<RecentLocationData>.from(
          (json['recentLocations'] ?? [])
              .map((x) => RecentLocationData.fromJson(x))),
      email: json['email'],
      password: json['password'],
      biometricsLogin: json['biometricsLogin'],
      useEnglish: json['useEnglish']);

  Map<String, dynamic> get toJson => {
        'recentLocations': recentLocations.map((e) => e.toJson).toList(),
        'email': email,
        'password': password,
        'biometricsLogin': biometricsLogin,
        'useEnglish': useEnglish
      };
}

class RecentLocationData {
  String address;
  num longitude, latitude;
  RecentLocationData(
      {required this.address, required this.longitude, required this.latitude});

  factory RecentLocationData.fromJson(Map<String, dynamic> json) =>
      RecentLocationData(
          address: json['address'],
          longitude: json['longitude'],
          latitude: json['latitude']);

  Map<String, dynamic> get toJson =>
      {'address': address, 'longitude': longitude, 'latitude': latitude};
}
