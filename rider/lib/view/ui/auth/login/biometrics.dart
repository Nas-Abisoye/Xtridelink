import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/constants/text_styles.dart';
import 'package:xtridelink_driver/domain/model/local/settings.dart';
import 'package:xtridelink_driver/core/services/biometrics/index.dart';
import 'package:xtridelink_driver/di/get_it.dart';
import 'package:xtridelink_driver/view/cubit/settings/index.dart';

class BiometricsLogin extends StatelessWidget {
  final void Function()? onAuth;
  const BiometricsLogin({super.key, this.onAuth});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
      return ValueListenableBuilder(
          valueListenable: getItInst<BiometricsService>().canAuthenticate,
          builder: (context, bool value, _) {
            return value &&
                    state.phoneNumber.isNotEmpty &&
                    state.password.isNotEmpty
                ? Column(children: [
                    GestureDetector(
                        onTap: () => getItInst<BiometricsService>()
                            .authenticate(onAuth: onAuth),
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundColor: AppColors.secColor,
                          child: SvgPicture.asset(
                              getItInst<BiometricsService>().isIOS
                                  ? Assets.faceId
                                  : Assets.fingerprint),
                        )),
                    HelperFunc.sb(10.h),
                    Text(
                        'Sign in with ${getItInst<BiometricsService>().isIOS ? 'Face ID' : 'Fingerprint'}',
                        style: AppTextStyles.regularText())
                  ])
                : const SizedBox();
          });
    });
  }
}
