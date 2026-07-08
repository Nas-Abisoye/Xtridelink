import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/debouncer.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/view/components/number_input.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import 'package:xtridelink_driver/view/cubit/wallet/index.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/button.dart';

class NegotiationRateSheet extends StatefulWidget {
  const NegotiationRateSheet({super.key});

  @override
  State<NegotiationRateSheet> createState() => _NegotiationRateSheetState();
}

class _NegotiationRateSheetState extends State<NegotiationRateSheet> {
  late FocusNode upRateNode;
  late TextEditingController upRateController;
  late FocusNode downRateNode;
  late TextEditingController downRateController;
  final _debouncer1 = Debouncer();
  final _debouncer2 = Debouncer();

  @override
  void initState() {
    final riderAnalytics = context.read<ProfileCubit>().state.riderAnalytics;
    upRateNode = FocusNode();
    upRateController = TextEditingController(
        text: (riderAnalytics?.upNegotiationRate ?? 0).toString());
    downRateNode = FocusNode();
    downRateController = TextEditingController(
        text: (riderAnalytics?.downNegotiationRate ?? 0).toString());

    upRateNode.addListener(() => setState(() {}));
    downRateNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    upRateController.dispose();
    upRateNode.dispose();
    downRateController.dispose();
    downRateNode.dispose();
    _debouncer1.reset();
    _debouncer2.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Set negotiation rate',
            style: AppTextStyles.mediumText(fontSize: 20)),
        HelperFunc.sb(5.h),
        Text('Adjust the range which users can negotiate with',
                style: AppTextStyles.regularText(
                    fontSize: 13, color: AppColors.grey))
            .pd(EdgeInsets.only(right: 50.w)),
        HelperFunc.sb(30.h),
        Text('Up Rate (%)', style: AppTextStyles.mediumText(fontSize: 12)),
        HelperFunc.sb(10.h),
        NumberInput(
            focusNode: upRateNode,
            validator: (v) {
              if (num.tryParse(v ?? '') == null) {
                return 'Please enter a valid number';
              } else if ((num.tryParse(v ?? '') ?? 0) >= 100) {
                return 'Up rate must be less than 100%';
              } else if ((num.tryParse(v ?? '') ?? 0) <=
                  (num.tryParse(downRateController.text) ?? 0)) {
                return 'Up rate must be greater than down rate';
              }
              return null;
            },
            controller: upRateController,
            hintText: 'Up Rate (%)'),
        HelperFunc.sb(20.h),
        Text('Down Rate (%)', style: AppTextStyles.mediumText(fontSize: 12)),
        HelperFunc.sb(10.h),
        NumberInput(
            focusNode: downRateNode,
            validator: (v) {
              if (num.tryParse(v ?? '') == null) {
                return 'Please enter a valid number';
              } else if ((num.tryParse(v ?? '') ?? 0) <= 0) {
                return 'Down rate must be greater than 0%';
              } else if ((num.tryParse(v ?? '') ?? 0) >=
                  (num.tryParse(upRateController.text) ?? 0)) {
                return 'Down rate must be less than up rate';
              }
              return null;
            },
            controller: downRateController,
            hintText: 'Down Rate (%)'),
        HelperFunc.sb(15.h),
        Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.lightPri,
                borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              children: [
                CircleAvatar(
                    backgroundColor: AppColors.materialColor,
                    radius: 10.r,
                    child: Text('i',
                        style: AppTextStyles.boldText(
                            fontSize: 10, color: Colors.white))),
                HelperFunc.sb(10.w),
                BlocBuilder<WalletCubit, WalletState>(
                    builder: (context, state) {
                  return RichText(
                      text: TextSpan(
                          text: 'Base fare for normal delivery is ',
                          style: AppTextStyles.regularText(
                              fontSize: 12, color: Colors.black),
                          children: [
                        TextSpan(
                            text:
                                'NGN ${state.financialData?.expressBaseAmount.figureSeparator}',
                            style: AppTextStyles.mediumText(
                                fontSize: 12, color: Colors.black)),
                        TextSpan(
                            text: ' and express delivery ',
                            style: AppTextStyles.regularText(
                                fontSize: 12, color: Colors.black)),
                        TextSpan(
                            text:
                                'NGN ${state.financialData?.normalBaseAmount.figureSeparator}',
                            style: AppTextStyles.mediumText(
                                fontSize: 12, color: Colors.black)),
                        // TextSpan(
                        //     text: ' per kilometer.',
                        //     style: AppTextStyles.regularText(
                        //         fontSize: 12, color: Colors.black)),
                        TextSpan(
                            text: '\nUprate',
                            style: AppTextStyles.mediumText(
                                fontSize: 12, color: Colors.black)),
                        TextSpan(
                            text:
                                ' - This is the minimum percentage you can agree to during price negotiations with customers.',
                            style: AppTextStyles.regularText(
                                fontSize: 12, color: Colors.black)),
                        TextSpan(
                            text: '\nDownrate',
                            style: AppTextStyles.mediumText(
                                fontSize: 12, color: Colors.black)),
                        TextSpan(
                            text:
                                ' - This is the maximum percentage you can agree to during price negotiations with customers.',
                            style: AppTextStyles.regularText(
                                fontSize: 12, color: Colors.black)),
                      ])).EXPANDED;
                }),
              ],
            )),
        HelperFunc.sb(35.h),
        ListenableBuilder(
            listenable:
                Listenable.merge([upRateController, downRateController]),
            builder: (context, _) {
              return SafeArea(
                top: false,
                child: AppButton(
                    btnText: 'Set Rate',
                    onTap: (num.tryParse(upRateController.text) ?? 0) >
                                (num.tryParse(downRateController.text) ?? 0) &&
                            (num.tryParse(upRateController.text) ?? 0) < 100 &&
                            (num.tryParse(downRateController.text) ?? 0) > 0
                        ? () => context.read<ProfileCubit>().setNegotiationRate(
                            up: num.tryParse(upRateController.text) ?? 0,
                            down: num.tryParse(downRateController.text) ?? 0)
                        : null,
                    color: (num.tryParse(upRateController.text) ?? 0) >
                                (num.tryParse(downRateController.text) ?? 0) &&
                            (num.tryParse(upRateController.text) ?? 0) < 100 &&
                            (num.tryParse(downRateController.text) ?? 0) > 0
                        ? null
                        : AppColors.grey.withOpacity(.5)),
              );
            }),
        SizedBox(
            height: upRateNode.hasFocus || downRateNode.hasFocus ? 150.h : 0)
      ],
    ).pd(EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h));
  }
}
