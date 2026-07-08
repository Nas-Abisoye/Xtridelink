import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/strings.dart';
import 'package:xtridelink_driver/core/constants/text_styles.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/view/components/button.dart';
import 'package:xtridelink_driver/view/components/notification_icon.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import 'package:xtridelink_driver/view/cubit/wallet/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/wallet/components/settle_outstanding.dart';
import 'package:xtridelink_driver/view/ui/dashboard/wallet/components/withdraw_prompts.dart';
import '../../../../domain/model/api/transactions.dart';
import 'components/withdraw.dart';
import '../../../../core/constants/helpers.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    context.read<WalletCubit>().loadWalletDetails();
    super.initState();
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
                  Text('Wallet', style: AppTextStyles.mediumText(fontSize: 22)),
                  const Spacer(),
                  const NotificationIcon(),
                  HelperFunc.sb(20.w)
                ],
              ),
              HelperFunc.sb(10.h),
              const WalletCard(),
              BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, profileState) {
                return BlocBuilder<WalletCubit, WalletState>(
                    builder: (context, state) {
                  return profileState.riderAnalytics != null &&
                          profileState.riderAnalytics?.businessId == null &&
                          state.financialData != null
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 15.w),
                          margin: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColors.lightPri,
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: AppColors.materialColor,
                                  radius: 10.r,
                                  child: Text('i',
                                      style: AppTextStyles.boldText(
                                          fontSize: 10, color: Colors.white))),
                              HelperFunc.sb(10.w),
                              RichText(
                                  text: TextSpan(
                                text:
                                    'Cash remittance percentage to xtridelink_driver is ',
                                style: AppTextStyles.regularText(
                                    fontSize: 11, color: Colors.black),
                                children: [
                                  TextSpan(
                                      text:
                                          '${state.financialData?.merchantPayoutRate ?? 0}%',
                                      style: AppTextStyles.mediumText(
                                          fontSize: 11, color: Colors.black)),
                                  TextSpan(
                                      text: (state.financialData
                                                      ?.settlementDurationCash ??
                                                  0) ==
                                              0
                                          ? ''
                                          : '\nAll outstanding not settled within ',
                                      style: AppTextStyles.regularText(
                                          fontSize: 11, color: Colors.black)),
                                  TextSpan(
                                      text: (state.financialData
                                                      ?.settlementDurationCash ??
                                                  0) ==
                                              0
                                          ? ''
                                          : '${state.financialData?.settlementDurationCash ?? 0} day${(state.financialData?.settlementDurationCash ?? 0) > 1 ? 's' : ''}',
                                      style: AppTextStyles.mediumText(
                                          fontSize: 11, color: Colors.black)),
                                  TextSpan(
                                      text: (state.financialData
                                                      ?.settlementDurationCash ??
                                                  0) ==
                                              0
                                          ? ''
                                          : ' will automatically be taken from your next online payment.',
                                      style: AppTextStyles.regularText(
                                          fontSize: 11, color: Colors.black)),
                                ],
                              )).EXPANDED
                            ],
                          ))
                      : HelperFunc.sb(20.h);
                });
              }),
              ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.r)),
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(40.r))),
                      child: RefreshIndicator(
                        onRefresh: () async =>
                            context.read<WalletCubit>().loadWalletDetails(),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(children: [
                            HelperFunc.sb(30.h),
                            Row(
                              children: [
                                HelperFunc.sb(20.w),
                                Text('Transactions',
                                    style:
                                        AppTextStyles.mediumText(fontSize: 16)),
                                const Spacer(),
                                CircleAvatar(
                                    backgroundColor: AppColors.lightSec,
                                    radius: 17.r,
                                    child: const Icon(Icons.filter_list,
                                        color: AppColors.grey)),
                                HelperFunc.sb(20.w)
                              ],
                            ),
                            BlocBuilder<WalletCubit, WalletState>(
                                builder: (context, state) => (state
                                                .transactions?.transactions ??
                                            [])
                                        .isNotEmpty
                                    ? ListView.builder(
                                        itemCount: state
                                            .transactions!.transactions.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            TransactionCard(
                                                transaction: state.transactions!
                                                    .transactions[index]))
                                    : state.isLoading
                                        ? Center(
                                            child:
                                                const CircularProgressIndicator()
                                                    .pd(EdgeInsets.only(
                                                        top: 20.h)))
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              HelperFunc.sb(70.h),
                                              Image.asset(Assets.money,
                                                  height: 70.h),
                                              HelperFunc.sb(10.h),
                                              Text('No transactions',
                                                  style: AppTextStyles.semiBold(
                                                      color: AppColors.grey
                                                          .withOpacity(.7))),
                                              HelperFunc.sb(5.h),
                                              Text(
                                                  'No transaction has\nhappened yet',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      AppTextStyles.regularText(
                                                          color: AppColors.grey
                                                              .withOpacity(
                                                                  .5))),
                                              HelperFunc.sb(30.h)
                                            ],
                                          )),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .5),
                          ]),
                        ),
                      ))).EXPANDED
            ],
          )),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionData transaction;
  const TransactionCard({super.key, required this.transaction});

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
            backgroundColor: AppColors.green.withOpacity(.15),
            child: Image.asset(Assets.money, height: 27.h, width: 27.w)),
        HelperFunc.sb(10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.description ?? 'N/A',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
            HelperFunc.sb(5.h),
            Text(
                '${HelperFunc.dateFormat.format(transaction.createdAt!.toDateTime())} ${HelperFunc.timeFormat.format(transaction.createdAt!.toDateTime()).toLowerCase()} ',
                style: AppTextStyles.regularText(
                    color: AppColors.grey, fontSize: 8)),
          ],
        ).EXPANDED,
        HelperFunc.sb(15.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Amount',
                style: AppTextStyles.regularText(
                    color: AppColors.grey, fontSize: 8)),
            HelperFunc.sb(5.h),
            Text(transaction.amount!.toDouble().formatCurrency,
                style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secColor)),
          ],
        )
      ]),
    );
  }
}

