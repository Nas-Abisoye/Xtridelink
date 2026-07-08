class LocationPredictionsRes {
  List<LocationPrediction> predictions;

  LocationPredictionsRes({
    required this.predictions,
  });

  factory LocationPredictionsRes.fromJson(Map<String, dynamic> json) =>
      LocationPredictionsRes(
          predictions: List<LocationPrediction>.from((json['predictions'] ?? [])
              .map((x) => LocationPrediction.fromJson(x))));
}

class LocationPrediction {
  String description;
  String placeId;

  LocationPrediction({
    required this.description,
    required this.placeId,
  });

  factory LocationPrediction.fromJson(Map<String, dynamic> json) =>
      LocationPrediction(
        description: json['description'] ?? '',
        placeId: json['place_id'] ?? '',
      );
}

class LocationData {
  String placeId;
  String address;
  num latitude;
  num longitude;

  LocationData({
    required this.placeId,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        placeId: json['result']?['place_id'] ?? '',
        address: json['result']?['formatted_address'] ?? '',
        latitude: json['result']?['geometry']?['location']?['lat'] ?? 0,
        longitude: json['result']?['geometry']?['location']?['lng'] ?? 0,
      );

  LocationData copyWith({
    String? placeId,
    String? address,
    num? latitude,
    num? longitude,
  }) =>
      LocationData(
        placeId: placeId ?? this.placeId,
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
}
