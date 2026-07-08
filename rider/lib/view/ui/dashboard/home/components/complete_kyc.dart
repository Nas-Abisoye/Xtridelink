import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';

class HomeCompleteKyc extends StatelessWidget {
  const HomeCompleteKyc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      return state.riderAnalytics?.kycVerified.toUpperCase() == 'SKIPPED' ||
              state.riderAnalytics?.kycVerified.toUpperCase() == 'FAILED'
          ? GestureDetector(
              onTap: () => globalNavigateTo(route: Routes.verifyKYC),
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 15.w),
                  margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(.1),
                      borderRadius: BorderRadius.circular(18.r)),
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundColor: AppColors.red,
                          radius: 9.r,
                          child: Text('i',
                              style: AppTextStyles.boldText(
                                  fontSize: 10, color: Colors.white))),
                      HelperFunc.sb(10.w),
                      Text('Complete your KYC',
                              style: AppTextStyles.mediumText(fontSize: 13.5))
                          .EXPANDED,
                      HelperFunc.sb(10.w),
                      SvgPicture.asset(Assets.forwardArrow, height: 13.h),
                      HelperFunc.sb(5.w)
                    ],
                  )),
            )
          : const SizedBox();
    });
  }
}
