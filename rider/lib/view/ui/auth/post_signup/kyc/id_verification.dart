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

class IdVerificationForm {
  String idNumber, idDoc;
  IdType? idType;
  IdVerificationForm({this.idNumber = '', this.idDoc = '', this.idType});

  bool get isValid => idNumber.isNotEmpty && idDoc.isNotEmpty && idType != null;

  IdVerificationForm copyWith(
          {String? idNumber, String? idDoc, IdType? idType}) =>
      IdVerificationForm(
          idDoc: idDoc ?? this.idDoc,
          idNumber: idNumber ?? this.idNumber,
          idType: idType ?? this.idType);
}

class IdVerificationPage extends StatefulWidget {
  final bool fromSignUp;
  const IdVerificationPage({super.key, required this.fromSignUp});

  @override
  State<IdVerificationPage> createState() => _IdVerificationPageState();
}

class _IdVerificationPageState extends State<IdVerificationPage> {
  late ValueNotifier<IdVerificationForm> idForm;
  late TextEditingController idNumberController;
  final _debouncer = Debouncer();

  @override
  void initState() {
    idForm = ValueNotifier(IdVerificationForm());
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
                              : AppColors.grey.withOpacity(0.3),
                        ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
            HelperFunc.sb(15.w)
          ]),
          SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID Verification',
                      style: AppTextStyles.mediumText(fontSize: 20))
                  .pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(10.h),
              Text('You will provide a valid identification document.',
                      style: AppTextStyles.regularText(
                          fontSize: 13, color: AppColors.grey))
                  .pd(EdgeInsets.only(right: 50.w, left: 20.w)),
              HelperFunc.sb(25.h),
              ChooseIdType(idForm: idForm),
              HelperFunc.sb(15.h),
              AppFormField(
                  hintText: 'ID Number',
                  controller: idNumberController,
                  keyBoardType: TextInputType.text,
                  onChanged: (v) => _debouncer(
                      () => idForm.value = idForm.value.copyWith(idNumber: v)),
                  validator: (v) =>
                      null).pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(20.h),
              Text('Upload ID', style: AppTextStyles.mediumText(fontSize: 12))
                  .pd(EdgeInsets.only(left: 20.w)),
              HelperFunc.sb(10.h),
              UploadDocumentContainer(
                onTap: (url) =>
                    idForm.value = idForm.value.copyWith(idDoc: url),
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
              valueListenable: idForm,
              builder: (context, value, _) {
                return AppButton(
                        btnText: 'Continue',
                        onTap: value.isValid
                            ? () => context
                                .read<ProfileCubit>()
                                .addIdInformation(
                                    idVerificationType: value.idType!
                                        .toString()
                                        .split('.')
                                        .last,
                                    idVerificationDoc: value.idDoc,
                                    idVerificationNumber: value.idNumber,
                                    onSuccess: () => globalNavigateTo(
                                        route: Routes.bvnVerification,
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

class ChooseIdType extends StatelessWidget {
  final ValueNotifier<IdVerificationForm> idForm;
  const ChooseIdType({super.key, required this.idForm});

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
                  children: IdType.values
                      .map((e) => TextButton(
                          onPressed: () {
                            idForm.value = idForm.value.copyWith(idType: e);
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
                Text(value.idType?.name ?? 'Select ID Type',
                        style: AppTextStyles.mediumText(fontSize: 12))
                    .EXPANDED,
                const Icon(
                  Icons.keyboard_arrow_down,
                )
              ]),
            ),
          );
        });
  }
}
