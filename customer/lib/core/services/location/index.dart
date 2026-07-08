import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/domain/model/api/location_prediction.dart';
import 'package:xtridelink/injector.dart';
import '../../../view/components/button.dart';
import '../../constants/helpers.dart';
import '../../constants/strings.dart';
import 'package:geolocator/geolocator.dart';
import '../../constants/text_styles.dart';
import '../api/request_helper.dart';
import '../navigation/index.dart';

@Injectable()
class LocationMapService {
  final RequestHelpersImpl requestHelpersImpl;
  final NavigationServiceImpl navigationServiceImpl;
  LocationMapService(
      {required this.requestHelpersImpl, required this.navigationServiceImpl});

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

  Future<List<LatLng>> getRoutePoints(
      {required LatLng origin, required LatLng destination}) async {
    HelperFunc.logger(
        'origin: ${origin.latitude}, ${origin.longitude}, destination: ${destination.latitude}, ${destination.longitude}');
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.driving),
      googleApiKey: Platform.isAndroid
          ? GlobalStrings.androidAPIKey
          : GlobalStrings.iosAPIKey,
    );
    return result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }

  Future<Position> getPosition() async {
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
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    HelperFunc.logger(
        'Latitude: ${position.latitude}\nLongitude: ${position.longitude}');
    return position;
  }

  Future<String?> getLocationFromPosition(
      {required double longitude, required double latitude}) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      return '${placemarks[0].name ?? ''}, ${placemarks[0].locality ?? ''}, ${placemarks[0].administrativeArea ?? ''}, ${placemarks[0].country ?? ''}';
    } catch (e) {
      HelperFunc.logger(e.toString());
      HelperFunc.toast('Failed to get location');
      return null;
    }
  }

  void showMapLocationPicker({required void Function(LocationData) onPicked}) {
    HelperFunc.showFittedPopUp(
        // barrierDismissible: false,
        // showBackButton: false,
        context: navigationServiceImpl.navigationKey.currentContext!,
        child: GoogleMapsLocationPicker(onPicked: (v) async {
          HelperFunc.showLoader();
          String? address = await getLocationFromPosition(
              longitude: v.longitude, latitude: v.latitude);
          navigationServiceImpl.pop();
          if (address == null) return;
          onPicked(LocationData(
            address: address,
            latitude: v.latitude,
            longitude: v.longitude,
            placeId: '',
          ));
        }));
  }
}

class GoogleMapsLocationPicker extends StatefulWidget {
  final void Function(LatLng) onPicked;
  const GoogleMapsLocationPicker({super.key, required this.onPicked});

  @override
  State<GoogleMapsLocationPicker> createState() =>
      _GoogleMapsLocationPickerState();
}

class _GoogleMapsLocationPickerState extends State<GoogleMapsLocationPicker> {
  late ValueNotifier<LatLng?> location;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    location = ValueNotifier(null);
    super.initState();
    _goToCurrentLocation();
  }

  @override
  void dispose() {
    location.dispose();
    super.dispose();
  }

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await getIt<LocationMapService>().getPosition();
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLatLng, zoom: 14.0)));
    location.value = currentLatLng;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        HelperFunc.sb(24.w),
        Text('Pick Location', style: AppTextStyles.boldText(fontSize: 18)),
        HelperFunc.sb(10.w),
        Text('Please select a location on the map',
            style: AppTextStyles.regularText(color: AppColors.grey)),
        HelperFunc.sb(20.w),
        Expanded(
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * .5,
            child: Stack(
              children: [
                ValueListenableBuilder(
                    valueListenable: location,
                    builder: (context, value, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: GoogleMap(
                          initialCameraPosition:
                              const CameraPosition(target: LatLng(0, 0)),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          onCameraMove: (CameraPosition newPosition) =>
                              location.value = newPosition.target,
                          markers: {
                            if (value != null)
                              Marker(
                                  markerId: const MarkerId('location'),
                                  position: value)
                          },
                          gestureRecognizers: <Factory<
                              OneSequenceGestureRecognizer>>{
                            Factory<ScaleGestureRecognizer>(
                              () => ScaleGestureRecognizer(),
                            ),
                            Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer(),
                            ),
                            Factory<TapGestureRecognizer>(
                              () => TapGestureRecognizer(),
                            ),
                          },
                          zoomGesturesEnabled: true,
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
        HelperFunc.sb(10.w),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          HelperFunc.sb(10.w),
          TextButton(
              onPressed: () => globalPop(),
              child: Text('Cancel',
                  style: AppTextStyles.mediumText(color: Colors.black))),
          HelperFunc.sb(10.w),
          ValueListenableBuilder(
              valueListenable: location,
              builder: (context, value, _) {
                return AppButton(
                    isPadding: true,
                    radius: 8.r,
                    onTap: value == null
                        ? null
                        : () {
                            globalPop();
                            widget.onPicked(value);
                          },
                    btnText: 'Use Location',
                    textFont: 11.5,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                    color:
                        value != null ? null : AppColors.grey.withOpacity(.5));
              }),
          HelperFunc.sb(10.w),
        ]),
        HelperFunc.sb(10.w),
      ]),
    );
  }
}
