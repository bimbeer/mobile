import 'package:formz/formz.dart';

enum AddressValidationError {
  required('Address can\'t be empty'),
  invalid('Address you have entered is not valid.');

  final String message;
  const AddressValidationError(this.message);
}

class Address extends FormzInput<String, AddressValidationError> {
  const Address.pure() : super.pure('');
  const Address.dirty([super.value = '']) : super.dirty();

  static final _nameRegex = RegExp(r'^[a-zA-Z\s]+$');

  @override
  AddressValidationError? validator(String value) {
    return value.isEmpty
        ? AddressValidationError.required
        : _nameRegex.hasMatch(value)
            ? null
            : AddressValidationError.invalid;
  }
}
