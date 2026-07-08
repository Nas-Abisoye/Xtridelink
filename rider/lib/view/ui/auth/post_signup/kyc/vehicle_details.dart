import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/enumerations.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/api/file_upload/index.dart';
import 'package:xtridelink_driver/di/get_it.dart';
import 'package:xtridelink_driver/view/components/back_button.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/debouncer.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/navigation/index.dart';
import '../../../../../core/services/navigation/routes.dart';
import '../../../../components/button.dart';
import '../../../../components/form_field.dart';
import '../../../dashboard/order/index.dart';

class VehicleDetailsForm {
  String vehicleName, regNumber, vehiclePaper;
  VehicleType? vehicleType;
  final bool fromSignUp;
  VehicleDetailsForm(
      {this.regNumber = '',
      this.vehiclePaper = '',
      this.vehicleName = '',
      required this.fromSignUp,
      this.vehicleType});

  bool get isValid =>
      regNumber.isNotEmpty &&
      vehicleName.isNotEmpty &&
      vehiclePaper.isNotEmpty &&
      vehicleType != null;

  VehicleDetailsForm copyWith(
          {String? regNumber,
          String? vehicleName,
          String? vehiclePaper,
          VehicleType? vehicleType}) =>
      VehicleDetailsForm(
          fromSignUp: fromSignUp,
          vehicleName: vehicleName ?? this.vehicleName,
          vehiclePaper: vehiclePaper ?? this.vehiclePaper,
          regNumber: regNumber ?? this.regNumber,
          vehicleType: vehicleType ?? this.vehicleType);
}

class VehicleDetailsPage extends StatefulWidget {
  final bool fromSignUp;
  const VehicleDetailsPage({super.key, required this.fromSignUp});

  @override
  State<VehicleDetailsPage> createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  late ValueNotifier<VehicleDetailsForm> vehicleForm;
  late TextEditingController vehicleNameController;
  late TextEditingController regNumberController;
  final _debouncer1 = Debouncer();
  final _debouncer2 = Debouncer();

