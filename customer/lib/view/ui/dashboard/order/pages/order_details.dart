import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/debouncer.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/domain/model/api/location_prediction.dart';
import 'package:xtridelink/domain/params/order/order_params.dart';
import 'package:xtridelink/view/components/back_button.dart';
import 'package:xtridelink/view/components/button.dart';
import 'package:xtridelink/view/cubit/order/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/components/choose_otp_type.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import 'package:xtridelink/view/ui/dashboard/profile/cubit/profile_cubit.dart';
import '../../../../../domain/model/api/order_det.dart';
import '../../../../../core/services/location/index.dart';
import '../../../../../core/services/navigation/index.dart';
import '../../../../../../../injector.dart';
import '../../../../components/search_overlay.dart';
import '../../../../cubit/profile/index.dart';
import '../components/cancel_order.dart';
import '../components/choose_package_type.dart';
import '../components/choose_vehicle_type.dart';
import '../components/choose_delivery_type.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';

class PackageOrderParam {
  final PackageType? packageType;
  final OrderType orderType;
  final GeneralPackageTypes? generalPackageType;
  final OrderDetails? orderDet;
  const PackageOrderParam(
      {required this.packageType,
      required this.orderType,
      required this.generalPackageType,
      required this.orderDet});
}

class OrderDetailsForm {
  GeneralPackageTypes? generalPackageType;
  LocationData? pickupLocation, deliveryLocation;
  bool? isNormalDelivery;
  // bool enable2FA;
  // String? alertMethod;

  PackageType? packageType;
  VehicleType? vehicleType;
  OrderDetailsForm(
      {this.generalPackageType,
      this.pickupLocation,
      this.deliveryLocation,
      this.isNormalDelivery = true,
      this.packageType,
      // this.alertMethod,
      // this.enable2FA = false,
      this.vehicleType = VehicleType.motorcycle});

  bool get isValid =>
      // enable2FA &&
      pickupLocation != null &&
      deliveryLocation != null &&
      isNormalDelivery != null &&
      packageType != null &&
      // alertMethod != null &&
      (packageType == PackageType.general
          ? generalPackageType != null
          : true) &&
      vehicleType != null;

  OrderDetailsForm copyWith(
          {GeneralPackageTypes? generalPackageType,
          LocationData? pickupLocation,
          LocationData? deliveryLocation,
          bool? isNormalDelivery,
          // bool? enable2FA,
          String? alertMethod,
          PackageType? packageType,
          VehicleType? vehicleType}) =>
      OrderDetailsForm(
          // enable2FA: enable2FA ?? this.enable2FA,
          generalPackageType: generalPackageType ?? this.generalPackageType,
          pickupLocation: pickupLocation ?? this.pickupLocation,
          deliveryLocation: deliveryLocation ?? this.deliveryLocation,
          isNormalDelivery: isNormalDelivery ?? this.isNormalDelivery,
          // alertMethod: alertMethod ?? this.alertMethod,
          packageType: packageType ?? this.packageType,
          vehicleType: vehicleType ?? this.vehicleType);
}

class ProvideOrderDetPage extends StatefulWidget {
  final PackageOrderParam orderRouteInfo;
  const ProvideOrderDetPage({super.key, required this.orderRouteInfo});

  @override
  State<ProvideOrderDetPage> createState() => _ProvideOrderDetPageState();
}

class _ProvideOrderDetPageState extends State<ProvideOrderDetPage> {
  late ValueNotifier<OrderDetailsForm> isFormValid;
  late TextEditingController pickupController;
  late TextEditingController deliveryController;
  final _debouncer = Debouncer(interval: const Duration(milliseconds: 200));
  final _debouncer2 = Debouncer(interval: const Duration(milliseconds: 200));
  final _debouncer3 = Debouncer();
  @override
  void initState() {
    isFormValid = ValueNotifier(OrderDetailsForm(
        // enable2FA: false,
        pickupLocation: widget.orderRouteInfo.orderDet == null
            ? null
            : LocationData(
                placeId: '',
                address: widget.orderRouteInfo.orderDet!.pickupAddress!,
                latitude: widget.orderRouteInfo.orderDet!.pickupLatitude!,
                longitude: widget.orderRouteInfo.orderDet!.pickupLongitude!),
        deliveryLocation: widget.orderRouteInfo.orderDet == null
            ? null
            : LocationData(
                placeId: '',
                address: widget.orderRouteInfo.orderDet!.deliveryAddress!,
                latitude: widget.orderRouteInfo.orderDet!.deliveryLatitude!,
                longitude: widget.orderRouteInfo.orderDet!.deliveryLongitude!),
        isNormalDelivery:
            widget.orderRouteInfo.orderDet?.deliveryType == 'NORMAL',
        // alertMethod: widget.orderRouteInfo.orderDet?.alertMethod,
        vehicleType: switch (widget.orderRouteInfo.orderDet?.vehicleType) {
          'CAR' => VehicleType.car,
          'BIKE' => VehicleType.bicycle,
          'MOTORCYCLE' => VehicleType.motorcycle,
          'TRUCK' => VehicleType.truck,
          _ => null,
        },
        packageType: widget.orderRouteInfo.packageType,
        generalPackageType: widget.orderRouteInfo.generalPackageType));
    pickupController = TextEditingController(
        text: widget.orderRouteInfo.orderDet?.pickupAddress);
    deliveryController = TextEditingController(
        text: widget.orderRouteInfo.orderDet?.deliveryAddress);
    super.initState();
  }

