import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/base/base_stateless_page.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/injector.dart';
import 'package:xtridelink/view/components/back_button.dart';
import 'package:xtridelink/view/components/button.dart';
import 'package:xtridelink/view/components/phone_input.dart';
import 'package:xtridelink/view/ui/auth/signup/cubit/signup_cubit.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class InitiateSignUpPage extends StatelessWidget {
  const InitiateSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignupCubit>(),
      child: _InitiateSignUpView(),
    );
  }
}

class _InitiateSignUpView extends BaseStatelessPage<SignupCubit> {
  @override
  Widget buildPage(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (previous, current) =>
          previous.initiatSignupResponse != current.initiatSignupResponse,
      listener: (context, state) {
        if (state.initiatSignupResponse.hasSuccess) {
          globalNavigateTo(
              route: Routes.signUpVerifyPhone,
              arguments: state.formData.phone.value);
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Row(children: [
              const AppBackButton(),
              const Spacer(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      3,
                      (index) => CircleAvatar(
                            radius: 4.r,
                            backgroundColor: index == 0
                                ? AppColors.secColor
                                : AppColors.grey.withValues(alpha: 0.3),
                          ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
              HelperFunc.sb(15.w)
            ]),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What is your phone number?',
                    style: AppTextStyles.mediumText(fontSize: 20)),
                HelperFunc.sb(25.h),
                CustomPhoneInput(onInputChanged: (v) {
                  if (v.phoneNumber != null) {
                    context
                        .read<SignupCubit>()
                        .onPhoneChanged(v.phoneNumber!.replaceAll('+', ''));
                  }
                }),
                HelperFunc.sb(20.h),
                RichText(
                    text: TextSpan(
                        text:
                            'By clicking on continue, you agree to Xtridelink\'s  ',
                        style: AppTextStyles.regularText(
                            fontSize: 11.5, color: AppColors.grey),
                        children: [
                      TextSpan(
                          text: 'Terms of service',
                          style: AppTextStyles.mediumText(
                              fontSize: 11.5, color: AppColors.materialColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = (() => globalNavigateTo(
                                route: Routes.legal,
                                arguments: XtridelinkDocsType.terms))),
                      TextSpan(
                          text: ' and ',
                          style:
                              AppTextStyles.regularText(color: AppColors.grey)),
                      TextSpan(
                          text: 'Privacy policy.',
                          style: AppTextStyles.mediumText(
                              fontSize: 11.5, color: AppColors.materialColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = (() => globalNavigateTo(
                                route: Routes.legal,
                                arguments: XtridelinkDocsType.privacy)))
                    ])),
              ],
            ).pd(EdgeInsets.all(15.w)))),
            BlocBuilder<SignupCubit, SignupState>(
              builder: (context, state) => AppButton(
                      btnText: 'Continue',
                      onTap: () => state.formData.canInitiateSignup
                          ? context.read<SignupCubit>().initiateSignup()
                          : null,
                      color: state.formData.canInitiateSignup
                          ? null
                          : AppColors.grey.withValues(alpha: .5))
                  .pd(EdgeInsets.symmetric(horizontal: 15.w)),
            ),
            HelperFunc.sb(24.h),
            // TextButton(
            //         onPressed: () => globalReplaceWith(route: Routes.base),
            //         child: Text('Continue as guest',
            //             style: AppTextStyles.regularText(
            //                 fontSize: 12.5, color: Colors.black)))
            //     .pd(EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 0))
          ],
        )),
      ),
    );
  }
}
