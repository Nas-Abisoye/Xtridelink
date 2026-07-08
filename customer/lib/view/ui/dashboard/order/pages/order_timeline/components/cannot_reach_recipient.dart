import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/extensions.dart';

import '../../../../../../../core/constants/old_assets.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../../../core/constants/helpers.dart';
import '../../../../../../../core/constants/text_styles.dart';
import '../../../../../../components/button.dart';

class CantReachRecipientSheet extends StatelessWidget {
  const CantReachRecipientSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
          backgroundColor: AppColors.lightPri,
          radius: 55.r,
          child: SvgPicture.asset(Assets.bell)),
      HelperFunc.sb(25.h),
      Text('Driver can’t find recipient',
          textAlign: TextAlign.center,
          style: AppTextStyles.semiBold(fontSize: 22)),
      HelperFunc.sb(10.h),
      Text('The driver can’t reach the recipient, contact the recipient in the next 5 minutes or the trip will be cancelled',
              textAlign: TextAlign.center,
              style: AppTextStyles.regularText(
                  fontSize: 13, color: AppColors.grey))
          .pd(EdgeInsets.symmetric(horizontal: 50.w)),
      HelperFunc.sb(60.h),
      SafeArea(
          child: AppButton(
              onTap: () {}, color: Colors.black, btnText: 'Call recipient'))
    ]).pd(EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h));
  }
}
