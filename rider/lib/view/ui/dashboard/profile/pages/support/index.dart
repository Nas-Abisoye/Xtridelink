import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/view/components/button.dart';
import 'package:xtridelink_driver/view/components/form_field.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import '../../../../../../core/constants/assets.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../components/back_button.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  late TextEditingController titleController;
  late TextEditingController messageController;

  @override
  void initState() {
    titleController = TextEditingController();
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBackButton(),
          Text('Support', style: AppTextStyles.mediumText(fontSize: 21))
              .pd(EdgeInsets.only(left: 20.w)),
          HelperFunc.sb(5.h),
          Text('Reach out to us with your complaints',
                  style: AppTextStyles.regularText(
                      fontSize: 13, color: AppColors.grey))
              .pd(EdgeInsets.only(right: 50.w, left: 20.w)),
          Expanded(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HelperFunc.sb(20.h),
                      AppFormField(
                          hintText: 'Subject',
                          controller: titleController,
                          keyBoardType: TextInputType.text),
                      HelperFunc.sb(15.h),
                      AppFormField(
                          hintText: 'How can we help?',
                          controller: messageController,
                          maxLines: 4,
                          keyBoardType: TextInputType.text),
                      HelperFunc.sb(50.h),
                      ListenableBuilder(
                          listenable: Listenable.merge(
                              [titleController, messageController]),
                          builder: (context, _) {
                            return AppButton(
                                onTap: titleController.text.length < 3 ||
                                        messageController.text.length < 3
                                    ? null
                                    : () => context
                                        .read<ProfileCubit>()
                                        .contactSupport(
                                            subject: titleController.text,
                                            message: messageController.text),
                                color: titleController.text.length < 3 ||
                                        messageController.text.length < 3
                                    ? AppColors.grey.withOpacity(.6)
                                    : AppColors.secColor,
                                btnText: 'Submit');
                          }),
                      HelperFunc.sb(40.h),
                      Text('Contact us',
                          style: AppTextStyles.mediumText(fontSize: 16)),
                      HelperFunc.sb(15.h),
                      Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phone Number',
                                  style: AppTextStyles.regularText(
                                      fontSize: 12, color: AppColors.grey)),
                              HelperFunc.sb(5.h),
                              Text('+234(0)81 234 5687',
                                  style: AppTextStyles.mediumText(fontSize: 14))
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () =>
                                HelperFunc.copyToClipboard('+234812345687'),
                            icon: SvgPicture.asset(Assets.copy)),
                      ])
                    ])),
          ),
          HelperFunc.sb(10.h)
        ],
      )),
    );
  }
}
