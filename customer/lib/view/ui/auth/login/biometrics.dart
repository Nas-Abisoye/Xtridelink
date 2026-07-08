import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/domain/model/local/settings.dart';
import 'package:xtridelink/core/services/biometrics/index.dart';
import 'package:xtridelink/injector.dart';

import 'package:xtridelink/view/cubit/settings/index.dart';

class BiometricsLogin extends StatelessWidget {
  final void Function()? onAuth;
  const BiometricsLogin({super.key, this.onAuth});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
      return ValueListenableBuilder(
          valueListenable: getIt<BiometricsService>().canAuthenticate,
          builder: (context, bool value, _) {
            return value && state.email.isNotEmpty && state.password.isNotEmpty
                ? Column(children: [
                    GestureDetector(
                        onTap: () => getIt<BiometricsService>()
                            .authenticate(onAuth: onAuth),
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundColor: AppColors.secColor,
                          child: SvgPicture.asset(
                              getIt<BiometricsService>().isIOS
                                  ? Assets.faceId
                                  : Assets.fingerprint),
                        )),
                    HelperFunc.sb(10.h),
                    Text(
                        'Sign in with ${getIt<BiometricsService>().isIOS ? 'Face ID' : 'Fingerprint'}',
                        style: AppTextStyles.regularText())
                  ])
                : const SizedBox();
          });
    });
  }
}
