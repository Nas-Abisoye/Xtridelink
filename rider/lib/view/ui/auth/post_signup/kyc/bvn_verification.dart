import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/enumerations.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/view/components/back_button.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import 'vehicle_details.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/debouncer.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/navigation/index.dart';
import '../../../../../core/services/navigation/routes.dart';
import '../../../../components/button.dart';
import '../../../../components/form_field.dart';

class NINVerificationForm {
  String idNumber;

  NINVerificationForm({this.idNumber = ''});

  bool get isValid => idNumber.isNotEmpty;

  NINVerificationForm copyWith(
          {String? idNumber, String? idDoc, IdType? idType}) =>
      NINVerificationForm(
        idNumber: idNumber ?? this.idNumber,
      );
}

class BVNVerificationPage extends StatefulWidget {
  final bool fromSignUp;
  const BVNVerificationPage({super.key, required this.fromSignUp});

  @override
  State<BVNVerificationPage> createState() => _BVNVerificationPageState();
}

class _BVNVerificationPageState extends State<BVNVerificationPage> {
  late ValueNotifier<NINVerificationForm> idForm;
  late TextEditingController idNumberController;
  final _debouncer = Debouncer();

  @override
  void initState() {
    idForm = ValueNotifier(NINVerificationForm());
    idNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    idForm.dispose();
    idNumberController.dispose();
    _debouncer.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(children: [
            const AppBackButton(),
            const Spacer(),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    3,
                    (index) => CircleAvatar(
                          radius: 4.r,
                          backgroundColor: index == 1
                              ? AppColors.secColor
                              : AppColors.grey.withValues(alpha: 0.3),
                        ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
            HelperFunc.sb(15.w)
          ]),
          SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NIN Verification',
                      style: AppTextStyles.mediumText(fontSize: 20))
                  .pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(10.h),
              Text('We need your NIN to approve your wallet creation',
                      style: AppTextStyles.regularText(
                          fontSize: 13, color: AppColors.grey))
                  .pd(EdgeInsets.only(right: 50.w, left: 20.w)),
              HelperFunc.sb(25.h),
              HelperFunc.sb(15.h),
              AppFormField(
                  hintText: 'NIN',
                  controller: idNumberController,
                  keyBoardType: TextInputType.text,
                  onChanged: (v) => _debouncer(
                      () => idForm.value = idForm.value.copyWith(idNumber: v)),
                  validator: (v) =>
                      null).pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(20.h),
              HelperFunc.sb(20.h),
              RichText(
                  text: TextSpan(
                      text: 'NB. ',
                      style: AppTextStyles.mediumText(
                          fontSize: 12, color: AppColors.materialColor),
                      children: [
                    TextSpan(
                        text:
                            'Ensure the details attached to your NIN match the ones you have provided.',
                        style: AppTextStyles.regularText(
                            fontSize: 12, color: AppColors.grey))
                  ])).pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(20.h),
            ],
          )).EXPANDED,
          ValueListenableBuilder(
              valueListenable: idForm,
              builder: (context, value, _) {
                return AppButton(
                        btnText: 'Continue',
                        onTap: value.isValid
                            ? () => context
                                .read<ProfileCubit>()
                                .addNINInformation(
                                    nin: value.idNumber,
                                    onSuccess: () => globalNavigateTo(
                                        route: Routes.addressVerification,
                                        arguments: widget.fromSignUp))
                            : null,
                        color: value.isValid
                            ? null
                            : AppColors.grey.withValues(alpha: .5))
                    .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h));
              }),
        ],
      )),
    );
  }
}
