import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';

import '../../../../../core/constants/old_assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/button.dart';
import '../order_dispatch.dart';

class PaymentOptionsSheet extends StatefulWidget {
  const PaymentOptionsSheet({super.key});

  @override
  State<PaymentOptionsSheet> createState() => _PaymentOptionsSheetState();
}

class _PaymentOptionsSheetState extends State<PaymentOptionsSheet> {
  late ValueNotifier<bool?> payCash;
  @override
  void initState() {
    payCash = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    payCash.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: payCash,
        builder: (context, bool? value, _) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HelperFunc.sb(10.h),
                Text('Choose payment type', style: AppTextStyles.semiBold()),
                HelperFunc.sb(10.h),
                Text('Select what type of order you want',
                    style: AppTextStyles.regularText(color: AppColors.grey)),
                HelperFunc.sb(25.h),
                OrderOptionsCard(
                    width: double.infinity,
                    onTap: () => payCash.value = false,
                    avatarColor: AppColors.lightSec,
                    avatarRadius: 29,
                    isSelected: value == false,
                    fillColor:
                        value == false ? AppColors.secColor : AppColors.ashBg,
                    avatarSvg: Assets.internet,
                    headerTxt: 'Pay online',
                    subTxt: 'Use your debit card or transfer to pay'),
                // HelperFunc.sb(10.h),
                // OrderOptionsCard(
                //     width: double.infinity,
                //     onTap: () => payCash.value = true,
                //     avatarColor: AppColors.lightPri,
                //     avatarIconColor: AppColors.materialColor,
                //     avatarRadius: 29,
                //     iconSize: 16.h,
                //     isSelected: value == true,
                //     fillColor:
                //         value == true ? AppColors.secColor : AppColors.ashBg,
                //     avatarSvg: Assets.price,
                //     headerTxt: 'Pay with cash',
                //     subTxt: 'Pay to the driver at the delivery point'),
                HelperFunc.sb(25.h),
                SafeArea(
                  top: false,
                  child: AppButton(
                      onTap: value == null
                          ? null
                          : value
                              ? () {
                                  // context.read<OrdersCubit>().updatePayment(
                                  //     onSuccess: () {
                                  //       globalPop();
                                  //       globalNavigateTo(
                                  //           route: Routes.orderPlacedSuccess);
                                  //     },
                                  //     paymentMethod: 'CASH');
                                }
                              : () => context
                                  .read<OrdersCubit>()
                                  .generatePaymentAccount(),
                      btnText: 'Proceed',
                      color: value == null
                          ? AppColors.grey.withValues(alpha: .5)
                          : null),
                )
              ]).pd(EdgeInsets.symmetric(horizontal: 20.w));
        });
  }
}
