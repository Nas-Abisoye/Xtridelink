import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/helpers/app_constants.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/view/components/profile_avatar.dart';
import 'package:xtridelink/view/cubit/order/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import '../../../../../core/constants/old_assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../domain/model/api/order_det.dart';
import '../../../../../core/services/navigation/index.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';

class OrderPackageDeliveredPage extends StatefulWidget {
  final OrderTrackData orderTrackData;
  const OrderPackageDeliveredPage({super.key, required this.orderTrackData});

  @override
  State<OrderPackageDeliveredPage> createState() =>
      _OrderPackageDeliveredPageState();
}

class _OrderPackageDeliveredPageState extends State<OrderPackageDeliveredPage> {
  late ValueNotifier<Rating> stars;
  @override
  void initState() {
    stars = ValueNotifier(Rating.zero);
    super.initState();
  }

  @override
  void dispose() {
    stars.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Align(alignment: Alignment.topLeft, child: AppBackButton()),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                SvgPicture.asset(Assets.success, height: 120.h),
                HelperFunc.sb(25.h),
                Text('Package delivered',
                    style: AppTextStyles.semiBold(fontSize: 25)),
                HelperFunc.sb(10.h),
                Text('Yay! Your package has been delivered to destination',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regularText(
                            fontSize: 14, color: AppColors.grey))
                    .pd(EdgeInsets.symmetric(horizontal: 35.w)),
                HelperFunc.sb(30.h),
                Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
                    margin: EdgeInsets.symmetric(horizontal: 30.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.ashBg),
                        borderRadius: BorderRadius.circular(16.r)),
                    child: Column(
                      children: [
                        Text('RATE YOUR DRIVER',
                            style: AppTextStyles.regularText(
                                    fontSize: 10, color: AppColors.secColor)
                                .copyWith(letterSpacing: 2.5)),
                        HelperFunc.sb(15.h),
                        BlocBuilder<OrdersCubit, OrdersState>(
                            builder: (context, state) {
                          final order = (state.orders.data ?? []).firstWhere(
                              (element) =>
                                  element.id == widget.orderTrackData.orderId,
                              orElse: () {
                            globalPop();
                            return OrderDetails();
                          });
                          if (order.id == null) {
                            return const SizedBox();
                          }
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ProfileAvatar(
                                  radius: 15.r,
                                  avatar: AppConstants.riderAvatar,
                                ),
                                HelperFunc.sb(10.w),
                                Text('${order.riderDetails?.name ?? ''} ',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.mediumText())
                              ]);
                        }),
                        HelperFunc.sb(15.w),
                        ValueListenableBuilder(
                            valueListenable: stars,
                            builder: (context, value, _) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    5,
                                    (i) => GestureDetector(
                                        onTap: () =>
                                            stars.value = Rating.values[i + 1],
                                        child: Icon(Icons.star,
                                            size: 30.h,
                                            color: (i + 1) <=
                                                    Rating.values.indexOf(value)
                                                ? AppColors.yellow
                                                : AppColors.grey
                                                    .withOpacity(.15)))),
                              );
                            })
                      ],
                    ))
              ]).pd(EdgeInsets.symmetric(horizontal: 20.w))),
          ValueListenableBuilder(
              valueListenable: stars,
              builder: (context, value, _) {
                return value == Rating.zero
                    ? const SizedBox()
                    : AppButton(
                            onTap: () => context.read<OrdersCubit>().rateRider(
                                riderId: widget.orderTrackData.riderId,
                                rating: value),
                            btnText: 'Rate Driver')
                        .pd(EdgeInsets.symmetric(horizontal: 20.w));
              }),
          HelperFunc.sb(10.h)
        ],
      )),
    );
  }
}
