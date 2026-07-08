import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/domain/model/local/bank.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/wallet/components/withdraw_prompts.dart';
import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/button.dart';
import '../../../../components/form_field.dart';
import '../../../../cubit/wallet/index.dart';

class WithdrawSheet extends StatefulWidget {
  const WithdrawSheet({super.key});

  @override
  State<WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<WithdrawSheet> {
  late FocusNode focusNode;
  late TextEditingController amountController;
  late ValueNotifier<UserBankAccount?> bank;

  @override
  void initState() {
    context.read<ProfileCubit>().reloadBankAccounts();
    focusNode = FocusNode();
    amountController = TextEditingController();
    bank = ValueNotifier(null);
    focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    focusNode.dispose();
    bank.dispose();
    super.dispose();
  }

  void continueWithdrawal(num amount) => HelperFunc.showFittedBottomSheet(
      context: context,
      child: SelectBankToWithdrawTo(
          amount: amount, bank: bank, onTap: (i) => bank.value = i));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter amount to withdraw',
              style: AppTextStyles.mediumText(fontSize: 18)),
          HelperFunc.sb(5.h),
          Text('Provide the amount you want to send to back',
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
                if ((num.tryParse(v?.replaceAll(',', '') ?? '') ?? 0) < 1000) {
                  return 'Minimum withdrawal amount is 1000';
                }
                if ((num.tryParse(v?.replaceAll(',', '') ?? '') ?? 0) >
                    (state.balance ?? 0)) {
                  return 'Insufficient balance';
                }
                return null;
              }),
          HelperFunc.sb(80.h),
          ValueListenableBuilder(
              valueListenable: amountController,
              builder: (context, value, _) {
                final isFormValid =
                    ((num.tryParse(value.text.replaceAll(',', '')) ?? 0) >=
                            1000) &&
                        ((num.tryParse(value.text.replaceAll(',', '')) ?? 0) <=
                            (state.balance ?? 0));
                return SafeArea(
                  top: false,
                  child: AppButton(
                      btnText: 'Continue',
                      onTap: isFormValid
                          ? () async {
                              final amount = num.tryParse(amountController.text
                                      .replaceAll(',', '')) ??
                                  0;
                              if (state.offlineOutStanding == null) {
                                HelperFunc.showLoader();
                                await context
                                    .read<WalletCubit>()
                                    .getOutStandingBalance();
                                globalPop();
                              }
                              if (!context.mounted) return;
                              if ((state.offlineOutStanding ?? 0) <= 0) {
                                continueWithdrawal(amount);
                              } else if (amount >
                                  (state.offlineOutStanding ?? 0)) {
                                HelperFunc.showPopUpDialog(
                                    context: context,
                                    child: OutstandingDeductionsWithdrawal(
                                        onContinue: () =>
                                            continueWithdrawal(amount)));
                              } else if (amount <
                                  (state.offlineOutStanding ?? 0)) {
                                HelperFunc.showPopUpDialog(
                                    context: context,
                                    child: const ClearOutstandingToWithdraw());
                              }
                            }
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

class SelectBankToWithdrawTo extends StatelessWidget {
  final ValueNotifier<UserBankAccount?> bank;
  final void Function(UserBankAccount) onTap;
  final num amount;
  const SelectBankToWithdrawTo(
      {super.key,
      required this.bank,
      required this.onTap,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: bank,
        builder: (context, value, _) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select bank account',
                    style: AppTextStyles.mediumText(fontSize: 18)),
                HelperFunc.sb(5.h),
                Text('Choose a bank account to send money to',
                        style: AppTextStyles.regularText(
                            fontSize: 13, color: AppColors.grey))
                    .pd(EdgeInsets.only(right: 50.w)),
                HelperFunc.sb(20.h),
                BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                  return Column(
                      children: (state.userBankAccounts ?? [])
                          .map((e) => GestureDetector(
                                onTap: () => onTap(e),
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16.h, horizontal: 13.w),
                                    margin: EdgeInsets.only(bottom: 10.h),
                                    decoration: BoxDecoration(
                                        color: AppColors.ashBg,
                                        borderRadius:
                                            BorderRadius.circular(50.r)),
                                    child: Row(children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            AppColors.grey.withOpacity(.1),
                                        radius: 19.r,
                                        child: Image.asset(Assets.bank,
                                            height: 25.h, width: 25.w),
                                      ),
                                      HelperFunc.sb(10.w),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(e.bankName,
                                                style: AppTextStyles.mediumText(
                                                    fontSize: 14)),
                                            HelperFunc.sb(5.h),
                                            Text(
                                                '${e.bankAccountNo} . ${e.name}',
                                                style:
                                                    AppTextStyles.regularText(
                                                        color: AppColors.grey,
                                                        fontSize: 10))
                                          ]).EXPANDED,
                                      SvgPicture.asset(Assets.doubleCircle,
                                          color: value == e
                                              ? AppColors.materialColor
                                              : AppColors.grey
                                                  .withOpacity(.45)),
                                      HelperFunc.sb(10.w)
                                    ])),
                              ))
                          .toList());
                }),
                HelperFunc.sb(30.h),
                SafeArea(
                    top: false,
                    child: AppButton(
                        onTap: value != null
                            ? () {
                                globalPopUntil(Routes.base);
                                globalNavigateTo(
                                    route: Routes.withdrawalPassword,
                                    arguments: (
                                      amount: amount,
                                      bankAccountId: value.id
                                    ));
                              }
                            : null,
                        color: value != null
                            ? null
                            : AppColors.grey.withOpacity(.5),
                        btnText: 'Continue'))
              ]).pd(EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h));
        });
  }
}
