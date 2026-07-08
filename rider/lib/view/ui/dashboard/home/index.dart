import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/domain/model/api/customer_price_proposal.dart';
import 'package:xtridelink_driver/domain/model/api/ongoing_orders.dart';
import 'package:xtridelink_driver/view/cubit/order/index.dart';
import 'package:xtridelink_driver/view/cubit/settings/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/home/components/complete_kyc.dart';
import 'package:xtridelink_driver/view/ui/dashboard/index.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../domain/model/api/offers.dart';
import '../../../cubit/profile/index.dart';
import 'components/order_card_button.dart';
import '../../../../core/constants/enumerations.dart';
import '../../../components/button.dart';
import 'components/order_card.dart';
import 'components/home_header.dart';
import 'components/send_now_options.dart';
import 'components/track_package.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    loadOrders();
    super.initState();
  }

  void loadOrders() async {
    await context.read<OrderFlowCubit>().getAllOffers();

    if (mounted) await context.read<OrderFlowCubit>().getOngoingOrders();
    if (mounted) await context.read<OrderFlowCubit>().getHistory();
    if (mounted) {
      final user = context.read<ProfileCubit>().state.user;
      if ((user?.isAvailable ?? false)) {
        context.read<OrderFlowCubit>().listenForNewOrders();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderFlowCubit, OrderFlowState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.ashBg,
          body: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Column(
                    children: [
                      HelperFunc.sb(10.h),
                      BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) {
                        return HomePageHeader(
                            avatar: state.user?.profileImg,
                            currentLocation: state.user?.location ??
                                context
                                    .watch<SettingsCubit>()
                                    .state
                                    .recentLocations
                                    .firstOrNull
                                    ?.address);
                      }),
                      const HomeCompleteKyc(),
                      BlocBuilder<OrderFlowCubit, OrderFlowState>(
                          builder: (context, state) {
                        final isPending =
                            state.orderTab == RiderOrderTab.pending;
                        return RefreshIndicator(
                          onRefresh: () => isPending
                              ? context.read<OrderFlowCubit>().getAllOffers()
                              : context
                                  .read<OrderFlowCubit>()
                                  .getOngoingOrders(),
                          child: Column(children: [
                            HelperFunc.sb(20.h),
                            const HomeRideOverview(),
                            HelperFunc.sb(10.h),
                            const HomeOrderTabs(),
                            isPending
                                ? PendingOffersList(
                                    offers: state.allOffers?.toList() ?? [])
                                : OngoingOrdersList(
                                    ongoingOrders:
                                        state.ongoingOrders?.toList() ?? []),
                            HelperFunc.sb(150.h),
                          ]).SINGLECHILDSCROLLVIEW,
                        ).EXPANDED;
                      }),
                    ],
                  ),
                  if (state.bidRequest?.orderId != null) ...[
                    ModalBarrier(
                      color: Colors.black26,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: BidRequestView(
                        bidRequest: state.bidRequest!,
                        onSubmit: (amount) {
                          // Handle submission
                          if (amount <= 0) {
                            HelperFunc.toast(
                                'Bid amount must be greater than zero');
                            return;
                          }

                          context.read<OrderFlowCubit>().submitBid(
                              orderId: state.bidRequest!.orderId!,
                              amount: amount);
                        },
                        onClose: () {
                          context.read<OrderFlowCubit>().clearBidRequest();
                        },
                      ),
                    ),
                  ],
                  // ...existing code...
                  if (state.customerPriceProposal?.orderId != null)
                    PriceProposalView(
                      proposal: state.customerPriceProposal!,
                      onAccept: () {
                        print('Accept');
                        context.read<OrderFlowCubit>().acceptDeclineOffer(
                            isAccepted: true,
                            offerId:
                                state.customerPriceProposal!.negotiationId!);
                      },
                      onReject: () {
                        context.read<OrderFlowCubit>().acceptDeclineOffer(
                            isAccepted: false,
                            offerId:
                                state.customerPriceProposal!.negotiationId!);
                      },
                      onClose: () {
                        context.read<OrderFlowCubit>().clearBidRequest();
                      },
                    ),
// ...existing code...
                ],
              )),
        );
      },
    );
  }
}

class PendingOffersList extends StatelessWidget {
  final List<OfferData> offers;
  const PendingOffersList({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (offers.isEmpty)
        const EmptyOrdersScreen(
            title: 'No new orders',
            subTitle: 'You currently don’t have any order.'),
      ...List.generate(offers.length, (idx) {
        return TrackOrderCard(
            orderId: offers[idx].orderId,
            customerId: offers[idx].senderId,
            riderId: offers[idx].receiverId,
            title: '',
            id: offers[idx].id,
            receiverImg: '',
            receiverName: '',
            receiverPhone: '',
            paymentMethod: '',
            amount: offers[idx].amount.formatCurrency,
            pickupLocation: '',
            deliveryLocation: '',
            recipientName: '',
            recipientPhone: '',
            packageType: '',
            deliveryType: '',
            comment: '',
            hasTwoFA: false,
            createdAt: offers[idx].createdAt,
            orderLevel: 0,
            isPending: true,
            buttons: Row(children: [
              AppButton(
                      onTap: () => context
                          .read<OrderFlowCubit>()
                          .acceptDeclineOffer(
                              isAccepted: false,
                              userId: offers[idx].senderId,
                              orderId: offers[idx].orderId,
                              offerId: offers[idx].id),
                      textFont: 12,
                      color: Colors.black,
                      btnText: 'Reject')
                  .EXPANDED,
              HelperFunc.sb(12.h),
              AppButton(
                      onTap: () => context
                          .read<OrderFlowCubit>()
                          .acceptDeclineOffer(
                              isAccepted: true,
                              orderId: offers[idx].orderId,
                              userId: offers[idx].senderId,
                              offerId: offers[idx].id),
                      textFont: 12,
                      btnText: 'Accept Order')
                  .EXPANDED
            ]));
      }),
      if (offers.length < 2)
        SizedBox(height: MediaQuery.of(context).size.height * .6)
    ]);
  }
}

