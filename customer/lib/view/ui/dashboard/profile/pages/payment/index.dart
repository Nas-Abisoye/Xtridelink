import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import '../../../../../../core/constants/old_assets.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../components/back_button.dart';
import '../../../../../components/button.dart';

class AddPaymentCardPage extends StatefulWidget {
  const AddPaymentCardPage({super.key});

  @override
  State<AddPaymentCardPage> createState() => _AddPaymentCardPageState();
}

class _AddPaymentCardPageState extends State<AddPaymentCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(alignment: Alignment.centerLeft, child: AppBackButton()),
          Expanded(
              child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Payments',
                      style: AppTextStyles.mediumText(fontSize: 22))),
              HelperFunc.sb(5.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Add payment cards',
                        style: AppTextStyles.regularText(
                            fontSize: 13, color: AppColors.grey))
                    .pd(EdgeInsets.only(right: 50.w)),
              ),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    HelperFunc.sb(100.h),
                    SvgPicture.asset(Assets.noCard),
                    HelperFunc.sb(10.h),
                    Text('No cards available',
                        style: AppTextStyles.semiBold(
                            color: AppColors.grey.withOpacity(.7))),
                    HelperFunc.sb(5.h),
                    Text('There is no card saved to your\naccount',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regularText(
                            color: AppColors.grey.withOpacity(.5))),
                    HelperFunc.sb(30.h)
                  ]))
            ],
          ).pd(EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h))),
          const AppButton(btnText: 'Add Card')
              .pd(EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h)),
        ],
      )),
    );
  }
}
