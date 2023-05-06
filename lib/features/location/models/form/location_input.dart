import 'package:formz/formz.dart';

enum LocationInputValidationError {
  required('Address can\'t be empty');

  final String message;
  const LocationInputValidationError(this.message);
}

class LocationInput extends FormzInput<String, LocationInputValidationError> {
  const LocationInput.pure() : super.pure('');
  const LocationInput.dirty([super.value = '']) : super.dirty();

  @override
  LocationInputValidationError? validator(String value) {
    return value == '' ? LocationInputValidationError.required : null;
  }
}
