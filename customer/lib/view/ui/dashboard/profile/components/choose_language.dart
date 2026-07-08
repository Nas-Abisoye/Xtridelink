import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/domain/model/local/settings.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../components/button.dart';
import '../../../../cubit/settings/index.dart';

class ChooseLanguageSheet extends StatelessWidget {
  const ChooseLanguageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        HelperFunc.sb(10.h),
        Text('Choose order type', style: AppTextStyles.semiBold()),
        HelperFunc.sb(5.h),
        Text('Select what type of order you want',
            style: AppTextStyles.regularText(color: AppColors.grey)),
        HelperFunc.sb(30.h),
        GestureDetector(
            onTap: () => context.read<SettingsCubit>().setUseEnglish(true),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
                decoration: BoxDecoration(
                    color: AppColors.ashBg,
                    borderRadius: BorderRadius.circular(50.r)),
                child: Row(children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('English Language',
                            style: AppTextStyles.mediumText(fontSize: 14)),
                        HelperFunc.sb(5.h),
                        Text('Default language',
                            style: AppTextStyles.regularText(
                                color: AppColors.grey, fontSize: 10))
                      ])),
                  SvgPicture.asset(Assets.doubleCircle,
                      color: state.useEnglish
                          ? AppColors.materialColor
                          : AppColors.grey.withOpacity(.45))
                ]))),
        HelperFunc.sb(10.h),
        GestureDetector(
            onTap: () => context.read<SettingsCubit>().setUseEnglish(false),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
                decoration: BoxDecoration(
                    color: AppColors.ashBg,
                    borderRadius: BorderRadius.circular(50.r)),
                child: Row(children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('French Language',
                            style: AppTextStyles.mediumText(fontSize: 14)),
                        HelperFunc.sb(5.h),
                        Text('Définir la langue par défaut',
                            style: AppTextStyles.regularText(
                                color: AppColors.grey, fontSize: 10))
                      ])),
                  SvgPicture.asset(Assets.doubleCircle,
                      color: state.useEnglish
                          ? AppColors.grey.withOpacity(.45)
                          : AppColors.materialColor)
                ]))),
        HelperFunc.sb(30.h),
        SafeArea(
            top: false,
            child:
                AppButton(onTap: () => globalPop(), btnText: 'Save Language'))
      ]).pd(EdgeInsets.symmetric(horizontal: 20.w));
    });
  }
}
