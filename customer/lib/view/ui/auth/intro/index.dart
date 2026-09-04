import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/view/components/button.dart';
import 'package:xtridelink/view/cubit/settings/index.dart';

import '../../../../core/constants/old_assets.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late PageController pageController;
  late ValueNotifier<int> page;
  @override
  void initState() {
    page = ValueNotifier(0);
    pageController = PageController();
    context.read<SettingsCubit>().loadSettings();
    super.initState();
  }

  List<String> headers = ['Speed and', 'Logistics &', 'Safety'];
  List<String> header2 = ['Affordability', 'Delivery', ''];
  List<String> body = [
    'We offer fast & reliable logistics services at an affordable price without compromising on quality.',
    'Simplifying logistics with experience and efficiency.',
    'Provide outstanding service experience that ensures orders are delivered safe, on-time and in excellent condition.'
  ];

  List<String> images = [Assets.intro1, Assets.intro2, Assets.intro3];

  @override
  void dispose() {
    page.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSec,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              HelperFunc.sb(20.h),
              PageView.builder(
                  controller: pageController,
                  padEnds: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: images.length,
                  onPageChanged: (i) => page.value = i,
                  itemBuilder: (context, i) =>
                      Image.asset(images[i]).pd(EdgeInsets.all(40.w))).EXPANDED,
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.r))),
                child: SafeArea(
                  child: ValueListenableBuilder(
                      valueListenable: page,
                      builder: (context, i, _) {
                        return Column(
                          children: [
                            HelperFunc.sb(40.h),
                            Text(headers[i],
                                textAlign: TextAlign.center,
                                style: AppTextStyles.boldText(fontSize: 28)),
                            HelperFunc.sb(5.h),
                            if (i < (images.length - 1))
                              Text(header2[i],
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.boldText(
                                      color: AppColors.materialColor,
                                      fontSize: 26)),
                            HelperFunc.sb(15.h),
                            Text(body[i],
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.regularText(
                                        color: AppColors.grey))
                                .pd(EdgeInsets.symmetric(horizontal: 25.w)),
                            Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                        images.length,
                                        (index) => CircleAvatar(
                                              radius: 4.r,
                                              backgroundColor: i == index
                                                  ? AppColors.secColor
                                                  : AppColors.grey
                                                      .withValues(alpha: 0.4),
                                            ).pd(EdgeInsets.symmetric(
                                                horizontal: 5.w))))
                                .pd(EdgeInsets.symmetric(vertical: 30.h)),
                            HelperFunc.sb(20.h),
                            AppButton(
                              btnText: i < (images.length - 1)
                                  ? 'Next'
                                  : 'Get Started',
                              onTap: () {
                                if (i < (images.length - 1)) {
                                  pageController.animateToPage(i + 1,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.fastLinearToSlowEaseIn);
                                } else {
                                  globalNavigateTo(
                                      route: Routes.initiateSignUp);
                                }
                              },
                            ),
                            HelperFunc.sb(5.h),
                            i < (images.length - 1)
                                ? TextButton(
                                    onPressed: () {
                                      pageController.animateToPage(
                                          images.length - 1,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.fastLinearToSlowEaseIn);
                                    },
                                    child: Text('Skip',
                                        style: AppTextStyles.mediumText(
                                            fontSize: 12.5,
                                            color: Colors.black)))
                                : RichText(
                                        text: TextSpan(
                                            text: 'Already have an account? ',
                                            style: AppTextStyles.mediumText(
                                                fontSize: 12.5,
                                                color: Colors.black),
                                            children: [
                                        TextSpan(
                                            text: 'Sign In',
                                            style: AppTextStyles.mediumText(
                                                fontSize: 12.5,
                                                color: AppColors.materialColor),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = (() => globalNavigateTo(
                                                  route: Routes.login))),
                                      ]))
                                    .pd(EdgeInsets.symmetric(vertical: 15.h))
                          ],
                        );
                      }),
                ),
              )
            ],
          )),
    );
  }
}
