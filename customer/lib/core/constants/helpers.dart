import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/view/components/back_button.dart';

class HelperFunc {
  HelperFunc._();

  static SizedBox sb(double value) => SizedBox(height: value, width: value);

  static DateFormat get dateFormat => DateFormat('MMM dd, yyyy');

  static DateFormat get timeFormat => DateFormat.jm();

  static void showLoader() {
    AlertDialog alert = AlertDialog(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CupertinoActivityIndicator(),
          SizedBox(width: 10.w),
          const Text('Loading...'),
        ],
      ),
    );
    showCupertinoDialog(
      barrierDismissible: false,
      context: buildContext,
      builder: (context) {
        return WillPopScope(onWillPop: () async => true, child: alert);
      },
    );
  }

  static void toast(String message) => Fluttertoast.showToast(msg: message);

  static void logger(String msg) => log(msg);

  static void copyToClipboard(String text, {String? toastMsg}) {
    Clipboard.setData(ClipboardData(text: text));
    toast(toastMsg ?? 'Copied to clipboard');
  }

  static void showCustomBottomSheet(
      {required BuildContext context,
      double? height,
      EdgeInsetsGeometry? padding,
      bool showBackButton = true,
      bool isScrollControlled = true,
      required Widget child}) async {
    await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: isScrollControlled,
        builder: (BuildContext context) {
          return Container(
            padding: padding ?? EdgeInsets.fromLTRB(0, 15.h, 0, 0),
            height: height ?? (MediaQuery.of(context).size.height * 0.94),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (showBackButton) const AppBackButton(),
              Expanded(child: child.pd(EdgeInsets.symmetric(horizontal: 20.w)))
            ]),
          );
        });
  }

  static Future<File?> pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      if (File(image.path).lengthSync() >= (2 * 1024 * 1024)) {
        toast('File size should be less than 3MB');
        return null;
      }
      return File(image.path);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static void makePhoneCall(String phoneNumber) async {
    Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  static void showFittedBottomSheet(
      {required BuildContext context,
      EdgeInsetsGeometry? padding,
      bool showBackButton = true,
      bool isDismissible = true,
      required Widget child}) async {
    await showModalBottomSheet(
        isDismissible: isDismissible,
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: padding ?? EdgeInsets.fromLTRB(0, 15.h, 0, 10.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(40.r))),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [if (showBackButton) const AppBackButton(), child]),
          );
        });
  }

  static Future<void> pickDate(
      {required BuildContext context,
      DateTime? initialDate,
      DateTime? lastDate,
      DateTime? firstDate,
      void Function(DateTime?)? onChanged,
      required ValueNotifier<DateTime?> dateValue}) async {
    if (Platform.isAndroid) {
      dateValue.value = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: firstDate ?? DateTime.now(),
          lastDate: lastDate ?? DateTime(2100));
      if (onChanged != null) {
        onChanged(dateValue.value);
      }
    } else {
      showCupertinoModalPopup(
          context: context,
          builder: (_) => Container(
                height: 300,
                padding: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          minimumDate: firstDate ?? DateTime.now(),
                          maximumDate: DateTime(2100),
                          initialDateTime: initialDate,
                          minimumYear: (firstDate ?? DateTime.now()).year,
                          maximumYear: lastDate?.year,
                          onDateTimeChanged: (newDate) {
                            dateValue.value = newDate;
                            if (onChanged != null) {
                              onChanged(newDate);
                            }
                          }),
                    ),
                    CupertinoButton(
                        child: const Text('OK',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.materialColor)),
                        onPressed: () {
                          globalPop();
                        })
                  ],
                ),
              ));
    }
  }

  static void showPopUpDialog(
      {required BuildContext context,
      required Widget child,
      EdgeInsetsGeometry? padding,
      double? size,
      AlignmentGeometry alignment = Alignment.center,
      bool barrierDismissible = true}) async {
    await showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return Align(
            alignment: alignment,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.r))),
              // insetPadding:
              // EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.widthAdjusted),
              child: Container(
                height: size,
                width: size,
                padding: padding ?? EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white),
                child: child,
              ),
            ),
          );
        });
  }

  static void showFittedPopUp(
      {required BuildContext context,
      required Widget child,
      EdgeInsetsGeometry? padding,
      EdgeInsets? insetPadding,
      AlignmentGeometry alignment = Alignment.center,
      bool barrierDismissible = true}) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Align(
          alignment: alignment,
          child: Dialog(
            insetPadding:
                insetPadding ?? EdgeInsets.symmetric(horizontal: 20.w),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
            child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
          ),
        );
      },
    );
  }
}
