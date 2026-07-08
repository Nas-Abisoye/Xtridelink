import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/button.dart';

class AddBankToWithdraw extends StatelessWidget {
  const AddBankToWithdraw({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: () => globalPop(), icon: const Icon(Icons.close))
            .align(Alignment.topRight)
            .pd(EdgeInsets.only(top: 5.h, right: 5.w)),
        CircleAvatar(
            backgroundColor: AppColors.materialColor,
            radius: 50.r,
            child: Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 45.sp)),
        HelperFunc.sb(20.h),
        Text('No Bank Account', style: AppTextStyles.semiBold(fontSize: 18)),
        HelperFunc.sb(10.h),
        Text('Add your bank account details to continue withdrawal.',
                textAlign: TextAlign.center,
                style: AppTextStyles.regularText(color: AppColors.grey))
            .pd(EdgeInsets.symmetric(horizontal: 60.w)),
        HelperFunc.sb(30.h),
        SafeArea(
            child: Row(children: [
          HelperFunc.sb(20.w),
          Expanded(
              child: AppButton(
                  onTap: () => globalPop(),
                  color: Colors.black,
                  textFont: 12.5,
                  btnText: 'Cancel')),
          HelperFunc.sb(10.w),
          Expanded(
              child: AppButton(
                  onTap: () {
                    globalPop();
                    globalNavigateTo(route: Routes.addBankAccount);
                  },
                  btnText: 'Add Account')),
          HelperFunc.sb(20.w)
        ])),
        HelperFunc.sb(20.h)
      ],
    );
  }
}

class OutstandingDeductionsWithdrawal extends StatelessWidget {
  final VoidCallback onContinue;
  const OutstandingDeductionsWithdrawal({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: () => globalPop(), icon: const Icon(Icons.close))
            .align(Alignment.topRight)
            .pd(EdgeInsets.only(top: 5.h, right: 5.w)),
        CircleAvatar(
            backgroundColor: AppColors.materialColor,
            radius: 50.r,
            child: Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 45.sp)),
        HelperFunc.sb(20.h),
        Text('Outstanding Deduction',
            style: AppTextStyles.semiBold(fontSize: 18)),
        HelperFunc.sb(10.h),
        Text('Please note that your outstanding balance will be deducted from your withdrawal. Do you want to continue?',
                textAlign: TextAlign.center,
                style: AppTextStyles.regularText(color: AppColors.grey))
            .pd(EdgeInsets.symmetric(horizontal: 60.w)),
        HelperFunc.sb(30.h),
        SafeArea(
            child: Row(children: [
          HelperFunc.sb(20.w),
          Expanded(
              child: AppButton(
                  onTap: () => globalPop(),
                  color: Colors.black,
                  textFont: 12.5,
                  btnText: 'No')),
          HelperFunc.sb(10.w),
          Expanded(
              child: AppButton(
                  onTap: () {
                    globalPop();
                    onContinue();
                  },
                  btnText: 'Yes')),
          HelperFunc.sb(20.w)
        ])),
        HelperFunc.sb(20.h)
      ],
    );
  }
}

class ClearOutstandingToWithdraw extends StatelessWidget {
  const ClearOutstandingToWithdraw({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: () => globalPop(), icon: const Icon(Icons.close))
            .align(Alignment.topRight)
            .pd(EdgeInsets.only(top: 5.h, right: 5.w)),
        CircleAvatar(
            backgroundColor: AppColors.materialColor,
            radius: 50.r,
            child: Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 45.sp)),
        HelperFunc.sb(20.h),
        Text('Outstanding Balance!',
            style: AppTextStyles.semiBold(fontSize: 18)),
        HelperFunc.sb(10.h),
        Text('Please settle outstanding balance to continue withdrawal.',
                textAlign: TextAlign.center,
                style: AppTextStyles.regularText(color: AppColors.grey))
            .pd(EdgeInsets.symmetric(horizontal: 60.w)),
        HelperFunc.sb(20.h)
      ],
    );
  }
}