class WalletCard extends StatelessWidget {
  const WalletCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
      return Container(
          height: profileState.riderAnalytics != null &&
                  profileState.riderAnalytics?.businessId == null
              ? 180.h
              : 110.h,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r)),
          child: Stack(fit: StackFit.expand, children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: SvgPicture.asset(Assets.cardBg, fit: BoxFit.cover)),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Total Amount Collected',
                                  style: AppTextStyles.regularText(
                                      color: Colors.white, fontSize: 10)),
                              HelperFunc.sb(2.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(GlobalStrings.naira,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 13,
                                              color: Colors.white))
                                      .pd(EdgeInsets.only(
                                          top: 8.h, right: 2.w)),
                                  BlocBuilder<WalletCubit, WalletState>(
                                      builder: (context, state) {
                                    return Text(
                                        (state.balance ?? 0).figureSeparator,
                                        style: AppTextStyles.semiBold(
                                            color: Colors.white, fontSize: 25));
                                  }),
                                ],
                              ),
                            ]).EXPANDED,
                        HelperFunc.sb(20.w),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Outstanding',
                                  style: AppTextStyles.regularText(
                                      color: Colors.white, fontSize: 10)),
                              HelperFunc.sb(2.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(GlobalStrings.naira,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 13,
                                              color: Colors.white))
                                      .pd(EdgeInsets.only(
                                          top: 8.h, right: 2.w)),
                                  BlocBuilder<WalletCubit, WalletState>(
                                      builder: (context, state) {
                                    return Text(
                                        (state.offlineOutStanding ?? 0)
                                            .figureSeparator,
                                        style: AppTextStyles.semiBold(
                                            color: Colors.white, fontSize: 25));
                                  }),
                                ],
                              ),
                            ]).EXPANDED,
                      ]).pd(EdgeInsets.symmetric(horizontal: 5.w)),
                  if (profileState.riderAnalytics != null &&
                      profileState.riderAnalytics?.businessId == null)
                    HelperFunc.sb(20.h),
                  if (profileState.riderAnalytics != null &&
                      profileState.riderAnalytics?.businessId == null)
                    Row(
                      children: [
                        AppButton(
                                onTap: () async {
                                  if (profileState.userBankAccounts == null) {
                                    HelperFunc.showLoader();
                                    profileState.userBankAccounts =
                                        await context
                                            .read<ProfileCubit>()
                                            .getUserBankAccounts();
                                    globalPop();
                                  }
                                  if (!context.mounted) return;
                                  if ((profileState.userBankAccounts ?? [])
                                      .isEmpty) {
                                    HelperFunc.showPopUpDialog(
                                        context: context,
                                        child: const AddBankToWithdraw());
                                  } else {
                                    HelperFunc.showFittedBottomSheet(
                                        context: context,
                                        child: const WithdrawSheet());
                                  }
                                },
                                btnText: 'Withdraw Funds',
                                textFont: 11.5,
                                color: Colors.white,
                                txtColor: Colors.black)
                            .EXPANDED,
                        HelperFunc.sb(7.w),
                        AppButton(
                          onTap: () => HelperFunc.showFittedBottomSheet(
                              context: context,
                              child: const SettleOutstandingSheet()),
                          btnText: 'Settle Outstanding',
                          textFont: 11.5,
                        ).EXPANDED,
                      ],
                    )
                ]).pd(EdgeInsets.symmetric(horizontal: 18.w))
          ]));
    });
  }
}
