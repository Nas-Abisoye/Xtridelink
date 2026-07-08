import 'package:formz/formz.dart';

enum AccountNumberInputValidationError {
  empty('This field cannot be empty'),
  invalid('Invalid account number');

  final String message;

  const AccountNumberInputValidationError(this.message);
}

class AccountNumberInput
    extends FormzInput<String, AccountNumberInputValidationError> {
  // Call super.pure to represent an unmodified form input.
  const AccountNumberInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const AccountNumberInput.dirty([super.value = '']) : super.dirty();

  // Override validator to handle validating a given input value.
  @override
  AccountNumberInputValidationError? validator(String? value) {
    if (value == null) return AccountNumberInputValidationError.empty;
    if (value.isEmpty) return AccountNumberInputValidationError.empty;
    if (value.length < 9) return AccountNumberInputValidationError.invalid;
    return null;
  }
}
