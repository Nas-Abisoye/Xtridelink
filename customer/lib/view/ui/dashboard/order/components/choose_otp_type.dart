import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../order_dispatch.dart';
import '../pages/order_details.dart';

class ChooseOtpType extends StatelessWidget {
  final ValueNotifier<OrderDetailsForm> isFormValid;
  const ChooseOtpType({super.key, required this.isFormValid});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // children: [
      //   Text('How do you want to receive code?',
      //           style: AppTextStyles.mediumText(fontSize: 12))
      //       .pd(EdgeInsets.only(left: 20.w)),
      //   SingleChildScrollView(
      //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      //     scrollDirection: Axis.horizontal,
      //     child: ValueListenableBuilder(
      //         valueListenable: isFormValid,
      //         builder: (context, value, _) {
      //           return Row(
      //             children: [
      //               OrderOptionsCard(
      //                   onTap: () {
      //                     if (value.alertMethod == 'sms') return;
      //                     isFormValid.value =
      //                         value.copyWith(alertMethod: 'sms');
      //                   },
      //                   avatarColor: value.alertMethod == 'sms'
      //                       ? Colors.white
      //                       : AppColors.ashBg,
      //                   avatarRadius: 20,
      //                   isSelected: value.alertMethod == 'sms',
      //                   fillColor: value.alertMethod == 'sms'
      //                       ? AppColors.secColor
      //                       : Colors.white,
      //                   avatarSvg: Assets.sms,
      //                   txtFont: 13,
      //                   headerTxt: 'Receive an sms   ',
      //                   subTxt: 'Code sent to number'),
      //               HelperFunc.sb(10.h),
      //               OrderOptionsCard(
      //                   onTap: () {
      //                     if (value.alertMethod == 'mail') return;
      //                     isFormValid.value =
      //                         value.copyWith(alertMethod: 'mail');
      //                   },
      //                   avatarColor: value.alertMethod == 'mail'
      //                       ? Colors.white
      //                       : AppColors.ashBg,
      //                   avatarRadius: 20,
      //                   txtFont: 13,
      //                   isSelected: value.alertMethod == 'mail',
      //                   fillColor: value.alertMethod == 'mail'
      //                       ? AppColors.secColor
      //                       : Colors.white,
      //                   avatarSvg: Assets.mail,
      //                   headerTxt: 'Receive an email   ',
      //                   subTxt: 'Code sent to email'),
      //             ],
      //           );
      //         }),
      //   )
      // ],
    );
  }
}
