import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/view/components/tag.dart';
// import 'package:xtridelink/view/cubit/order/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import '../../../../../../core/constants/debouncer.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../components/form_field.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late TextEditingController trackController;
  late PageController pageController;
  late ScrollController scrollController;
  final _debouncer = Debouncer();

  @override
  void initState() {
    trackController = TextEditingController();
    scrollController = ScrollController();
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    trackController.dispose();
    pageController.dispose();
    scrollController.dispose();
    _debouncer.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrdersCubit>();
    return Scaffold(
      backgroundColor: AppColors.ashBg,
      body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HelperFunc.sb(10.h),
              Text('History', style: AppTextStyles.mediumText(fontSize: 23))
                  .pd(EdgeInsets.only(left: 20.w)),
              HelperFunc.sb(20.h),
              Row(children: [
                HelperFunc.sb(20.h),
                Expanded(
                    child: AppFormField(
                        validator: (v) => null,
                        prefixWidget: Icon(Icons.search,
                            color: AppColors.grey.withOpacity(.5)),
                        hintText: 'Enter tracking number',
                        controller: trackController,
                        fillColor: Colors.white)),
                // HelperFunc.sb(15.w),
                // CircleAvatar(
                //     backgroundColor: AppColors.lightSec,
                //     radius: 17.r,
                //     child:
                //         const Icon(Icons.filter_list, color: AppColors.grey)),
                HelperFunc.sb(20.w)
              ]),
              BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 15.h),
                      child: Row(
                          children: ViewOrdersByStatus.values
                              .map((e) => Tag(
                                      onTap: () =>
                                          cubit.selectViewOrderState(e),
                                      txt: e.title,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.h, horizontal: 10.w),
                                      color: state.ordersByStatus == e
                                          ? AppColors.secColor
                                          : Colors.transparent,
                                      txtFont: 12,
                                      txtColor: state.ordersByStatus == e
                                          ? Colors.white
                                          : AppColors.grey.withOpacity(.7))
                                  .pd(EdgeInsets.symmetric(horizontal: 5.w)))
                              .toList()));
                },
              ).align(Alignment.center),
              Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(40.r))),
                      child: PageView.builder(
                          controller: pageController,
                          padEnds: true,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            cubit.selectViewOrderState(
                                ViewOrdersByStatus.values[index]);
                            if (index < 2) {
                              scrollController.animateTo(
                                  scrollController.position.minScrollExtent,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInCubic);
                            } else if (index > 2) {
                              scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInCubic);
                            }
                          },
                          itemCount: ViewOrdersByStatus.values.length,
                          itemBuilder: (context, index) => OrdersListView()))
                  .EXPANDED
            ],
          )),
    );
  }
}

class OrdersListView extends StatelessWidget {
  const OrdersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<OrdersCubit>().getOrders(),
      child: BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
        List<OrderDetails>? orders =
            (state.ordersByStatus == ViewOrdersByStatus.cancelled
                    ? (state.orders.data ?? [])
                        .where((e) => e.status?.toLowerCase() == 'canceled')
                    : state.ordersByStatus == ViewOrdersByStatus.delivered
                        ? (state.orders.data ?? []).where((e) =>
                            e.trackingId != null &&
                            e.status?.toLowerCase() == 'completed')
                        : state.ordersByStatus == ViewOrdersByStatus.onTransit
                            ? (state.orders.data ?? []).where((e) =>
                                (e.trackingId != null &&
                                    e.status?.toLowerCase() == 'in_transit'))
                            : (state.orders.data ?? []))
                .toList();
        return (orders).isEmpty && state.orders.isLoading
            ? const Center(child: CircularProgressIndicator())
            : (orders).isEmpty
                ? SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 9,
                      child: Column(
                        children: [
                          HelperFunc.sb(100.h),
                          Image.asset(Assets.empty, height: 70.h),
                          HelperFunc.sb(10.h),
                          Text('No order',
                              style: AppTextStyles.semiBold(
                                  fontSize: 14,
                                  color: AppColors.grey.withOpacity(.7))),
                          HelperFunc.sb(5.h),
                          Text('You haven\'t made any order yet',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.regularText(
                                  fontSize: 10,
                                  color: AppColors.grey.withOpacity(.5))),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: orders!.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 150.h),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => OrderHistoryCard(
                        isTracking: false, order: orders[index]));
      }),
    ).align(Alignment.topCenter);
  }
}

