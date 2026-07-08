// ignore_for_file: sort_constructors_first

import 'package:formz/formz.dart';
import 'package:xtridelink_driver/core/helpers/input/password_input.dart';

enum ConfirmPasswordInputValidationError {
  empty('This field cannot be empty'),
  notMatch('Password is not a match');

  final String message;

  const ConfirmPasswordInputValidationError(this.message);
}

class ConfirmPasswordInput
    extends FormzInput<String, ConfirmPasswordInputValidationError> {
  // Call super.pure to represent an unmodified form input.
  const ConfirmPasswordInput.pure(this.password) : super.pure('');

  // Call super.dirty to represent a modified form input.
  const ConfirmPasswordInput.dirty(this.password, [super.value = ''])
      : super.dirty();

  final PasswordInput password;

  // Override validator to handle validating a given input value.
  @override
  ConfirmPasswordInputValidationError? validator(String? value) {
    if (value == null) return ConfirmPasswordInputValidationError.empty;
    if (value.isEmpty) return ConfirmPasswordInputValidationError.empty;
    if (password.value != value) {
      return ConfirmPasswordInputValidationError.notMatch;
    }
    return null;
  }
}
