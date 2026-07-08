import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/strings.dart';

import 'old_assets.dart';
import 'helpers.dart';

extension StringExtension on String {
  double toDouble() {
    try {
      return double.parse(this);
    } catch (e) {
      return 0.0;
    }
  }

  DateTime toDateTime() {
    return DateTime.parse(this);
  }

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

  OrderState get orderState => switch (toLowerCase()) {
        'pending' => OrderState.pending,
        'ontransit' => OrderState.onTransit,
        'delivered' => OrderState.delivered,
        'cancelled' => OrderState.cancelled,
        _ => OrderState.cancelled
      };

  Rating get rating => switch (toLowerCase()) {
        'zero' => Rating.zero,
        'one' => Rating.one,
        'two' => Rating.two,
        'three' => Rating.three,
        'four' => Rating.four,
        'five' => Rating.five,
        _ => Rating.one
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
        VehicleType.truck => Assets.truck
      };
}

extension OrderStateExtension on OrderState {
  String get name => switch (this) {
        OrderState.pending => 'Pending',
        OrderState.onTransit => 'On Transit',
        OrderState.delivered => 'Delivered',
        OrderState.cancelled => 'Cancelled'
      };

  String get apiTxt => switch (this) {
        OrderState.pending => 'pending',
        OrderState.onTransit => 'ontransit',
        OrderState.delivered => 'delivered',
        OrderState.cancelled => 'canceled'
      };

  Color get color => switch (this) {
        OrderState.pending => AppColors.dullYellow,
        OrderState.onTransit => AppColors.secColor,
        OrderState.delivered => AppColors.green,
        OrderState.cancelled => AppColors.red
      };

  bool get isPending => this == OrderState.pending;
  bool get isOnTransit => this == OrderState.onTransit;
  bool get isDelivered => this == OrderState.delivered;
  bool get isCancelled => this == OrderState.cancelled;
}

extension XtridelinkDocsExtension on XtridelinkDocsType {
  String get name => switch (this) {
        XtridelinkDocsType.legal => 'Legal',
        XtridelinkDocsType.terms => 'Terms of Service',
        XtridelinkDocsType.privacy => 'Privacy Policy'
      };
}

extension DateTimeFormat on DateTime {
  bool isSameDay(DateTime? date) {
    return year == date?.year && month == date?.month && day == date?.day;
  }

  String get timeAgo {
    if (isSameDay(DateTime.now())) {
      return HelperFunc.timeFormat.format(this);
    } else if (isSameDay(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return HelperFunc.dateFormat.format(this);
    }
  }
}

extension GeneralPackageExtension on GeneralPackageTypes {
  String get txt => switch (this) {
        GeneralPackageTypes.clothing => 'Clothings',
        GeneralPackageTypes.electronics => 'Electronics',
        GeneralPackageTypes.jewelleryAccessories => 'Jewellery / Accessories',
        GeneralPackageTypes.documents => 'Documents',
        GeneralPackageTypes.healthProducts => 'Health Products',
        GeneralPackageTypes.computerAccessories => 'Computer Accessories',
        GeneralPackageTypes.phones => 'Phones',
        GeneralPackageTypes.others => 'Others',
        GeneralPackageTypes.frozenFood => 'Frozen Food',
        GeneralPackageTypes.cookedFood => 'Cooked Food',
        GeneralPackageTypes.dryFood => 'Dry Food',
        GeneralPackageTypes.miscellaneous => 'Miscellaneous',
      };
  String get api => switch (this) {
        GeneralPackageTypes.clothing => 'CLOTHINGS',
        GeneralPackageTypes.electronics => 'ELECTRONICS',
        GeneralPackageTypes.jewelleryAccessories => 'JEWELLERY',
        GeneralPackageTypes.documents => 'DOCUMENTS',
        GeneralPackageTypes.healthProducts => 'HEALTH',
        GeneralPackageTypes.computerAccessories => 'COMPUTER_ACCESSORIES',
        GeneralPackageTypes.phones => 'PHONES',
        GeneralPackageTypes.others => 'OTHERS',
        GeneralPackageTypes.frozenFood => 'FROZEN_FOOD',
        GeneralPackageTypes.cookedFood => 'COOKED_FOOD',
        GeneralPackageTypes.dryFood => 'DRY_FOOD',
        GeneralPackageTypes.miscellaneous => 'MISCELLANEOUS',
      };
}