class OngoingOrdersList extends StatelessWidget {
  final List<OrderDetails> ongoingOrders;
  const OngoingOrdersList({super.key, required this.ongoingOrders});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (ongoingOrders.isEmpty)
        const EmptyOrdersScreen(
            title: 'No ongoing orders',
            subTitle: 'You currently don’t have any ongoing order'),
      ...List.generate(
          ongoingOrders.length,
          (idx) => TrackOrderCard(
              orderId: ongoingOrders[idx].id!,
              customerId: ongoingOrders[idx].customerDetails!.id!,
              riderId: ongoingOrders[idx].riderDetails!.id!,
              title: ongoingOrders[idx].customerDetails?.name ?? '',
              id: ongoingOrders[idx].trackingId!,
              receiverImg: '',
              receiverName: '${ongoingOrders[idx].customerDetails!.name} ',
              receiverPhone:
                  ongoingOrders[idx].customerDetails?.phoneNumber ?? '',
              amount:
                  ongoingOrders[idx].finalPrice?.toDouble().formatCurrency ??
                      '0',
              paymentMethod: ongoingOrders[idx].paymentMethod ?? 'Transfer',
              pickupLocation: ongoingOrders[idx].pickupAddress ?? '',
              deliveryLocation: ongoingOrders[idx].deliveryAddress ?? '',
              recipientName: ongoingOrders[idx].recipientName ?? '',
              recipientPhone: ongoingOrders[idx].recipientPhone ?? '',
              packageType: ongoingOrders[idx].packageType!,
              deliveryType: ongoingOrders[idx].deliveryType!,
              comment: ongoingOrders[idx].deliveryNotes ?? '',
              hasTwoFA: ongoingOrders[idx].enable2fa ?? false,
              createdAt:
                  ongoingOrders[idx].createdAt?.toDateTime() ?? DateTime.now(),
              orderLevel:
                  ongoingOrders[idx].status?.toUpperCase() == 'DELIVERED'
                      ? 3
                      : ongoingOrders[idx].status?.toUpperCase() == 'IN_TRANSIT'
                          ? 2
                          : ongoingOrders[idx].status?.toUpperCase() ==
                                  'PICKUP_READY'
                              ? 1
                              : 0,
              isPending: ongoingOrders[idx].status == 'payment_pending',
              buttons: OrderCardButtons(
                  orderDetails: ongoingOrders[idx], index: idx))),
      if (ongoingOrders.length < 2)
        SizedBox(height: MediaQuery.of(context).size.height * .6)
    ]);
  }
}

class EmptyOrdersScreen extends StatelessWidget {
  final String title, subTitle;
  const EmptyOrdersScreen(
      {super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 15.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.01),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 0)),
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 0))
          ],
          borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        children: [
          SvgPicture.asset(Assets.car, height: 70.h),
          HelperFunc.sb(10.h),
          Text(title,
              style: AppTextStyles.semiBold(
                  fontSize: 14, color: AppColors.grey.withOpacity(.7))),
          HelperFunc.sb(5.h),
          Text(subTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.regularText(
                  fontSize: 10, color: AppColors.grey.withOpacity(.5))),
        ],
      ),
    );
  }
}

class PriceProposalView extends StatelessWidget {
  final CustomerPriceProposal proposal;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onClose;

  const PriceProposalView({
    super.key,
    required this.proposal,
    required this.onAccept,
    required this.onReject,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: onClose,
                ),
              ),
              Text(
                'Price Proposal',
                style: AppTextStyles.semiBold(fontSize: 18),
              ),
              HelperFunc.sb(10.h),
              if (proposal.customerName != null)
                Text(
                  'From: ${proposal.customerName}',
                  style: AppTextStyles.regularText(fontSize: 14),
                ),
              HelperFunc.sb(8.h),
              if (proposal.riderLastBid != null)
                Text(
                  'Your Bid Price: ₦${proposal.riderLastBid ?? '-'}',
                  style: AppTextStyles.semiBold(
                      fontSize: 16, color: AppColors.green),
                ),
              HelperFunc.sb(8.h),
              if (proposal.proposedPrice != null)
                Text(
                  'Customer Bid Price: ₦${proposal.proposedPrice ?? '-'}',
                  style: AppTextStyles.semiBold(
                      fontSize: 16, color: AppColors.materialColor),
                ),
              HelperFunc.sb(8.h),
              if (proposal.message != null && proposal.message!.isNotEmpty)
                Text(
                  '"${proposal.message}"',
                  style: AppTextStyles.regularText(
                      fontSize: 13, color: AppColors.grey),
                  textAlign: TextAlign.center,
                ),
              HelperFunc.sb(20.h),
              Row(
                children: [
                  AppButton(
                    onTap: onReject,
                    btnText: 'Reject',
                    color: Colors.black,
                  ).EXPANDED,
                  HelperFunc.sb(12.w),
                  AppButton(
                    onTap: onAccept,
                    btnText: 'Accept',
                  ).EXPANDED,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ...existing code...
