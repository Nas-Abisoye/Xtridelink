import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/helpers/app_constants.dart';
import 'package:xtridelink/domain/model/api/riders.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/view/components/back_button.dart';
import 'package:xtridelink/view/components/button.dart';
import 'package:xtridelink/view/components/profile_avatar.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/awaiting_driver_accept.dart';
import '../../../../../core/constants/old_assets.dart';
import '../components/negotiate_price.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';

class SelectDriverPage extends StatefulWidget {
  const SelectDriverPage({super.key});

  @override
  State<SelectDriverPage> createState() => _SelectDriverPageState();
}

class _SelectDriverPageState extends State<SelectDriverPage> {
  late ValueNotifier<RiderData?> selectedDriver;
  @override
  void initState() {
    selectedDriver = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    selectedDriver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Row(children: [
                const AppBackButton(),
                const Spacer(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        3,
                        (index) => CircleAvatar(
                              radius: 4.r,
                              backgroundColor: index == 2
                                  ? AppColors.secColor
                                  : AppColors.grey.withOpacity(0.3),
                            ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
                HelperFunc.sb(15.w)
              ]),
              BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) => RefreshIndicator(
                        onRefresh: () async =>
                            context.read<OrdersCubit>().researchRiders(),
                        child: SingleChildScrollView(
                            padding: EdgeInsets.all(18.w),
                            child: Column(children: [
                              Text('${state.availableRiders.length} Rider${(state.availableRiders.length) < 2 ? '' : 's'} found',
                                      style: AppTextStyles.mediumText(
                                          fontSize: 20,
                                          color: AppColors.secColor))
                                  .align(Alignment.centerLeft),
                              HelperFunc.sb(10.h),
                              Text('Here are some available drivers we found',
                                      style: AppTextStyles.regularText(
                                          fontSize: 13, color: AppColors.grey))
                                  .pd(EdgeInsets.only(right: 50.w))
                                  .align(Alignment.centerLeft),
                              HelperFunc.sb(25.h),
                              if (state.negotiationStatus ==
                                  OrderNegotiationStatus.searchingRider)
                                Column(children: [
                                  HelperFunc.sb(70.h),
                                  const CupertinoActivityIndicator(),
                                  HelperFunc.sb(15.h),
                                  Text('Searching for riders around you',
                                      style: AppTextStyles.semiBold(
                                          color: AppColors.grey)),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height)
                                ]),
                              if (state.negotiationStatus ==
                                  OrderNegotiationStatus.noRiderFound)
                                Column(children: [
                                  HelperFunc.sb(70.h),
                                  SvgPicture.asset(Assets.car, height: 80.h),
                                  HelperFunc.sb(15.h),
                                  Text('No driver available',
                                      style: AppTextStyles.semiBold(
                                          color: AppColors.grey)),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height)
                                ]),
                              if (state.negotiationStatus ==
                                      OrderNegotiationStatus.ridersFound &&
                                  state.availableRiders.isNotEmpty)
                                ValueListenableBuilder(
                                    valueListenable: selectedDriver,
                                    builder: (context, value, _) {
                                      return Column(children: [
                                        ...List.generate(
                                            state.availableRiders.length,
                                            (i) => SelectDriverCard(
                                                    rider: state
                                                        .availableRiders[i],
                                                    onTap: () => selectedDriver
                                                            .value =
                                                        state
                                                            .availableRiders[i],
                                                    isSelected: value ==
                                                        state
                                                            .availableRiders[i])
                                                .pd(EdgeInsets.only(
                                                    bottom: 8.h))),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height)
                                      ]);
                                    }),
                              HelperFunc.sb(70.h),
                            ])),
                      )).EXPANDED,
              ValueListenableBuilder(
                  valueListenable: selectedDriver,
                  builder: (context, value, _) {
                    return value == null
                        ? const SizedBox()
                        : SafeArea(
                            child: Row(
                              children: [
                                HelperFunc.sb(25.w),
                                Expanded(
                                    child: AppButton(
                                        onTap: () {
                                          HelperFunc.showFittedBottomSheet(
                                              context: context,
                                              child: NegotiatePriceSheet(
                                                  rider: value));
                                        },
                                        color: Colors.black,
                                        btnText: 'Negotiate')),
                                HelperFunc.sb(10.w),
                                Expanded(
                                    child: AppButton(
                                        onTap: () => globalNavigateTo(
                                            route: Routes.awaitingDriverAccept,
                                            arguments: CreateOfferReqData(
                                                amount: double.parse(
                                                    value.proposedPrice ?? '0'),
                                                bidId: value.bidId!)),
                                        btnText: 'Accept')),
                                HelperFunc.sb(25.w)
                              ],
                            ),
                          );
                  }),
              HelperFunc.sb(15.h)
            ],
          )),
    );
  }
}