  @override
  void initState() {
    vehicleForm =
        ValueNotifier(VehicleDetailsForm(fromSignUp: widget.fromSignUp));
    vehicleNameController = TextEditingController();
    regNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    vehicleForm.dispose();
    vehicleNameController.dispose();
    regNumberController.dispose();
    _debouncer1.reset();
    _debouncer2.reset();
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
                          backgroundColor: index == 0
                              ? AppColors.secColor
                              : AppColors.grey.withOpacity(0.3),
                        ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
            HelperFunc.sb(15.w)
          ]),
          SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vehicle details',
                      style: AppTextStyles.mediumText(fontSize: 20))
                  .pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(10.h),
              Text('You will provide the necessary registration documents for you to attest that you own such vehicle.',
                      style: AppTextStyles.regularText(
                          fontSize: 13, color: AppColors.grey))
                  .pd(EdgeInsets.only(right: 50.w, left: 20.w)),
              HelperFunc.sb(25.h),
              ChooseVehicleType(isFormValid: vehicleForm),
              HelperFunc.sb(20.h),
              AppFormField(
                      hintText: 'Vehicle Name',
                      controller: vehicleNameController,
                      keyBoardType: TextInputType.text,
                      onChanged: (v) => _debouncer1(() => vehicleForm.value =
                          vehicleForm.value.copyWith(vehicleName: v)),
                      validator: (v) => null)
                  .pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(15.h),
              AppFormField(
                      hintText: 'Vehicle Registration Number/Invoice Number',
                      controller: regNumberController,
                      keyBoardType: TextInputType.text,
                      onChanged: (v) => _debouncer2(() => vehicleForm.value =
                          vehicleForm.value.copyWith(regNumber: v)),
                      validator: (v) => null)
                  .pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(20.h),
              Text('Upload Vehicle Papers/Receipt',
                      style: AppTextStyles.mediumText(fontSize: 12))
                  .pd(EdgeInsets.only(left: 20.w)),
              HelperFunc.sb(10.h),
              UploadDocumentContainer(
                onTap: (url) => vehicleForm.value =
                    vehicleForm.value.copyWith(vehiclePaper: url),
              ).pd(EdgeInsets.symmetric(horizontal: 20.w)),
              HelperFunc.sb(20.h),
            ],
          )).EXPANDED,
          ValueListenableBuilder(
              valueListenable: vehicleForm,
              builder: (context, value, _) {
                return AppButton(
                        btnText: 'Submit',
                        onTap: value.isValid
                            ? () => context
                                .read<ProfileCubit>()
                                .addVehicleInformation(
                                    vehicleName: value.vehicleName,
                                    vehiclePlateNo: value.regNumber,
                                    vehicleType: value.vehicleType!.name,
                                    vehicleDocument: value.vehiclePaper,
                                    onSuccess: () => globalNavigateTo(
                                        route: Routes.addIdVerification,
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

class ChooseVehicleType extends StatelessWidget {
  final ValueNotifier<VehicleDetailsForm> isFormValid;
  const ChooseVehicleType({super.key, required this.isFormValid});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Vehicle Type',
                style: AppTextStyles.mediumText(fontSize: 12))
            .pd(EdgeInsets.only(left: 20.w)),
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          scrollDirection: Axis.horizontal,
          child: ValueListenableBuilder(
              valueListenable: isFormValid,
              builder: (context, value, _) {
                return Row(
                    children: VehicleType.values
                        .map((e) => OrderOptionsCard(
                                onTap: () {
                                  if (value.vehicleType == e) return;
                                  isFormValid.value =
                                      value.copyWith(vehicleType: e);
                                },
                                avatarColor: value.vehicleType == e
                                    ? Colors.white
                                    : AppColors.ashBg,
                                avatarRadius: 20,
                                txtFont: 12,
                                isSelected: value.vehicleType == e,
                                fillColor: value.vehicleType == e
                                    ? AppColors.secColor
                                    : Colors.white,
                                avatarSvg: e.asset,
                                headerTxt: '${e.name.capitalizeFirstLetter}  ')
                            .pd(EdgeInsets.only(right: 10.w)))
                        .toList());
              }),
        )
      ],
    );
  }
}

class UploadDocumentContainer extends StatefulWidget {
  final void Function(String)? onTap;
  const UploadDocumentContainer({super.key, this.onTap});

  @override
  State<UploadDocumentContainer> createState() =>
      _UploadDocumentContainerState();
}

class _UploadDocumentContainerState extends State<UploadDocumentContainer> {
  late ValueNotifier<String?> url;

  @override
  void initState() {
    url = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: url,
        builder: (context, value, _) {
          return GestureDetector(
            onTap: widget.onTap == null || value != null
                ? null
                : () async {
                    File? file = await HelperFunc.pickFile();
                    if (file == null) return;
                    HelperFunc.showLoader();
                    String? imgUrl = await getItInst<FileUploadServiceImpl>()
                        .uploadImage(image: file);
                    globalPop();
                    if (imgUrl == null) return;
                    url.value = imgUrl;
                    widget.onTap!(imgUrl);
                  },
            child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(8.r),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                color: AppColors.grey.withOpacity(.5),
                dashPattern: const [8, 4],
                child: value == null
                    ? Row(children: [
                        SvgPicture.asset(Assets.upload),
                        HelperFunc.sb(20.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tap to upload a document',
                                style: AppTextStyles.mediumText(fontSize: 12)),
                            HelperFunc.sb(5.h),
                            Text('File type .JPEG or .PDF. Max. file size 2mb.',
                                style: AppTextStyles.regularText(
                                    fontSize: 8, color: AppColors.grey)),
                          ],
                        ).EXPANDED
                      ])
                    : Row(children: [
                        Text(value.split('/').last,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.mediumText(fontSize: 12))
                            .EXPANDED,
                        GestureDetector(
                            onTap: () {
                              url.value = null;
                              if (widget.onTap != null) widget.onTap!('');
                            },
                            child: SvgPicture.asset(Assets.delete))
                      ])),
          );
        });
  }
}