  @override
  void dispose() {
    pickupController.dispose();
    deliveryController.dispose();
    isFormValid.dispose();
    _debouncer.reset();
    _debouncer3.reset();
    _debouncer2.reset();
    super.dispose();
  }

  @override
  void deactivate() {
    context.read<OrdersCubit>().clearCreateOrderData();
    super.deactivate();
  }

  void _showCancelSheet() => HelperFunc.showFittedBottomSheet(
      context: context,
      child: ValueListenableBuilder(
          valueListenable: isFormValid,
          builder: (context, value, _) {
            return const CancelOrderSheet(
                // onContinue: value.isValid
                //     ? () => context.read<OrdersCubit>().createUpdateOrder(
                //         title: titleController.text,
                //         orderStatus: OrderState.pending,
                //         orderType: widget.orderRouteInfo.$2,
                //         pickupLocation: value.pickupLocation!,
                //         deliveryLocation: value.deliveryLocation!,
                //         has2faCode: value.enable2FA,
                //         deliveryType:
                //             value.isNormalDelivery == true ? 'NORMAL' : 'EXPRESS',
                //         packageType: value.packageType == PackageType.general
                //             ? (value.generalPackageType?.api ?? '')
                //             : value.packageType!.name.toUpperCase(),
                //         vehicleType: value.vehicleType!)
                //     : () {
                //         if (value.pickupLocation == null) {
                //           HelperFunc.toast(
                //               'Please select a pickup location from the searched options');
                //           return;
                //         }
                //         if (value.deliveryLocation == null) {
                //           HelperFunc.toast(
                //               'Please select a delivery location from the searched options');
                //           return;
                //         }
                //       },
                );
          }));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final orderDet = context.read<OrdersCubit>().state.orderParams;
        if (orderDet.pickupAddress == null) return true;
        _showCancelSheet();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.ashBg,
        body: SafeArea(
            child: Column(
          children: [
            Row(children: [
              AppBackButton(onTap: () {
                final orderDet = context.read<OrdersCubit>().state.orderParams;
                if (orderDet.pickupAddress == null) {
                  globalPop();
                  return;
                }
                _showCancelSheet();
              }),
              const Spacer(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      3,
                      (index) => CircleAvatar(
                            radius: 4.r,
                            backgroundColor: index == 0
                                ? AppColors.secColor
                                : AppColors.grey.withOpacity(0.3),
                          ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
              HelperFunc.sb(15.w)
            ]),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Provide your order details',
                            style: AppTextStyles.mediumText(fontSize: 20)),
                        HelperFunc.sb(10.h),
                        Text('Enter the details of your order below',
                                style: AppTextStyles.regularText(
                                    fontSize: 13, color: AppColors.grey))
                            .pd(EdgeInsets.only(right: 50.w)),
                        HelperFunc.sb(15.h),
                        Text('Enter Address',
                            style: AppTextStyles.mediumText(fontSize: 12)),
                        HelperFunc.sb(5.h),
                        BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, state) {
                          return SearchField(
                              hintText: 'Pickup Location',
                              controller: pickupController,
                              inputType: TextInputType.text,
                              suffixIcon: Assets.locationSvg,
                              onMapLocationPicked: (v) => isFormValid.value =
                                  isFormValid.value.copyWith(pickupLocation: v),
                              onChanged: (v) => _debouncer(() {
                                    context
                                        .read<ProfileCubit>()
                                        .searchAddress(v);
                                    isFormValid.value = OrderDetailsForm(
                                        // enable2FA: isFormValid.value.enable2FA,
                                        generalPackageType: isFormValid
                                            .value.generalPackageType,
                                        pickupLocation: null,
                                        deliveryLocation:
                                            isFormValid.value.deliveryLocation,
                                        isNormalDelivery:
                                            isFormValid.value.isNormalDelivery,
                                        packageType:
                                            isFormValid.value.packageType,
                                        vehicleType:
                                            isFormValid.value.vehicleType);
                                  }),
                              suggestions: state.addressPredictions.data!
                                  .map((e) => SearchFieldListItem(e.description,
                                      searchKey: e.placeId,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(Assets.locationSvg2),
                                          HelperFunc.sb(10.w),
                                          Text(e.description).EXPANDED,
                                        ],
                                      ).pd(EdgeInsets.symmetric(
                                          horizontal: 20.w))))
                                  .toList(),
                              onSuggestionTap: (e) async {
                                HelperFunc.showLoader();
                                LocationData? location =
                                    await getIt<LocationMapService>()
                                        .getLocationDetails(e.searchKey);
                                globalPop();
                                isFormValid.value = isFormValid.value.copyWith(
                                    pickupLocation: location?.copyWith(
                                        address: e.searchText));
                              },
                              itemHeight: 50.h);
                        }),
                        HelperFunc.sb(3.h),
                        ...List.generate(
                            4,
                            (index) => SizedBox(
                                    height: 4.h,
                                    child: VerticalDivider(
                                        thickness: 2,
                                        color: AppColors.grey.withOpacity(.4)))
                                .pd(EdgeInsets.fromLTRB(
                                    12.w, 2.5.h, 0, 2.5.h))),
                        HelperFunc.sb(3.h),
                        BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, state) {
                          return SearchField(
                              hintText: 'Delivery Location',
                              controller: deliveryController,
                              inputType: TextInputType.text,
                              suffixIcon: Assets.locationSvg,
                              onMapLocationPicked: (v) => isFormValid.value =
                                  isFormValid.value
                                      .copyWith(deliveryLocation: v),
                              onChanged: (v) => _debouncer2(() {
                                    context
                                        .read<ProfileCubit>()
                                        .searchAddress(v);
                                    isFormValid.value = OrderDetailsForm(
                                        // enable2FA: isFormValid.value.enable2FA,
                                        generalPackageType: isFormValid
                                            .value.generalPackageType,
                                        pickupLocation:
                                            isFormValid.value.pickupLocation,
                                        deliveryLocation: null,
                                        isNormalDelivery:
                                            isFormValid.value.isNormalDelivery,
                                        packageType:
                                            isFormValid.value.packageType,
                                        vehicleType:
                                            isFormValid.value.vehicleType);
                                  }),
                              suggestions: state.addressPredictions.data!
                                  .map((e) => SearchFieldListItem(e.description,
                                      searchKey: e.placeId,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(Assets.locationSvg2),
                                          HelperFunc.sb(10.w),
                                          Text(e.description).EXPANDED,
                                        ],
                                      ).pd(EdgeInsets.symmetric(
                                          horizontal: 20.w))))
                                  .toList(),
                              onSuggestionTap: (e) async {
                                HelperFunc.showLoader();
                                LocationData? location =
                                    await getIt<LocationMapService>()
                                        .getLocationDetails(e.searchKey);
                                globalPop();
                                isFormValid.value = isFormValid.value.copyWith(
                                    deliveryLocation: location?.copyWith(
                                        address: e.searchText));
                              },
                              itemHeight: 50.h);
                        }),
                      ]).pd(EdgeInsets.all(20.w)),
                  HelperFunc.sb(5.h),
                  ChooseDeliveryType(isFormValid: isFormValid),
                  HelperFunc.sb(25.h),
                  ChoosePackageType(isFormValid: isFormValid),
                  HelperFunc.sb(25.h),
                  ChooseVehicleType(isFormValid: isFormValid),
                  // HelperFunc.sb(25.h),
                  // ChooseOtpType(isFormValid: isFormValid),
                  HelperFunc.sb(100.h),
                ]))),
            ValueListenableBuilder(
                valueListenable: isFormValid,
                builder: (context, value, _) {
                  return AppButton(
                          btnText: 'Continue',
                          onTap: value.isValid
                              ? () => context
                                  .read<OrdersCubit>()
                                  .setOrderDetails(
                                    title: value.packageType ==
                                            PackageType.general
                                        ? (value.generalPackageType?.txt ?? '')
                                        : value.packageType!.name
                                            .capitalizeFirstLetter,
                                    orderStatus: OrderState.pending,
                                    orderType: widget.orderRouteInfo.orderType,
                                    pickupLocation: value.pickupLocation!,
                                    deliveryLocation: value.deliveryLocation!,
                                    // has2faCode: value.enable2FA,
                                    // alertMethod: value.alertMethod!,
                                    deliveryType: value.isNormalDelivery == true
                                        ? DeliveryType.normal
                                        : DeliveryType.express,
                                    packageType: value.packageType!,
                                    vehicleType: value.vehicleType!,
                                  )
                              : () {
                                  if (value.pickupLocation == null) {
                                    HelperFunc.toast(
                                        'Please select a pickup location from the searched options');
                                    return;
                                  }
                                  if (value.deliveryLocation == null) {
                                    HelperFunc.toast(
                                        'Please select a delivery location from the searched options');
                                    return;
                                  }
                                },
                          color: value.isValid
                              ? null
                              : AppColors.grey.withOpacity(.5))
                      .pd(EdgeInsets.symmetric(horizontal: 15.w));
                }),
            HelperFunc.sb(15.h)
          ],
        )),
      ),
    );
  }
}
