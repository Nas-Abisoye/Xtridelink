import 'package:flutter/services.dart';

class SeparatorFormatter extends TextInputFormatter {
  final String separator;
  final int interval;
  SeparatorFormatter({this.separator = ',', this.interval = 3}) {
    assert(separator != '');
    assert(interval != 0);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String newValueText = newValue.text.replaceAll(separator, '');

    // Handle "deletion" of separator character
    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    if (oldValue != newValue) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      String preDecimal = newValueText.split('.').first;
      String newText =
          '${List.generate(preDecimal.length, (i) => (preDecimal.length - i - 1) % interval == 0 && (preDecimal.length - i - 1 != 0) ? (preDecimal[i] + separator) : preDecimal[i]).join()}${newValueText.contains('.') ? '.${newValueText.split('.').sublist(1).join()}' : ''}';
      return TextEditingValue(
        text: newText,
        selection:
        TextSelection.collapsed(offset: newText.length - selectionIndex),
      );
    }
    return newValue;
  }
}
