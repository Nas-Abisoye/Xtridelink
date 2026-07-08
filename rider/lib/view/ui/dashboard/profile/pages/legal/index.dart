import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/enumerations.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../components/back_button.dart';

class LegalPage extends StatelessWidget {
  final XtridelinkDocsType docsType;
  const LegalPage({super.key, required this.docsType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              Text(docsType.name, style: AppTextStyles.mediumText(fontSize: 21))
                  .pd(EdgeInsets.only(left: 20.w)),
              HelperFunc.sb(5.h),
              Text('Our terms & condition of operations',
                      style: AppTextStyles.regularText(
                          fontSize: 13, color: AppColors.grey))
                  .pd(EdgeInsets.only(right: 50.w, left: 20.w)),
              Expanded(
                child: ListView.builder(
                    itemCount: GlobalStrings.legal.length,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(GlobalStrings.legal[index].question,
                                  style: AppTextStyles.mediumText()),
                              HelperFunc.sb(7.h),
                              Text(GlobalStrings.legal[index].answer,
                                  style: AppTextStyles.regularText()),
                            ])),
              ),
            ],
          )),
    );
  }
}
