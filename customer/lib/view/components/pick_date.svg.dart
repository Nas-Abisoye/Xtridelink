import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/constants/text_styles.dart';

class PickDateWidget extends StatefulWidget {
  final void Function(DateTime?)? onDateChanged;
  final String nullDateText;
  final DateTime? firstDate, lastDate, initialDate;
  const PickDateWidget(
      {Key? key,
      this.onDateChanged,
      required this.nullDateText,
      this.firstDate,
      this.lastDate,
      this.initialDate})
      : super(key: key);

  @override
  State<PickDateWidget> createState() => _PickDateWidgetState();
}

class _PickDateWidgetState extends State<PickDateWidget> {
  late ValueNotifier<DateTime?> date;
  @override
  void initState() {
    date = ValueNotifier(widget.initialDate);
    super.initState();
  }

  @override
  void dispose() {
    date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await HelperFunc.pickDate(
            onChanged: widget.onDateChanged,
            dateValue: date,
            context: context,
            initialDate: date.value,
            lastDate: widget.lastDate,
            firstDate: widget.firstDate);
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
          decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(.1),
              borderRadius: BorderRadius.circular(10.r)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ValueListenableBuilder(
                valueListenable: date,
                builder: (context, value, _) {
                  return Text(
                      date.value != null
                          ? DateFormat('d MMMM, y').format(date.value!)
                          : widget.nullDateText,
                      style: AppTextStyles.regularText(
                          color: date.value != null ? null : AppColors.grey));
                }),
            const Icon(Icons.calendar_month_rounded, color: AppColors.grey)
          ])),
    );
  }
}
