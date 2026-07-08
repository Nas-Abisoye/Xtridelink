import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import 'package:xtridelink_driver/view/components/back_button.dart';
import 'package:xtridelink_driver/view/components/button.dart';
import 'package:xtridelink_driver/view/components/form_field.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';

class AddMerchantMailPage extends StatefulWidget {
  const AddMerchantMailPage({super.key});

  @override
  State<AddMerchantMailPage> createState() => _AddMerchantMailPageState();
}

class _AddMerchantMailPageState extends State<AddMerchantMailPage> {
  late ValueNotifier<bool> isFormValid;
  late TextEditingController emailController;
  @override
  void initState() {
    isFormValid = ValueNotifier(false);
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    isFormValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const AppBackButton(),
                const Spacer(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        2,
                        (index) => CircleAvatar(
                              radius: 4.r,
                              backgroundColor: index == 0
                                  ? AppColors.secColor
                                  : AppColors.grey.withOpacity(0.3),
                            ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
                HelperFunc.sb(15.w)
              ],
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Provide email address',
                      style: AppTextStyles.mediumText(fontSize: 20)),
                  HelperFunc.sb(10.h),
                  Text('Provide the email registered as a merchant',
                          style: AppTextStyles.regularText(
                              fontSize: 13, color: AppColors.grey))
                      .pd(EdgeInsets.only(right: 50.w)),
                  HelperFunc.sb(25.h),
                  AppFormField(
                      hintText: 'Email Address',
                      labelText: 'Email Address',
                      controller: emailController,
                      keyBoardType: TextInputType.emailAddress,
                      onChanged: (v) => isFormValid.value = v.isValidEmail)
                ],
              ).pd(EdgeInsets.all(15.w)),
            ).EXPANDED,
            ValueListenableBuilder(
                valueListenable: isFormValid,
                builder: (context, bool value, _) {
                  return AppButton(
                          btnText: 'Continue',
                          onTap: () => value
                              ? globalReplaceWith(
                                  route: Routes.createMerchantPwd)
                              : null,
                          color: value ? null : AppColors.grey.withOpacity(.5))
                      .pd(EdgeInsets.symmetric(horizontal: 15.w));
                }),
            HelperFunc.sb(15.h)
          ],
        ),
      ),
    );
  }
}
