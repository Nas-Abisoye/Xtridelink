import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/button.dart';
import '../../../../components/form_field.dart';
import '../../../../cubit/wallet/index.dart';

class SettleOutstandingSheet extends StatefulWidget {
  const SettleOutstandingSheet({super.key});

  @override
  State<SettleOutstandingSheet> createState() => _SettleOutstandingSheetState();
}

class _SettleOutstandingSheetState extends State<SettleOutstandingSheet> {
  late FocusNode focusNode;
  late TextEditingController amountController;

  @override
  void initState() {
    context.read<WalletCubit>().getOutStandingBalance();
    focusNode = FocusNode();
    amountController = TextEditingController();
    focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settle Outstanding',
              style: AppTextStyles.mediumText(fontSize: 18)),
          HelperFunc.sb(5.h),
          Text('Enter an amount to clear your outstanding',
                  style: AppTextStyles.regularText(
                      fontSize: 13, color: AppColors.grey))
              .pd(EdgeInsets.only(right: 50.w)),
          HelperFunc.sb(20.h),
          AppFormField(
              hintText: 'Enter Amount',
              labelText: 'Enter Amount',
              controller: amountController,
              focusNode: focusNode,
              keyBoardType: TextInputType.number,
              validator: (v) {
                if ((num.tryParse(v?.replaceAll(',', '') ?? '') ?? 0) >
                    (state.balance ?? 0)) {
                  return 'Insufficient balance';
                }
                if ((num.tryParse(v?.replaceAll(',', '') ?? '') ?? 0) >
                    (state.offlineOutStanding ?? 0)) {
                  return 'Amount is greater than outstanding amount';
                }
                return null;
              }),
          HelperFunc.sb(5.h),
          BlocBuilder<WalletCubit, WalletState>(builder: (context, state) {
            return Text(
                'Total Outstanding: ${(state.offlineOutStanding ?? 0).formatCurrency}',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp));
          }).pd(EdgeInsets.only(right: 50.w)),
          HelperFunc.sb(80.h),
          ValueListenableBuilder(
              valueListenable: amountController,
              builder: (context, value, _) {
                final isFormValid =
                    ((num.tryParse(value.text.replaceAll(',', '')) ?? 0) > 0) &&
                        ((num.tryParse(value.text.replaceAll(',', '')) ?? 0) <=
                            (state.offlineOutStanding ?? 0)) &&
                        ((num.tryParse(value.text.replaceAll(',', '')) ?? 0) <=
                            (state.balance ?? 0));
                return SafeArea(
                  top: false,
                  child: AppButton(
                      btnText: 'Continue',
                      onTap: isFormValid
                          ? () => HelperFunc.showFittedBottomSheet(
                              context: context,
                              child: SettleOutstandingConfirmSheet(
                                  amount: num.tryParse(amountController.text
                                          .replaceAll(',', '')) ??
                                      0))
                          : null,
                      color:
                          isFormValid ? null : AppColors.grey.withOpacity(.5)),
                );
              }),
          SizedBox(height: focusNode.hasFocus ? 200.h : 0)
        ],
      ).pd(EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h));
    });
  }
}

class SettleOutstandingConfirmSheet extends StatelessWidget {
  final num amount;
  const SettleOutstandingConfirmSheet({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
          backgroundColor: AppColors.lightPri,
          radius: 55.r,
          child: SvgPicture.asset(Assets.bell)),
      HelperFunc.sb(30.h),
      Text('Settle Outstanding',
          textAlign: TextAlign.center,
          style: AppTextStyles.semiBold(fontSize: 22)),
      HelperFunc.sb(8.h),
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'An amount of ',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w300),
              children: [
                TextSpan(
                    text: amount.formatCurrency,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: null,
                        fontSize: 14.sp,
                        color: AppColors.grey)),
                const TextSpan(
                    text:
                        ' would be deducted from your wallet balance to settle your outstanding balance.'),
              ])).pd(EdgeInsets.symmetric(horizontal: 50.w)),
      HelperFunc.sb(50.h),
      SafeArea(
          child: Row(
        children: [
          AppButton(
                  onTap: () => globalPopUntil(Routes.base),
                  btnText: 'Cancel',
                  textFont: 11.5,
                  color: Colors.black)
              .EXPANDED,
          HelperFunc.sb(7.w),
          AppButton(
            onTap: () => context
                .read<WalletCubit>()
                .settleOutstandingBalance(amount: amount),
            btnText: 'Continue',
            textFont: 11.5,
          ).EXPANDED,
        ],
      )),
      HelperFunc.sb(10.h),
    ]).pd(EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h));
  }
}
