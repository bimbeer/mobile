import 'package:formz/formz.dart';

enum AddressInputValidationError {
  required('Address can\'t be empty'),
  invalid('Address you have entered is not valid.');

  final String message;
  const AddressInputValidationError(this.message);
}

class AddressInput extends FormzInput<String, AddressInputValidationError> {
  const AddressInput.pure() : super.pure('');
  const AddressInput.dirty([super.value = '']) : super.dirty();

  static final _nameRegex = RegExp(r'^[a-zA-Z\s]+$');

  @override
  AddressInputValidationError? validator(String value) {
    return value.isEmpty
        ? AddressInputValidationError.required
        : _nameRegex.hasMatch(value)
            ? null
            : AddressInputValidationError.invalid;
  }
}
