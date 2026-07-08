import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import 'package:xtridelink_driver/view/cubit/wallet/index.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';
import '../../../../components/form_field.dart';

typedef WithdrawalDet = ({num amount, String bankAccountId});

class WithdrawalPasswordPage extends StatefulWidget {
  final WithdrawalDet withdrawDet;
  const WithdrawalPasswordPage({super.key, required this.withdrawDet});

  @override
  State<WithdrawalPasswordPage> createState() => _WithdrawalPasswordPageState();
}

class _WithdrawalPasswordPageState extends State<WithdrawalPasswordPage> {
  late ValueNotifier<bool> isFormValid;
  late TextEditingController passwordController;
  @override
  void initState() {
    isFormValid = ValueNotifier(false);
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    isFormValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBackButton(onTap: () => globalPopUntil(Routes.base)),
          SingleChildScrollView(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter Password',
                  style: AppTextStyles.mediumText(fontSize: 20)),
              HelperFunc.sb(10.h),
              Text('Provide the password for your account',
                      style: AppTextStyles.regularText(
                          fontSize: 13, color: AppColors.grey))
                  .pd(EdgeInsets.only(right: 50.w)),
              HelperFunc.sb(25.h),
              AppFormField(
                  hintText: 'Password',
                  labelText: 'Password',
                  controller: passwordController,
                  keyBoardType: TextInputType.visiblePassword,
                  isPassword: true,
                  onChanged: (v) => isFormValid.value = v.isNotEmpty,
                  validator: (v) => null),
            ],
          ).pd(EdgeInsets.all(15.w)))
              .EXPANDED,
          ValueListenableBuilder(
              valueListenable: isFormValid,
              builder: (context, bool value, _) {
                return AppButton(
                        btnText: 'Continue',
                        onTap: value
                            ? () => context.read<WalletCubit>().withdraw(
                                amount: widget.withdrawDet.amount,
                                bankAccountId: widget.withdrawDet.bankAccountId,
                                password: passwordController.text)
                            : null,
                        color: value ? null : AppColors.grey.withOpacity(.5))
                    .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 10.h));
              }),
        ],
      )),
    );
  }
}
