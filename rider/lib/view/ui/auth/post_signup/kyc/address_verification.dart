import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/enumerations.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/view/components/back_button.dart';
import 'package:xtridelink_driver/view/ui/auth/post_signup/kyc/id_verification.dart';
import '../../../../cubit/profile/index.dart';
import 'vehicle_details.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/navigation/index.dart';
import '../../../../../core/services/navigation/routes.dart';
import '../../../../components/button.dart';

class AddressVerificationForm {
  String addressVerifyDoc;
  AddressVerifyType? addressVerifyType;
  AddressVerificationForm({this.addressVerifyDoc = '', this.addressVerifyType});

  bool get isValid => addressVerifyDoc.isNotEmpty && addressVerifyType != null;

  AddressVerificationForm copyWith(
          {String? idNumber,
          String? addressVerifyDoc,
          AddressVerifyType? addressVerifyType}) =>
      AddressVerificationForm(
          addressVerifyDoc: addressVerifyDoc ?? this.addressVerifyDoc,
          addressVerifyType: addressVerifyType ?? this.addressVerifyType);
}

class AddressVerificationPage extends StatefulWidget {
  final bool fromSignUp;
  const AddressVerificationPage({super.key, required this.fromSignUp});

  @override
  State<AddressVerificationPage> createState() =>
      _AddressVerificationPageState();
}

class _AddressVerificationPageState extends State<AddressVerificationPage> {
  late ValueNotifier<AddressVerificationForm> addressVerifyForm;

  @override
  void initState() {
    addressVerifyForm = ValueNotifier(AddressVerificationForm());
    super.initState();
  }

  @override
  void dispose() {
    addressVerifyForm.dispose();
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
                          backgroundColor: index == 2
                              ? AppColors.secColor
                              : AppColors.grey.withOpacity(0.3),
                        ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
            HelperFunc.sb(15.w)
          ]),
          SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Address verification',
                      style: AppTextStyles.mediumText(fontSize: 20))
                  .pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(10.h),
              Text('You will provide a valid identification document',
                      style: AppTextStyles.regularText(
                          fontSize: 13, color: AppColors.grey))
                  .pd(EdgeInsets.only(right: 50.w, left: 20.w)),
              HelperFunc.sb(25.h),
              ChooseAddressVerifyType(idForm: addressVerifyForm),
              HelperFunc.sb(20.h),
              Text('Upload Document',
                      style: AppTextStyles.mediumText(fontSize: 12))
                  .pd(EdgeInsets.only(left: 20.w)),
              HelperFunc.sb(10.h),
              UploadDocumentContainer(
                onTap: (url) => addressVerifyForm.value =
                    addressVerifyForm.value.copyWith(addressVerifyDoc: url),
              ).pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(20.h),
              RichText(
                  text: TextSpan(
                      text: 'NB. ',
                      style: AppTextStyles.mediumText(
                          fontSize: 12, color: AppColors.materialColor),
                      children: [
                    TextSpan(
                        text:
                            'Ensure the ID is still valid, and your face is clearly visible for easy identification.',
                        style: AppTextStyles.regularText(
                            fontSize: 12, color: AppColors.grey))
                  ])).pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(20.h),
            ],
          )).EXPANDED,
          ValueListenableBuilder(
              valueListenable: addressVerifyForm,
              builder: (context, value, _) {
                return AppButton(
                        btnText: 'Continue',
                        onTap: value.isValid
                            ? () => context
                                .read<ProfileCubit>()
                                .addAddressInformation(
                                    addressVerificationType:
                                        value
                                            .addressVerifyType!
                                            .toString()
                                            .split('.')
                                            .last,
                                    addressVerificationDoc:
                                        value.addressVerifyDoc,
                                    onSuccess: () => globalNavigateTo(
                                        route: Routes.kycDocumentSubmitted,
                                        arguments: widget.fromSignUp))
                            : null,
                        color: value.isValid
                            ? null
                            : AppColors.grey.withOpacity(.5))
                    .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h));
              }),
        ],
      )),
    );
  }
}

class ChooseAddressVerifyType extends StatelessWidget {
  final ValueNotifier<AddressVerificationForm> idForm;
  const ChooseAddressVerifyType({super.key, required this.idForm});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: idForm,
        builder: (context, value, _) {
          return GestureDetector(
            onTap: () => HelperFunc.showFittedBottomSheet(
                context: context,
                child: SafeArea(
                    child: Column(
                  children: AddressVerifyType.values
                      .map((e) => TextButton(
                          onPressed: () {
                            idForm.value =
                                idForm.value.copyWith(addressVerifyType: e);
                            globalPop();
                          },
                          child: SizedBox(
                              width: double.infinity,
                              child: Text(e.name,
                                  style: AppTextStyles.mediumText(
                                      color: Colors.black)))))
                      .toList(),
                ).pd(EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h)))),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.secColor),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(children: [
                Text(
                        value.addressVerifyType?.name ??
                            'Select Verification Type',
                        style: AppTextStyles.mediumText(fontSize: 12))
                    .EXPANDED,
                const Icon(Icons.keyboard_arrow_down)
              ]),
            ),
          );
        });
  }
}
