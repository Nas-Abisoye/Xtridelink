import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/base/base_stateless_page.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/injector.dart';
import 'package:xtridelink/view/components/phone_input.dart';
import 'package:xtridelink/view/ui/auth/login/cubit/login_cubit.dart';

import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/navigation/index.dart';
import '../../../../core/services/navigation/routes.dart';
import '../../../components/back_button.dart';
import '../../../components/button.dart';
import '../../../components/form_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: _LoginView(),
    );
  }
}

class _LoginView extends BaseStatelessPage<LoginCubit> {
  @override
  Widget buildPage(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          previous.loginResponse != current.loginResponse,
      listener: (context, state) {
        if (state.loginResponse.hasSuccess) {
          globalReplaceUntil(route: Routes.base);
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Row(children: [
              AppBackButton(onTap: () => globalMaybePop()),
              const Spacer(),
              // TextButton(
              //         onPressed: () => globalReplaceWith(route: Routes.base),
              //         child: Text('Continue as guest',
              //             style: AppTextStyles.semiBold(
              //                 color: AppColors.secColor, fontSize: 13)))
              //     .pd(EdgeInsets.only(right: 10.w)),
            ]),
            SingleChildScrollView(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back',
                    style: AppTextStyles.mediumText(fontSize: 20)),
                HelperFunc.sb(10.h),
                Text('Enter your details to login.',
                        style: AppTextStyles.regularText(
                            fontSize: 13, color: AppColors.grey))
                    .pd(EdgeInsets.only(right: 50.w)),
                HelperFunc.sb(25.h),
                CustomPhoneInput(onInputChanged: (v) {
                  if (v.phoneNumber != null) {
                    context
                        .read<LoginCubit>()
                        .onPhoneChanged(v.phoneNumber!.replaceAll('+', ''));
                  }
                }),
                HelperFunc.sb(10.h),
                BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
                  return AppFormField(
                    hintText: 'Password',
                    labelText: 'Password',
                    keyBoardType: TextInputType.visiblePassword,
                    isPassword: true,
                    onChanged: (v) =>
                        context.read<LoginCubit>().onPasswordChanged(v),
                    validator: (v) => state.password.error?.message,
                  );
                }),
                TextButton(
                    onPressed: () =>
                        globalReplaceWith(route: Routes.forgotPassword),
                    child: Text('Forgot Password?',
                        style: AppTextStyles.mediumText(fontSize: 12.5))),
                HelperFunc.sb(60.h),
                // Align(
                //     alignment: Alignment.center,
                //     child: BiometricsLogin(onAuth: () {
                //       final settingsState = context.read<SettingsCubit>().state;
                //       // context.read<AuthCubit>().signIn(
                //       //     email: settingsState.email,
                //       //     password: settingsState.password);
                //     }))
              ],
            ).pd(EdgeInsets.all(15.w)))
                .EXPANDED,
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return AppButton(
                    btnText: 'Continue',
                    onTap: state.canLogin
                        ? () => context.read<LoginCubit>().signIn()
                        : null,
                    color:
                        state.canLogin ? null : AppColors.grey.withOpacity(.5));
              },
            ).pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 10.h)),
          ],
        )),
      ),
    );
  }
}
