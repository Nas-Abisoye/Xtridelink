import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/view/components/phone_input.dart';
import 'package:xtridelink/view/components/pick_date.svg.dart';
import 'package:xtridelink/view/cubit/profile/index.dart';
import 'package:xtridelink/view/ui/dashboard/profile/cubit/profile_cubit.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/debouncer.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../components/back_button.dart';
import '../../../../../components/button.dart';
import '../../../../../components/form_field.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneNoController;
  DateTime? date;
  late String email;
  late String? countryCode;
  late ValueNotifier<String?> image;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _debouncer = Debouncer();

  @override
  void initState() {
    final user = context.read<ProfileCubit>().state.currentUser();
    image = ValueNotifier('');
    countryCode = '+234';
    firstNameController = TextEditingController(text: user?.firstName);
    lastNameController = TextEditingController(text: user?.lastName);
    phoneNoController = TextEditingController(
        text: user?.phone?.replaceAll('234', '').replaceAll('+', ''));
    date = user?.dob;
    email = user?.email ?? '';
    super.initState();
  }

  @override
  void dispose() {
    image.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNoController.dispose();
    _debouncer.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              Expanded(
                  child: SingleChildScrollView(
                      child: Form(
                key: _formKey,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Edit Profile',
                            style: AppTextStyles.mediumText(fontSize: 22))),
                    HelperFunc.sb(5.h),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Adjust your personal details',
                                style: AppTextStyles.regularText(
                                    fontSize: 13, color: AppColors.grey))
                            .pd(EdgeInsets.only(right: 50.w))),
                    HelperFunc.sb(15.h),
                    ValueListenableBuilder(
                        valueListenable: image,
                        builder: (context, value, _) => CircleAvatar(
                            radius: 50.r,
                            backgroundColor: AppColors.lightSec,
                            backgroundImage:
                                value == null ? null : NetworkImage(value),
                            child: value == null
                                ? SvgPicture.asset(Assets.person, height: 25.h)
                                : null)),
                    HelperFunc.sb(10.h),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      AppButton(
                          onTap: () async {
                            File? file = await HelperFunc.pickImage();
                            if (file == null) return;
                            if (mounted) {
                              image.value = await context
                                  .read<ProfileCubit>()
                                  .uploadProfileImage(file);
                            }
                          },
                          btnText: 'Change Picture',
                          color: AppColors.grey.withOpacity(.2),
                          txtColor: Colors.black,
                          textFont: 10.5,
                          isPadding: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 7.h))
                    ]),
                    HelperFunc.sb(25.h),
                    AppFormField(
                        hintText: 'First Name',
                        labelText: 'First Name',
                        controller: firstNameController,
                        keyBoardType: TextInputType.name),
                    HelperFunc.sb(15.h),
                    AppFormField(
                        hintText: 'Last Name',
                        labelText: 'Last Name',
                        controller: lastNameController,
                        keyBoardType: TextInputType.name),
                    HelperFunc.sb(15.h),
                    if (email.isNotEmpty)
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 14.h, horizontal: 14.w),
                          decoration: BoxDecoration(
                              color: AppColors.grey.withOpacity(.1),
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Text(email,
                              style: AppTextStyles.regularText(
                                  color: AppColors.grey))),
                    HelperFunc.sb(15.h),
                    CustomPhoneInput(
                        onInputChanged: (v) =>
                            _debouncer(() => countryCode = v.dialCode),
                        controller: phoneNoController),
                    HelperFunc.sb(15.h),
                    PickDateWidget(
                        onDateChanged: (v) => date = v,
                        initialDate: date,
                        nullDateText: 'Date of Birth',
                        firstDate: DateTime(1960),
                        lastDate:
                            DateTime.now().subtract(const Duration(days: 1))),
                    HelperFunc.sb(25.h),
                    AppButton(
                        onTap: () {
                          if (date == null) {
                            HelperFunc.toast('Select your date of birth');
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            context.read<ProfileCubit>().updateUserDetails(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                phoneNumber:
                                    phoneNoController.text.replaceAll(' ', ''),
                                dob: date!,
                                countryCode: countryCode ?? '+234',
                                profileImage: image.value);
                          }
                        },
                        btnText: 'Save Details'),
                  ],
                ).pd(EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)),
              ))),
            ],
          )),
    );
  }
}
