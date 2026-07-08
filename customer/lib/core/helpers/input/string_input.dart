import 'package:formz/formz.dart';

enum StringInputValidationError {
  empty('This field cannot be empty');

  final String message;

  const StringInputValidationError(this.message);
}

class StringInput extends FormzInput<String, StringInputValidationError> {
  // Call super.pure to represent an unmodified form input.
  const StringInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const StringInput.dirty([super.value = '']) : super.dirty();

  // Override validator to handle validating a given input value.
  @override
  StringInputValidationError? validator(String? value) {
    if (value == null) return StringInputValidationError.empty;
    if (value.isEmpty) return StringInputValidationError.empty;
    return null;
  }
}
