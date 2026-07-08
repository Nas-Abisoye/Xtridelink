import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/enumerations.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/text_styles.dart';
import 'package:xtridelink_driver/domain/model/api/ongoing_orders.dart';
import 'package:xtridelink_driver/view/components/notification_icon.dart';
import 'package:xtridelink_driver/view/components/tag.dart';
import 'package:xtridelink_driver/view/cubit/order/index.dart';
import '../../../../core/constants/debouncer.dart';
import '../../../../core/constants/helpers.dart';
import '../home/components/track_package.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late ValueNotifier<HistoryType?> historyState;
  late PageController pageController;
  final _debouncer = Debouncer();
  @override
  void initState() {
    historyState = ValueNotifier(null);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    historyState.dispose();
    pageController.dispose();
    _debouncer.reset();
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
              Row(
                children: [
                  HelperFunc.sb(20.w),
                  Text('History',
                      style: AppTextStyles.mediumText(fontSize: 22)),
                  const Spacer(),
                  const NotificationIcon(),
                  HelperFunc.sb(20.w)
                ],
              ),
              HelperFunc.sb(10.h),
              const HomeRideOverview(),
              HelperFunc.sb(5.h),
              ValueListenableBuilder(
                  valueListenable: historyState,
                  builder: (context, value, _) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Tag(
                                  onTap: () => historyState.value = null,
                                  txt: 'All',
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.h, horizontal: 10.w),
                                  color: value == null
                                      ? AppColors.secColor
                                      : Colors.transparent,
                                  txtFont: 12,
                                  txtColor: value == null
                                      ? Colors.white
                                      : AppColors.grey.withOpacity(.7))
                              .pd(EdgeInsets.symmetric(horizontal: 5.w)),
                          ...HistoryType.values.map((e) => Tag(
                                  onTap: () => historyState.value = e,
                                  txt: e.name.capitalizeFirstLetter,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.h, horizontal: 10.w),
                                  color: value == e
                                      ? AppColors.secColor
                                      : Colors.transparent,
                                  txtFont: 12,
                                  txtColor: value == e
                                      ? Colors.white
                                      : AppColors.grey.withOpacity(.7))
                              .pd(EdgeInsets.symmetric(horizontal: 5.w)))
                        ]);
                  }).pd(EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h)),
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40.r))),
                  child: PageView.builder(
                      controller: pageController,
                      padEnds: true,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) => historyState.value =
                          index == 0 ? null : HistoryType.values[index - 1],
                      itemCount: HistoryType.values.length + 1,
                      itemBuilder: (context, index) =>
                          HistoryListView(historyState: historyState))).EXPANDED
            ],
          )),
    );
  }
}

class HistoryListView extends StatelessWidget {
  final ValueNotifier<HistoryType?> historyState;
  const HistoryListView({super.key, required this.historyState});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: historyState,
        builder: (context, value, _) {
          return RefreshIndicator(
            onRefresh: () async => context.read<OrderFlowCubit>().getHistory(),
            child: BlocBuilder<OrderFlowCubit, OrderFlowState>(
                builder: (context, state) {
              List<OrderDetails>? historyOrders = value == null
                  ? state.orderHistory
                      ?.where((e) =>
                          e.status!.toLowerCase() == 'completed' ||
                          e.status!.toLowerCase() == 'canceled')
                      .toList()
                  : state.orderHistory
                      ?.where((e) =>
                          e.status!.toLowerCase() ==
                          (value.apiTxt).toLowerCase())
                      .toList();
              return (historyOrders ?? []).isEmpty && state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (historyOrders ?? []).isEmpty
                      ? SingleChildScrollView(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 9,
                            child: Column(
                              children: [
                                HelperFunc.sb(100.h),
                                SvgPicture.asset(Assets.car, height: 70.h),
                                HelperFunc.sb(10.h),
                                Text('No history',
                                    style: AppTextStyles.semiBold(
                                        fontSize: 14,
                                        color: AppColors.grey.withOpacity(.7))),
                                HelperFunc.sb(5.h),
                                Text(
                                    historyOrders == null
                                        ? 'Failed to load historyOrders'
                                        : 'You haven\'t made any order yet',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.regularText(
                                        fontSize: 10,
                                        color: AppColors.grey.withOpacity(.5))),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: historyOrders!.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * .55),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => OrderHistoryCard(
                              historyDet: historyOrders[index]));
            }),
          ).align(Alignment.topCenter);
        });
  }
}

class OrderHistoryCard extends StatelessWidget {
  final OrderDetails historyDet;
  const OrderHistoryCard({super.key, required this.historyDet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.01),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 0)),
            BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 0))
          ],
          borderRadius: BorderRadius.circular(20.r)),
      child: Row(children: [
        CircleAvatar(
            radius: 21.r,
            backgroundColor: PackageType.general.color,
            child: SvgPicture.asset(Assets.parcel)),
        HelperFunc.sb(10.w),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(historyDet.customerDetails?.name ?? 'N/A',
                      style: AppTextStyles.semiBold(fontSize: 14)),
                  HelperFunc.sb(5.h),
                  GestureDetector(
                    onTap: () => HelperFunc.copyToClipboard(
                        historyDet.trackingId!,
                        toastMsg: 'Copied Tracking ID'),
                    child: Text('Tracking ID: ${historyDet.trackingId}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.regularText(
                            color: AppColors.grey, fontSize: 10)),
                  ),
                ],
              ).EXPANDED,
              Text(
                  HelperFunc.dateFormat.format(DateTime.parse(
                      historyDet.updatedAt ?? historyDet.createdAt!)),
                  style: AppTextStyles.semiBold(fontSize: 8.5))
            ],
          ),
          HelperFunc.sb(10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment\nMethod',
                      style: AppTextStyles.regularText(
                          color: AppColors.grey, fontSize: 8)),
                  HelperFunc.sb(3.h),
                  Text(historyDet.paymentMethod!.capitalizeFirstLetter,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secColor)),
                ],
              ).EXPANDED,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount',
                      style: AppTextStyles.regularText(
                          color: AppColors.grey, fontSize: 8)),
                  HelperFunc.sb(3.h),
                  Text(
                      double.parse(historyDet.finalPrice ?? '0').formatCurrency,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secColor)),
                ],
              ).EXPANDED,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery Type',
                      style: AppTextStyles.regularText(
                          color: AppColors.grey, fontSize: 8)),
                  HelperFunc.sb(3.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                          historyDet.deliveryType!.toLowerCase() == 'normal'
                              ? Assets.order
                              : Assets.expressDelivery,
                          color: AppColors.secColor,
                          height: 11.5.h),
                      HelperFunc.sb(3.w),
                      Text(historyDet.deliveryType!.capitalizeFirstLetter,
                          style: AppTextStyles.semiBold(
                              fontSize: 10, color: AppColors.secColor)),
                    ],
                  ),
                ],
              ).EXPANDED,
              Tag(
                  txt: historyDet.status!.capitalizeFirstLetter,
                  txtColor: historyDet.status!.toLowerCase() == 'completed'
                      ? AppColors.green
                      : AppColors.red,
                  txtFont: 8.5,
                  padding:
                      EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w)),
            ],
          )
        ]).EXPANDED
      ]),
    );
  }
}
