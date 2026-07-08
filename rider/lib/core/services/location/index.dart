import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:xtridelink_driver/domain/model/api/location_prediction.dart';
import '../../constants/helpers.dart';
import '../../constants/strings.dart';
import 'package:geolocator/geolocator.dart';
import '../api/request_helper.dart';
import '../socket/index.dart';
import '../storage/index.dart';

class LocationMapService {
  final RequestHelpersImpl requestHelpersImpl;
  final SocketService socketService;
  final StorageServiceImpl storageServiceImpl;
  StreamSubscription<Position>? positionStream;
  LocationMapService(
      {required this.requestHelpersImpl,
      required this.socketService,
      required this.storageServiceImpl});

  Future<List<LocationPrediction>?> getPredictions(String query) async {
    try {
      http.Response? res = await requestHelpersImpl.get(
          useToken: false,
          host: GlobalStrings.googleMapHost,
          url: '/maps/api/place/autocomplete/json',
          queryParameters: {
            'input': query,
            'components': 'country:ng',
            'key': Platform.isAndroid
                ? GlobalStrings.androidAPIKey
                : GlobalStrings.iosAPIKey
          });
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        LocationPredictionsRes locationPredictionsRes =
            LocationPredictionsRes.fromJson(body);
        return locationPredictionsRes.predictions;
      }
    } catch (e) {
      HelperFunc.logger(e.toString());
    }
    return null;
  }

  Future<LocationData?> getLocationDetails(String placeId) async {
    try {
      http.Response? res = await requestHelpersImpl.get(
          useToken: false,
          host: GlobalStrings.googleMapHost,
          url: '/maps/api/place/details/json',
          queryParameters: {
            'placeid': placeId,
            'key': Platform.isAndroid
                ? GlobalStrings.androidAPIKey
                : GlobalStrings.iosAPIKey
          });
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return LocationData.fromJson(body);
      } else {
        HelperFunc.toast('Failed to get location details');
      }
    } catch (e) {
      HelperFunc.logger(e.toString());
    }
    return null;
  }

  Future<Position> getPosition() async {
    await _requestLocationPermission();
    Position position = await Geolocator.getCurrentPosition();
    HelperFunc.logger(
        'Latitude: ${position.latitude}\nLongitude: ${position.longitude}');
    return position;
  }

  Future<String?> getLocationFromPosition(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      return '${placemarks[0].name ?? ''}, ${placemarks[0].locality ?? ''}, ${placemarks[0].administrativeArea ?? ''}, ${placemarks[0].country ?? ''}';
    } catch (e) {
      HelperFunc.logger(e.toString());
      HelperFunc.toast('Failed to get your current location');
      return null;
    }
  }

  double? distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    try {
      /// IN KILOMETERS
      return (Geolocator.distanceBetween(
              startLatitude, startLongitude, endLatitude, endLongitude) /
          1000);
    } catch (e) {
      HelperFunc.logger('Distance Error: ${e.toString()}');
      return null;
    }
  }

  Future<void> cancelLocationStream() async {
    await positionStream?.cancel();
    positionStream = null;
    HelperFunc.logger('Location stream canceled');
  }

  void updateLocationStream(String userId) async {
    await _requestLocationPermission();
    try {
      late LocationSettings locationSettings;
      if (defaultTargetPlatform == TargetPlatform.android) {
        locationSettings = AndroidSettings(
            accuracy: LocationAccuracy.high,
            // distanceFilter: 100,
            intervalDuration: const Duration(seconds: 30),
            foregroundNotificationConfig: const ForegroundNotificationConfig(
                notificationText:
                    'xtridelink_driver will continue to receive your location updates',
                notificationTitle: 'Location Update',
                enableWakeLock: true));
      } else if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.fitness,
          // distanceFilter: 100,
          pauseLocationUpdatesAutomatically: true,
          showBackgroundLocationIndicator: false,
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          // distanceFilter: 100,
        );
      }

      positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) {
        if (position == null) {
          HelperFunc.logger('Location: INVALID POSITION');
          return;
        }

        var locationData = {
          'userId': userId,
          'data': {
            'latitude': position.latitude.toString(),
            'longitude': position.longitude.toString(),
          }
        };
        updateRiderLocation(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        HelperFunc.logger('updateLocation: $locationData');
      });

      positionStream?.onError((error, stackTrace) {
        HelperFunc.logger('Location Update error $error');
        HelperFunc.logger('Location Update stackTrace $stackTrace');
      });
    } catch (e) {
      HelperFunc.logger('Location Update stream $e');
    }
  }

  Future<void> _requestLocationPermission() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          HelperFunc.toast('Location permissions are denied');
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        HelperFunc.toast(
            'Location permissions are permanently denied, we cannot request permissions.');
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    } catch (e) {
      HelperFunc.logger('PERMISSION ERROR: ${e.toString()}');
    }
  }

  Future<void> updateRiderLocation(
      {required double latitude, required double longitude}) async {
    String url = '/users/rider/location/';
    try {
      http.Response? res = await requestHelpersImpl.post(url: url, body: {
        'latitude': latitude,
        'longitude': longitude,
      });
      if (res == null) {
        HelperFunc.toast('Failed to send location');
        return;
      }
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Updated successfully.');
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to update location.');
      }
    } catch (e) {
      HelperFunc.toast('Failed to update.');
    }
  }
}
