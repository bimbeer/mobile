import 'package:formz/formz.dart';

enum LocationInputValidationError {
  required('Address can\'t be empty'),
  invalid('Address you have entered is not valid.');

  final String message;
  const LocationInputValidationError(this.message);
}

class LocationInput extends FormzInput<String, LocationInputValidationError> {
  const LocationInput.pure() : super.pure('');
  const LocationInput.dirty([super.value = '']) : super.dirty();

  static final _nameRegex = RegExp(r'^[a-zA-Z\s]+$');

  @override
  LocationInputValidationError? validator(String value) {
    return value.isEmpty
        ? LocationInputValidationError.required
        : _nameRegex.hasMatch(value)
            ? null
            : LocationInputValidationError.invalid;
  }
}
