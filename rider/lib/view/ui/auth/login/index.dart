import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/debouncer.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/view/components/phone_input.dart';
import 'package:xtridelink_driver/view/ui/auth/login/biometrics.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/navigation/index.dart';
import '../../../../core/services/navigation/routes.dart';
import '../../../components/back_button.dart';
import '../../../components/button.dart';
import '../../../components/form_field.dart';
import '../../../cubit/auth/index.dart';
import '../../../cubit/settings/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController passwordController;
  late TextEditingController phoneController;
  final _debouncer = Debouncer();
  String? countryCode;
  @override
  void initState() {
    countryCode = '+234';
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    _debouncer.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBackButton(onTap: () => globalMaybePop()),
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
              CustomPhoneInput(
                  controller: phoneController,
                  onInputChanged: (v) =>
                      _debouncer(() => countryCode = v.dialCode)),
              HelperFunc.sb(10.h),
              AppFormField(
                  hintText: 'Password',
                  labelText: 'Password',
                  controller: passwordController,
                  keyBoardType: TextInputType.visiblePassword,
                  isPassword: true,
                  validator: (v) => null),
              TextButton(
                  onPressed: () =>
                      globalReplaceWith(route: Routes.forgotPassword),
                  child: Text('Forgot Password?',
                      style: AppTextStyles.mediumText(fontSize: 12.5))),
              HelperFunc.sb(60.h),
              Align(
                  alignment: Alignment.center,
                  child: BiometricsLogin(onAuth: () {
                    final settingsState = context.read<SettingsCubit>().state;
                    context.read<AuthCubit>().signIn(
                        phoneNumber: settingsState.phoneNumber,
                        password: settingsState.password);
                  }))
            ],
          ).pd(EdgeInsets.all(15.w)))
              .EXPANDED,
          ListenableBuilder(
              listenable:
                  Listenable.merge([phoneController, passwordController]),
              builder: (context, _) {
                return AppButton(
                        btnText: 'Continue',
                        onTap: () => phoneController.text
                                        .replaceAll(' ', '')
                                        .length ==
                                    10 &&
                                passwordController.text.isNotEmpty
                            ? context.read<AuthCubit>().signIn(
                                phoneNumber: countryCode! +
                                    phoneController.text.replaceAll(' ', ''),
                                password: passwordController.text)
                            : null,
                        color:
                            phoneController.text.replaceAll(' ', '').length ==
                                        10 &&
                                    passwordController.text.isNotEmpty
                                ? null
                                : AppColors.grey.withOpacity(.5))
                    .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 10.h));
              }),
        ],
      )),
    );
  }
}
