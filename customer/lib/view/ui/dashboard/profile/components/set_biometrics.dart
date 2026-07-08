import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/domain/model/local/settings.dart';
import 'profile_action.dart';
import '../../../../../core/services/biometrics/index.dart';
import '../../../../../../../injector.dart';
import '../../../../cubit/settings/index.dart';

class SetBiometricsLoginOption extends StatelessWidget {
  final void Function()? onAuth;
  SetBiometricsLoginOption({super.key, this.onAuth});
  final ValueNotifier<bool> canSignIn = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: getIt<BiometricsService>().canAuthenticate,
        builder: (context, bool value, _) {
          return value
              ? ProfileAction(
                  suffixIcon: BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                    return Switch(
                        activeColor: AppColors.secColor,
                        value: state.biometricsLogin,
                        onChanged: (v) {
                          getIt<BiometricsService>().authenticate(
                              onAuth: () => context
                                  .read<SettingsCubit>()
                                  .toggleBiometricsLogin(v));
                        });
                  }),
                  avatar: Assets.fingerprint,
                  text: 'Sign In With Biometrics')
              : const SizedBox();
        });
  }
}
