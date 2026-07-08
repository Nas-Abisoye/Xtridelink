// ignore_for_file: sort_constructors_first

import 'package:formz/formz.dart';

enum PhoneInputValidationError {
  empty('This field cannot be empty'),
  invalid('Enter a valid phone number');

  final String message;

  const PhoneInputValidationError(this.message);
}

class PhoneInput extends FormzInput<String, PhoneInputValidationError> {
  // Call super.pure to represent an unmodified form input.
  const PhoneInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const PhoneInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _phoneRegExp = RegExp(
    '[0-9]{10}',
  );

  // Override validator to handle validating a given input value.
  @override
  PhoneInputValidationError? validator(String? value) {
    if (value == null) return PhoneInputValidationError.empty;
    if (value.isEmpty) return PhoneInputValidationError.empty;
    if (!_phoneRegExp.hasMatch(value)) return PhoneInputValidationError.invalid;
    return null;
  }
}
