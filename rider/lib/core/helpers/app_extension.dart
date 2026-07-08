import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

extension WidgetSpacing on num {
  SizedBox get vSpaceBox => SizedBox(height: toDouble());
  SizedBox get hSpaceBox => SizedBox(width: toDouble());
}

extension MoneyFormatter on num {
  String formatAmount() {
    final currencyFormat = NumberFormat.currency(name: '₦');

    return currencyFormat.format(this);
  }
}
