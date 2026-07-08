// ignore_for_file: only_throw_errors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtridelink_driver/core/theme/app_colors.dart';
import 'package:xtridelink_driver/core/theme/app_textstyle.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xtridelink_driver/data/source/remote/model/auth/get_user_details_response.dart';
import 'package:xtridelink_driver/domain/repository/authentication_repository.dart';
import 'package:xtridelink_driver/injector.dart';

class AppHelper {
  AppHelper._();

  static showAppModal(BuildContext context, Widget widget,
      [Color? backgroundColor]) {
    showModalBottomSheet(
        context: context,
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        builder: ((context) => widget));
  }

  static Future<T?> showAppDialog<T>(
    BuildContext context,
    Widget widget, {
    double height = 387,
    double width = 335,
    bool barrierDismissible = false,
  }) {
    return showDialog<T>(
      barrierColor: AppColors.black.withOpacity(0.8),
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16)),
          height: height,
          width: width,
          child: Builder(
            builder: (context) {
              return widget;
            },
          ),
        ),
      ),
    );
  }

  static void showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      content: Text(
        message,
        style: AppTextStyle.body2.copyWith(color: Colors.white),
      ),
      // action: SnackBarAction(
      //   label: 'Close',
      //   disabledTextColor: AppColors.black,
      //   textColor: AppColors.black,
      //   onPressed: () {
      //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //   },
      // ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void copyToClipboard(BuildContext context, String value) {
    Clipboard.setData(
      ClipboardData(
        text: value,
      ),
    ).then((_) {
      showSnackBar(context, message: 'Copied to clipboard');
    });
  }

  static void showNoConnectionSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: Color.fromARGB(255, 99, 240, 104),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      content: Text(
        'No internet connection',
        style: AppTextStyle.body2.copyWith(color: Colors.white),
      ),
      action: SnackBarAction(
        label: 'Close',
        disabledTextColor: AppColors.black,
        textColor: AppColors.black,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<T?> showCustomModalBottomSheet<T>({
    required BuildContext context,
    required Widget modal,
    required bool isDarkMode,
    double radius = 16,
    bool isDrag = true,
    bool isDismissible = true,
    double paddingTop = 100,
  }) {
    return showModalBottomSheet<T>(
      isDismissible: isDismissible,
      enableDrag: isDrag,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - paddingTop,
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => modal,
    );
  }

  static void showAlertDialog({
    required BuildContext context,
    required Widget child,
    double radius = 16,
  }) {
    final alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      contentPadding: EdgeInsets.all(20),
      iconPadding: EdgeInsets.zero,
      content: child,
    );

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static String? getAppName() {
    return 'xtridelink_driver';
  }

  static RegExp get getPhoneNumberRegex =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,8}\$');

  static RegExp get getBillNumberRegex => RegExp(r'(^(?:[+0]9)?[0-9]{5,19}$)');

  static RegExp get getBetNumberRegex => RegExp(r'(^(?:[+0]9)?[0-9]{8,10}$)');

  static Future<void> launchHttp(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> sendMail(String address) async {
    if (!await launchUrl(Uri.parse('mailto:$address'))) {
      throw 'Could not launch $address';
    }
  }

  static String cleanAmountString(String value) {
    // check for comma as decimal separator
    final regExp = RegExp(r',[\d]{1,2}$');
    var newValue = value;
    if (regExp.hasMatch(value)) {
      newValue = value.replaceAll('.', '');
      newValue = value.replaceAll(',', '.');
    }

    newValue = value.replaceAll(RegExp(r'[^0-9\.\-]'), '');
    return newValue;
  }

  static double? parseDouble(String value, {bool zeroIsNull = false}) {
    // check for comma as decimal separator
    final regExp = RegExp(r',[\d]{1,2}$');
    var newValue = value;
    if (regExp.hasMatch(value)) {
      newValue = value.replaceAll('.', '');
      newValue = value.replaceAll(',', '.');
    }

    newValue = value.replaceAll(RegExp(r'[^0-9\.\-]'), '');

    final doubleValue = double.tryParse(newValue) ?? 0.0;

    return (doubleValue == 0 && zeroIsNull) ? null : doubleValue;
  }

  static UserAccountData? getUserDetails() =>
      getIt<AuthenticationRepository>().getUserAccountDetails();

  static double getHeightPagePercentage(BuildContext context, double value) {
    return MediaQuery.of(context).size.height * value;
  }

  static double getWidthPercentage(BuildContext context, double value) {
    return MediaQuery.of(context).size.height * value;
  }
}
