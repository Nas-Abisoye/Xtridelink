import 'package:formz/formz.dart';

enum OtpInputValidationError {
  empty('This field cannot be empty'),
  tooShort('Code is too short');

  final String message;

  const OtpInputValidationError(this.message);
}

class OtpInput extends FormzInput<String, OtpInputValidationError> {
  // Call super.pure to represent an unmodified form input.
  const OtpInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const OtpInput.dirty([super.value = '']) : super.dirty();

  // Override validator to handle validating a given input value.
  @override
  OtpInputValidationError? validator(String? value) {
    if (value == null) return OtpInputValidationError.empty;
    if (value.isEmpty) return OtpInputValidationError.empty;
    if (value.length < 6) return OtpInputValidationError.tooShort;
    return null;
  }
}
