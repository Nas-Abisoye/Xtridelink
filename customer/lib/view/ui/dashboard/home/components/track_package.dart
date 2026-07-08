import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/view/components/form_field.dart';

class HomeTrackPackage extends StatefulWidget {
  const HomeTrackPackage({super.key});

  @override
  State<HomeTrackPackage> createState() => _HomeTrackPackageState();
}

class _HomeTrackPackageState extends State<HomeTrackPackage> {
  late TextEditingController trackController;
  @override
  void initState() {
    trackController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    trackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 180.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r)),
        child: Stack(fit: StackFit.expand, children: [
          SvgPicture.asset(Assets.cardBg, fit: BoxFit.fill),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Track your package',
                style:
                    AppTextStyles.semiBold(color: Colors.white, fontSize: 19)),
            HelperFunc.sb(5.h),
            Text('Enter your package number to track it in real time',
                style: AppTextStyles.regularText(
                    color: Colors.white, fontSize: 11)),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: AppFormField(
                prefixWidget:
                    Icon(Icons.search, color: AppColors.grey.withOpacity(.5)),
                hintText: 'Tracking number',
                controller: trackController,
                validator: (v) => null,
                fillColor: Colors.white,
              ),
            )
          ]).pd(EdgeInsets.all(23.w))
        ]));
  }
}
