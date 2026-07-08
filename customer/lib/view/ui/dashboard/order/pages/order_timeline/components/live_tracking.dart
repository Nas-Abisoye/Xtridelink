import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/domain/model/api/order_det.dart';
import 'package:xtridelink/core/services/location/index.dart';
import 'package:xtridelink/core/services/socket/index.dart';
import 'package:xtridelink/view/components/back_button.dart';
import 'package:xtridelink/view/cubit/order/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import '../../../../../../../core/constants/helpers.dart';
import '../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../injector.dart';

class OrderTimelineLiveTracking extends StatefulWidget {
  final OrderDetails order;
  const OrderTimelineLiveTracking({super.key, required this.order});

  @override
  State<OrderTimelineLiveTracking> createState() =>
      _OrderTimelineLiveTrackingState();
}

class _OrderTimelineLiveTrackingState extends State<OrderTimelineLiveTracking> {
  late ValueNotifier<List<LatLng>> locationPoints;
  late ValueNotifier<LatLng> riderLocation;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    riderLocation = ValueNotifier(LatLng(
        num.tryParse(widget.order.riderDetails?.latitude ?? '')?.toDouble() ??
            widget.order.deliveryLatitude!,
        num.tryParse(widget.order.riderDetails?.longitude ?? '')?.toDouble() ??
            widget.order.deliveryLongitude!));
    locationPoints = ValueNotifier([]);
    setLocationPath(
        longitude: riderLocation.value.longitude,
        latitude: riderLocation.value.latitude);
    _riderLocationUpdate();
    super.initState();
  }

  void _riderLocationUpdate() async {
    final GoogleMapController mapController = await _controller.future;
    // getIt<SocketService>()
    //     .socket
    //     .on('riderLocation-${widget.order.rider?.userId}', (data) {
    //   HelperFunc.logger('riderLocation: ${jsonEncode(data)}');
    //   riderLocation.value = LatLng(
    //       num.tryParse(data['data']?['latitude'] ?? '')?.toDouble() ??
    //           widget.order.deliveryLocation.latitude,
    //       num.tryParse(data['data']?['longitude'] ?? '')?.toDouble() ??
    //           widget.order.deliveryLocation.longitude);
    //   setLocationPath(
    //       longitude: riderLocation.value.longitude,
    //       latitude: riderLocation.value.latitude);
    //   mapController.animateCamera(CameraUpdate.newCameraPosition(
    //       CameraPosition(target: riderLocation.value, zoom: 14)));
    // });
  }

  void setLocationPath(
      {required double longitude, required double latitude}) async {
    locationPoints.value = await getIt<LocationMapService>().getRoutePoints(
        origin: LatLng(latitude, longitude),
        destination: LatLng(widget.order.deliveryLatitude ?? 0,
            widget.order.deliveryLatitude ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
      return Container(
          width: double.infinity,
          height: state.liveTracking ? double.infinity : 300.h,
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: state.liveTracking
                ? null
                : Border.all(color: Colors.white, width: 8.r),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: ListenableBuilder(
                      listenable:
                          Listenable.merge([locationPoints, riderLocation]),
                      builder: (context, _) {
                        return GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: riderLocation.value, zoom: 14),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: state.liveTracking,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          markers: {
                            Marker(
                                markerId: const MarkerId('destination'),
                                position: LatLng(
                                    widget.order.deliveryLatitude ?? 0,
                                    widget.order.deliveryLongitude ?? 0)),
                            Marker(
                                markerId: const MarkerId('source'),
                                position: riderLocation.value)
                          },
                          polylines: {
                            Polyline(
                              width: 5,
                              polylineId: const PolylineId('track'),
                              color: AppColors.materialColor,
                              points: locationPoints.value,
                            )
                          },
                        );
                      }),
                ),
              ),
              if (!state.liveTracking)
                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  child: GestureDetector(
                    onTap: () =>
                        context.read<OrdersCubit>().setLiveTracking(true),
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 20.h),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50.r)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          SvgPicture.asset(Assets.track, color: Colors.white),
                          HelperFunc.sb(5.w),
                          Text('Live Tracking',
                              style: AppTextStyles.mediumText(
                                  fontSize: 13, color: Colors.white))
                        ])),
                  ),
                ),
              if (state.liveTracking)
                Positioned(
                  left: 0,
                  top: 40.h,
                  right: 0,
                  child: Row(
                    children: [
                      AppBackButton(
                        onTap: () =>
                            context.read<OrdersCubit>().setLiveTracking(false),
                      ).align(Alignment.topLeft).EXPANDED,
                      Text('Live tracking',
                          style: AppTextStyles.semiBold(fontSize: 18)),
                      const Expanded(child: SizedBox())
                    ],
                  ),
                ),
            ],
          ));
    });
  }
}
