import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/debouncer.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/domain/params/order/order_params.dart';
import 'package:xtridelink/view/components/phone_input.dart';
import 'package:xtridelink/view/cubit/profile/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import 'package:xtridelink/view/ui/dashboard/profile/cubit/profile_cubit.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';
import '../../../../components/form_field.dart';

class RecipientDetailsForm {
  String? name, email, phoneNo, comment;
  RecipientDetailsForm({this.name, this.email, this.phoneNo, this.comment});

  bool get isValid =>
      (name ?? '').isNotEmpty &&
      // (email ?? '').isValidEmail &&
      // (comment ?? '').isNotEmpty &&
      (phoneNo ?? '').isNotEmpty;

  RecipientDetailsForm copyWith(
          {String? name, String? email, String? phoneNo, String? comment}) =>
      RecipientDetailsForm(
          name: name ?? this.name,
          email: email ?? this.email,
          phoneNo: phoneNo ?? this.phoneNo,
          comment: comment ?? this.comment);
}

class ProvideRecipientDet extends StatefulWidget {
  final OrderParams order;
  const ProvideRecipientDet({super.key, required this.order});

  @override
  State<ProvideRecipientDet> createState() => _ProvideRecipientDetState();
}

class _ProvideRecipientDetState extends State<ProvideRecipientDet> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNoController;
  late TextEditingController commentController;
  late ValueNotifier<RecipientDetailsForm> isFormValid;
  String? countryCode;
  final _debouncer = Debouncer(interval: const Duration(seconds: 1));

  @override
  void initState() {
    final userData = context.read<ProfileCubit>().state.currentUser();
    fullNameController = TextEditingController(
        text: widget.order.recipientName ??
            (widget.order.orderType == OrderType.recieve
                ? '${userData?.lastName ?? ''} ${userData?.firstName ?? ''}'
                : null));
    emailController = TextEditingController(
        text: widget.order.recipientEmail ??
            (widget.order.orderType == OrderType.recieve
                ? userData?.email
                : null));
    phoneNoController = TextEditingController(
        text: widget.order.recipientPhone
                ?.replaceAll('234', '')
                .replaceAll('+', '') ??
            (widget.order.orderType == OrderType.recieve
                ? userData?.phone?.replaceAll('234', '').replaceAll('+', '')
                : null));
    countryCode = '+234';
    commentController = TextEditingController(text: widget.order.deliveryNotes);
    isFormValid = ValueNotifier(widget.order.recipientName != null
        ? RecipientDetailsForm(
            name: widget.order.recipientName,
            email: widget.order.recipientEmail,
            phoneNo: widget.order.recipientPhone,
            comment: widget.order.deliveryNotes)
        : widget.order.orderType == OrderType.recieve
            ? RecipientDetailsForm(
                name:
                    '${userData?.lastName ?? ''} ${userData?.firstName ?? ''}',
                email: userData?.email,
                phoneNo: userData?.phone)
            : RecipientDetailsForm());
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneNoController.dispose();
    commentController.dispose();
    _debouncer.reset();
    isFormValid.dispose();
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
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recipient details',
                  style: AppTextStyles.mediumText(fontSize: 20)),
              HelperFunc.sb(10.h),
              Text('Provide the recipient details below',
                      style: AppTextStyles.regularText(
                          fontSize: 13, color: AppColors.grey))
                  .pd(EdgeInsets.only(right: 50.w)),
              HelperFunc.sb(25.h),
              AppFormField(
                  onChanged: (v) => _debouncer(() => isFormValid.value =
                      RecipientDetailsForm(
                          name: v,
                          email: emailController.text,
                          phoneNo: phoneNoController.text,
                          comment: commentController.text)),
                  hintText: 'Full Name',
                  labelText: 'Full Name',
                  controller: fullNameController,
                  keyBoardType: TextInputType.text),
              HelperFunc.sb(15.h),
              AppFormField(
                  onChanged: (v) => _debouncer(() => isFormValid.value =
                      RecipientDetailsForm(
                          name: fullNameController.text,
                          email: v,
                          phoneNo: phoneNoController.text,
                          comment: commentController.text)),
                  hintText: 'Email Address (Optional)',
                  labelText: 'Email Address (Optional)',
                  controller: emailController,
                  validator: (v) {
                    if (v!.isNotEmpty && !v.isValidEmail) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  keyBoardType: TextInputType.emailAddress),
              HelperFunc.sb(15.h),
              CustomPhoneInput(
                  controller: phoneNoController,
                  dialCode: countryCode,
                  onInputChanged: (v) => _debouncer(() {
                        countryCode = v.dialCode;
                        isFormValid.value = RecipientDetailsForm(
                            name: fullNameController.text,
                            email: emailController.text,
                            phoneNo: v.phoneNumber,
                            comment: commentController.text);
                      })),
              HelperFunc.sb(15.h),
              AppFormField(
                  onChanged: (v) => _debouncer(() => isFormValid.value =
                      RecipientDetailsForm(
                          name: fullNameController.text,
                          email: emailController.text,
                          phoneNo: phoneNoController.text,
                          comment: v)),
                  // hintText: 'Comment (Optional)',
                  hintText: 'Comment (Optional)',
                  labelText: 'Comment',
                  maxLines: 4,
                  validator: (v) => null,
                  controller: commentController)
            ],
          ).pd(EdgeInsets.all(15.w)))),
          ValueListenableBuilder(
              valueListenable: isFormValid,
              builder: (context, value, _) {
                return AppButton(
                        onTap: value.isValid
                            ? () => context.read<OrdersCubit>().addEditRecipient(
                                name: fullNameController.text,
                                email: emailController.text,
                                phone:
                                    '$countryCode${phoneNoController.text.replaceAll(' ', '')}',
                                comment: commentController.text)
                            : null,
                        btnText: 'Continue',
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
