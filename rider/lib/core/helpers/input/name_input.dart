import 'package:formz/formz.dart';

enum NameInputValidationError {
  empty('This field cannot be empty'),
  invaid('Name should contain only letters'),
  tooShort('This name is too short');

  final String message;

  const NameInputValidationError(this.message);
}

class NameInput extends FormzInput<String, NameInputValidationError> {
  // Call super.pure to represent an unmodified form input.
  const NameInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const NameInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _nameRegExp = RegExp('[a-zA-Z]');

  // Override validator to handle validating a given input value.
  @override
  NameInputValidationError? validator(String? value) {
    if (value == null) return NameInputValidationError.empty;
    if (value.isEmpty) return NameInputValidationError.empty;
    if (!_nameRegExp.hasMatch(value)) return NameInputValidationError.invaid;
    return null;
  }
}
