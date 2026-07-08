import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/enumerations.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/constants/strings.dart';

import 'assets.dart';

extension StringExtension on String {
  double toDouble() => double.parse(this);

  DateTime toDateTime() => DateTime.parse(this);

  String toOrderIdTag() {
    return 'Order #${substring(0, 6)}';
  }

  String get capitalizeFirstLetter {
    return isEmpty
        ? ''
        : '${this[0].toUpperCase()}${length < 2 ? '' : substring(1).toLowerCase()}';
  }

  String addCurrency(String currency) {
    return currency.toUpperCase().contains(GlobalStrings.capitalNGN) ||
            currency.contains(GlobalStrings.naira)
        ? GlobalStrings.naira + this
        : '\$$this';
  }

  String get firstLetter => isEmpty ? '' : this[0].toUpperCase();

  bool get isValidEmail =>
      RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\'
              r's@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.'
              r'[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.'
              r')+[a-zA-Z]{2,}))$')
          .hasMatch(this);

  RiderOrderStage get orderStage => switch (this) {
        'packagePicking' => RiderOrderStage.packagePicking,
        'packagePickedup' => RiderOrderStage.packagePickedup,
        'packageOnTransit' => RiderOrderStage.packageOnTransit,
        'packageDelivered' => RiderOrderStage.packageDelivered,
        _ => RiderOrderStage.packagePicking,
      };
}

extension Formatter on num {
  String get formatCurrency {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return '${myFormat.simpleCurrencySymbol(GlobalStrings.capitalNGN)}'
        '${myFormat.format(this)}';
  }

  String get figureSeparator {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return myFormat.format(this);
  }
}

extension WidgetExtension on Widget {
  Widget pd(EdgeInsetsGeometry padding) =>
      Padding(padding: padding, child: this);
  Widget align(AlignmentGeometry alignment) =>
      Align(alignment: alignment, child: this);
  Widget get EXPANDED => Expanded(child: this);
  Widget get SINGLECHILDSCROLLVIEW => SingleChildScrollView(child: this);
}

extension xtridelink_driverDocsExtension on XtridelinkDocsType {
  String get name => switch (this) {
        XtridelinkDocsType.legal => 'Legal',
        XtridelinkDocsType.terms => 'Terms of Service',
        XtridelinkDocsType.privacy => 'Privacy Policy'
      };
}

extension PackageExtension on PackageType {
  String get asset => switch (this) {
        PackageType.parcel => Assets.parcel,
        PackageType.groceries => Assets.groceries,
        PackageType.general => Assets.general
      };

  Color get color => switch (this) {
        PackageType.parcel => AppColors.lightSec,
        PackageType.groceries => AppColors.lightPri,
        PackageType.general => AppColors.lightSec
      };
}

extension VehicleExtension on VehicleType {
  String get asset => switch (this) {
        VehicleType.bicycle => Assets.bicycle,
        VehicleType.motorcycle => Assets.motorcycle,
        VehicleType.car => Assets.car,
        VehicleType.truck => Assets.truck,
        VehicleType.van => Assets.truck,
      };
}

extension OrderStateExtension on OrderState {
  String get name => switch (this) {
        OrderState.pending => 'Pending',
        OrderState.onTransit => 'On Transit',
        OrderState.delivered => 'Delivered',
        OrderState.cancelled => 'Cancelled'
      };

  Color get color => switch (this) {
        OrderState.pending => AppColors.yellow,
        OrderState.onTransit => AppColors.secColor,
        OrderState.delivered => AppColors.green,
        OrderState.cancelled => AppColors.materialColor
      };
}

extension IdTypeExtension on IdType {
  String get name => switch (this) {
        IdType.drivers_license => 'Drivers License',
        IdType.passport => 'Passport',
        // IdType.national_id => 'NIN'
      };
}

extension AddressVerifyExtension on AddressVerifyType {
  String get name => switch (this) {
        AddressVerifyType.utility_bill => 'Utility bill',
        AddressVerifyType.lease_agreement => 'Lease agreement',
        AddressVerifyType.bank_statement => 'Bank statement',
      };
}

extension HistoryTypeExtension on HistoryType {
  Color get color => switch (this) {
        HistoryType.delivered => AppColors.green,
        HistoryType.cancelled => AppColors.red
      };

  String get apiTxt => switch (this) {
        HistoryType.delivered => 'completed',
        HistoryType.cancelled => 'canceled'
      };
}

extension DateTimeFormat on DateTime {
  bool isSameDay(DateTime? date) {
    return year == date?.year && month == date?.month && day == date?.day;
  }

  String get timeAgo {
    if (isSameDay(DateTime.now())) {
      return HelperFunc.timeFormat.format(this).toLowerCase();
    } else if (isSameDay(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return HelperFunc.dateFormat.format(this);
    }
  }
}