class SelectDriverCard extends StatelessWidget {
  final bool isSelected;
  final void Function()? onTap;
  final RiderData rider;
  const SelectDriverCard(
      {super.key, this.isSelected = false, required this.rider, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.secColor : AppColors.ashBg,
            borderRadius: BorderRadius.circular(50.r)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          ProfileAvatar(radius: 28, avatar: AppConstants.riderAvatar),
          HelperFunc.sb(8.w),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(rider.riderName ?? '',
                  style: AppTextStyles.mediumText(
                      fontSize: 14, color: isSelected ? Colors.white : null)),
              HelperFunc.sb(3.h),
              // Text(rider.vehicleName,
              //     style: AppTextStyles.mediumText(
              //         color: isSelected ? Colors.white : AppColors.secColor,
              //         fontSize: 10)),
              // HelperFunc.sb(3.h),
              // Text('Vehicle ID: ${rider.regNumber}',
              //     style: AppTextStyles.mediumText(
              //         color: isSelected
              //             ? Colors.white
              //             : AppColors.grey.withOpacity(.5),
              //         fontSize: 9)),
              HelperFunc.sb(2.h),
              Row(
                children: [
                  ...List.generate(
                      5,
                      (i) => Icon(Icons.star,
                              size: 10.h,
                              color: i <
                                      (rider.riderRating == 'New'
                                          ? 0
                                          : rider.riderRating == 'ONE'
                                              ? 1
                                              : rider.riderRating == 'TWO'
                                                  ? 2
                                                  : rider.riderRating == 'THREE'
                                                      ? 3
                                                      : rider.riderRating ==
                                                              'FOUR'
                                                          ? 4
                                                          : 5)
                                  ? AppColors.yellow
                                  : (isSelected
                                      ? AppColors.ashBg
                                      : AppColors.grey.withOpacity(.3)))
                          .pd(EdgeInsets.only(right: .2.w))),
                  HelperFunc.sb(5.w),
                  Text(
                      rider.riderRating == 'New'
                          ? 'N/A'
                          : rider.riderRating == 'ONE'
                              ? '1.0'
                              : rider.riderRating == 'TWO'
                                  ? '2.0'
                                  : rider.riderRating == 'THREE'
                                      ? '3.0'
                                      : rider.riderRating == 'FOUR'
                                          ? '4.0'
                                          : '5.0',
                      style: AppTextStyles.mediumText(
                          color: isSelected ? Colors.white : AppColors.grey,
                          fontSize: 10)),
                ],
              )
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(double.parse(rider.proposedPrice!).formatCurrency,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color:
                        isSelected ? Colors.white : AppColors.materialColor)),
            HelperFunc.sb(5.h),
            // Text(
            //     '${rider.timeAway.ceil()} min${rider.timeAway.ceil() <= 1 ? '' : 's'} away',
            //     style: AppTextStyles.mediumText(
            //         color: isSelected ? Colors.white : null, fontSize: 9.5))
          ]),
          HelperFunc.sb(10.w)
        ]),
      ),
    );
  }
}
