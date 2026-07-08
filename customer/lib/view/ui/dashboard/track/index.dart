import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/view/components/icon_avatar.dart';
import 'package:xtridelink/view/cubit/order/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import '../../../../core/constants/helpers.dart';
import '../../../components/form_field.dart';
import '../order/pages/order_history/order_history_page.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  late TextEditingController trackController;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    trackController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    trackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ashBg,
      body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HelperFunc.sb(10.h),
              Text('Track', style: AppTextStyles.mediumText(fontSize: 23))
                  .pd(EdgeInsets.only(left: 20.w)),
              Row(children: [
                Form(
                        key: _formKey,
                        child: AppFormField(
                            validator: (v) => null,
                            // validator: (v) {
                            //   if (v?.isEmpty == true) {
                            //     return 'Enter tracking number';
                            //   }
                            //   return null;
                            // },
                            prefixWidget: Icon(Icons.search,
                                color: AppColors.grey.withOpacity(.5)),
                            hintText: 'Enter tracking number',
                            controller: trackController,
                            fillColor: Colors.white))
                    .EXPANDED,
                HelperFunc.sb(15.w),
                IconAvatar(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<OrdersCubit>()
                            .trackOrder(trackingId: trackController.text);
                      }
                    },
                    avatar: Assets.trackPackage,
                    circleColor: AppColors.secColor,
                    color: Colors.white,
                    radius: 23.r)
              ]).pd(EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h)),
              ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(40.r)),
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(40.r))),
                      child: SingleChildScrollView(
                        child: BlocBuilder<OrdersCubit, OrdersState>(
                            builder: (context, state) {
                          return state.trackingOrder.data?.id == null
                              ? Column(
                                  children: [
                                    HelperFunc.sb(100.h),
                                    Image.asset(Assets.empty, height: 120.h),
                                    HelperFunc.sb(10.h),
                                    Text('Track your orders',
                                        style: AppTextStyles.semiBold(
                                            color: AppColors.grey
                                                .withOpacity(.7))),
                                    HelperFunc.sb(5.h),
                                    Text(
                                        'Find the locations and status\nof your orders',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.regularText(
                                            color: AppColors.grey
                                                .withOpacity(.5))),
                                  ],
                                )
                              : OrderHistoryCard(
                                  shadows: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.05),
                                          spreadRadius: 1,
                                          blurRadius: 10,
                                          offset: const Offset(0, 0)),
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.05),
                                          spreadRadius: 1,
                                          blurRadius: 10,
                                          offset: const Offset(0, 0))
                                    ],
                                  order: state.trackingOrder.data!,
                                  isTracking: true);
                        }),
                      ))).EXPANDED
            ],
          )),
    );
  }
}
