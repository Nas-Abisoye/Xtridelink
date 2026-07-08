import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/strings.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../domain/model/local/faq.dart';
import '../../../../../components/back_button.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              Text('Frequently Asked Questions',
                      style: AppTextStyles.mediumText(fontSize: 21))
                  .pd(EdgeInsets.only(left: 20.w)),
              HelperFunc.sb(5.h),
              Text('Things you need to know about xtridelink_driver',
                      style: AppTextStyles.regularText(
                          fontSize: 13, color: AppColors.grey))
                  .pd(EdgeInsets.only(right: 50.w, left: 20.w)),
              Expanded(
                child: ListView.builder(
                    itemCount: GlobalStrings.faqs.length,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        FaqCard(faq: GlobalStrings.faqs[index])),
              ),
            ],
          )),
    );
  }
}

class FaqCard extends StatefulWidget {
  const FaqCard({Key? key, required this.faq}) : super(key: key);

  final Faq faq;

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isOpen = !isOpen),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border.symmetric(
                horizontal: BorderSide(color: AppColors.ashBg, width: .5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.faq.question,
                        style: AppTextStyles.mediumText(fontSize: 15))
                    .EXPANDED,
                Icon(isOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
            if (isOpen) HelperFunc.sb(7.h),
            if (isOpen)
              Text(
                widget.faq.answer,
                style: AppTextStyles.regularText(
                    fontSize: 12, color: AppColors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
