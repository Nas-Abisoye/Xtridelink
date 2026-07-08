import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/helpers/app_constants.dart';
import 'package:xtridelink/core/helpers/app_extension.dart';
import 'package:xtridelink/core/theme/app_colors.dart';
import 'package:xtridelink/core/widgets/app_text.dart';
import 'package:xtridelink/core/widgets/buttons/custom_button.dart';
import 'package:xtridelink/gen/assets.gen.dart';
import 'package:xtridelink/view/components/button.dart';

class OnSuccessDialogContent extends StatelessWidget {
  const OnSuccessDialogContent({
    required this.subtext,
    required this.onDoneCallback,
    this.buttonText,
    super.key,
  });
  final String subtext;
  final String? buttonText;
  final void Function(BuildContext) onDoneCallback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: (context.heightPx * 0.5),
      width: double.infinity,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          // inserted widget
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                15.vSpaceBox,

                // image
                Expanded(child: Assets.svg.success.svg()),

                10.vSpaceBox,

                // success
                const AppText(
                  text: 'Success',
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  size: 24,
                ),

                10.vSpaceBox,

                // text
                AppText(
                  text: subtext,
                  color: AppColors.grey3,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  size: 12,
                ),

                15.vSpaceBox,

                // button
                CustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onDoneCallback(context);
                  },
                  title: buttonText ?? 'Continue'.toUpperCase(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnFailDialogContent extends StatelessWidget {
  const OnFailDialogContent({
    super.key,
    required this.subtext,
    this.buttonText,
    required this.onDoneCallback,
  });

  final String subtext;
  final String? buttonText;
  final void Function(BuildContext) onDoneCallback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          // inserted widget
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                10.vSpaceBox,

                // image
                Expanded(child: Assets.svg.fail.svg()),

                10.vSpaceBox,

                // success
                const AppText(
                  text: 'Oops!!',
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  size: 24,
                ),

                10.vSpaceBox,

                // text
                AppText(
                  text: subtext,
                  color: AppColors.grey4,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  size: 12,
                ),

                15.vSpaceBox,

                // button
                AppButton(
                  onTap: () {
                    Navigator.pop(context);
                    onDoneCallback(context);
                  },
                  btnText: buttonText ?? 'Try Again'.toUpperCase(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BiometricModal extends StatelessWidget {
  const BiometricModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const AppText(
            text: 'Sign In',
            fontWeight: FontWeight.bold,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/outline/fingerprint_bare.svg'),
              5.hSpaceBox,
              const AppText(text: 'Scan your fingerprint'),
            ],
          ),
          const AppText(
            text: 'Cancel',
            color: AppColors.primaryColor,
          )
        ],
      ),
    );
  }
}

class OnSessionExpiredDialogContent extends StatefulWidget {
  const OnSessionExpiredDialogContent({
    required this.onContinue,
    required this.onLogout,
    super.key,
  });

  final void Function() onLogout;
  final void Function() onContinue;

  @override
  State<OnSessionExpiredDialogContent> createState() =>
      _OnSessionExpiredDialogContentState();
}

class _OnSessionExpiredDialogContentState
    extends State<OnSessionExpiredDialogContent> {
  Timer? _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = null;
    _timer = Timer(
      const Duration(seconds: AppConstants.showDialogTime),
      widget.onLogout,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: (context.heightPx * 0.5),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            15.vSpaceBox,

            // image
            Expanded(child: SvgPicture.asset('assets/svg/logout_icon.svg')),

            10.vSpaceBox,

            // success
            const AppText(
              text: 'Inactivity Noticed',
              color: Colors.black,
              fontWeight: FontWeight.w900,
              size: 18,
            ),

            10.vSpaceBox,

            // text
            const AppText(
              text: "Hello, we notice you've been"
                  '\ninactive for ${AppConstants.sessionDialogTimeout} seconds.'
                  '\n\nNote:'
                  '\nYou will be logged out in ${AppConstants.showDialogTime} seconds.',
              color: AppColors.grey3,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              size: 12,
            ),

            15.vSpaceBox,

            // button
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onLogout();
                    },
                    title: 'Logout'.toUpperCase(),
                    background: Colors.white,
                    borderColor: AppColors.primaryColor,
                    textColor: AppColors.primaryColor,
                  ),
                ),
                12.hSpaceBox,
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onContinue();
                    },
                    title: 'Resume'.toUpperCase(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Image.asset("assets/images/yayy.png"),