class OrderHistoryCard extends StatelessWidget {
  final OrderDetails order;
  final bool isTracking;
  final List<BoxShadow>? shadows;
  const OrderHistoryCard(
      {super.key, required this.order, this.shadows, required this.isTracking});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (order.status) {
          case 'searching_driver':
          case 'selecting_rider':
          case 'pending':
            globalNavigateTo(route: Routes.selectDriver);
            context.read<OrdersCubit>().resumePendingOrder(order);
            context.read<OrdersCubit>().researchRiders();
            break;
          case 'payment_pending':
            globalNavigateTo(
                route: Routes.timeline, arguments: order.trackingId);
            break;
          default:
            if (order.isPaymentCompleted ?? false) {
              globalNavigateTo(
                  route: Routes.timeline, arguments: order.trackingId);
            }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: shadows ??
                [
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
          HelperFunc.sb(8.w),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(order.id!.toOrderIdTag(),
                    style: AppTextStyles.semiBold(fontSize: 14)),
                HelperFunc.sb(5.h),
                InkWell(
                  onTap: () => (order.trackingId ?? '').isNotEmpty
                      ? HelperFunc.copyToClipboard(order.trackingId ?? '',
                          toastMsg: 'Copied Tracking ID')
                      : null,
                  child: Text(
                      'Tracking ID: ${(order.trackingId ?? '').isNotEmpty ? (order.trackingId ?? '') : 'N/A'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.regularText(
                          color: AppColors.grey, fontSize: 10)),
                ),
                HelperFunc.sb(5.h),
                Tag(
                    txt: order.status?.toUpperCase() == 'CANCELLED'
                        ? 'Cancelled'
                        : (order.status?.toUpperCase() == 'PAYMENT_PENDING' &&
                                order.trackingId != null)
                            ? 'Awaiting Payment'
                            : order.status?.toUpperCase() == 'COMPLETED' ||
                                    order.status?.toUpperCase() == 'DELIVERED'
                                ? 'Delivered'
                                : order.status?.toUpperCase() == 'IN_TRANSIT'
                                    ? 'On Transit'
                                    : order.status?.toUpperCase() ==
                                            'PICKUP_READY'
                                        ? 'Awaiting Pickup'
                                        : order.status?.toUpperCase() ==
                                                'PAYMENT_CONFIRMED'
                                            ? 'Ready'
                                            : 'Pending',
                    txtColor: order.status?.toUpperCase() == 'CANCELLED'
                        ? AppColors.red
                        : (order.status?.toUpperCase() == 'PAYMENT_PENDING' &&
                                order.trackingId != null)
                            ? AppColors.grey
                            : order.status?.toUpperCase() == 'COMPLETED' ||
                                    order.status?.toUpperCase() == 'DELIVERED'
                                ? AppColors.green
                                : order.status?.toUpperCase() == 'IN_TRANSIT'
                                    ? AppColors.secColor
                                    : order.status?.toUpperCase() ==
                                            'PICKUP_READY'
                                        ? AppColors.secColor
                                        : order.status?.toUpperCase() ==
                                                'PAYMENT_CONFIRMED'
                                            ? AppColors.materialColor
                                            : AppColors.dullYellow,
                    txtFont: 8.5,
                    padding:
                        EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w)),
              ])),
          // TextButton(
          //     onPressed: () => isTracking
          //         ? HelperFunc.showFittedBottomSheet(
          //             context: context,
          //             child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text('Order Timeline',
          //                       style: AppTextStyles.mediumText(fontSize: 18)),
          //                   HelperFunc.sb(15.h),
          //                   TrackSingleDetail(
          //                       time: order.trackingId?.packagePicking,
          //                       header: 'Awaiting Pickup',
          //                       subText:
          //                           'Your order has been accepted and driver is on the way to your location'),
          //                   TrackSingleDetail(
          //                       time: order.trackingId?.packagePickedup,
          //                       header: 'Package picked up',
          //                       subText: 'Driver has picked up your order'),
          //                   TrackSingleDetail(
          //                       time: order.trackingId?.packageOnTransit,
          //                       header: 'Order in transit',
          //                       subText:
          //                           'Your package is in enroute to the delivery location'),
          //                   SafeArea(
          //                       child: TrackSingleDetail(
          //                           time: order.trackingId?.packageDelivered,
          //                           showTrail: false,
          //                           header: 'Order delivered',
          //                           subText:
          //                               'Your package has been delivered to destination'))
          //                 ]).pd(
          //                 EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)))
          //         // PENDING ORDERS
          //         : (order.paymentMethod.isEmpty &&
          //                 order.trackingId != null)
          //             ? context.read<OrdersCubit>().confirmPayment(order)
          //             : (order.trackingId == null &&
          //                     order.status.toLowerCase() != 'cancelled' &&
          //                     order.status.toLowerCase() != 'canceled')
          //                 ? context
          //                     .read<OrdersCubit>()
          //                     .continueDraftCreation(order)
          //                 : globalNavigateTo(
          //                     route: Routes.timeline, arguments: order.id),
          //     child: Text(isTracking ? 'Track Package' : 'View Progress',
          //         style: AppTextStyles.mediumText(
          //             color: AppColors.secColor, fontSize: 10)))
        ]),
      ),
    );
  }
}
