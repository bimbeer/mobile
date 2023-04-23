import 'package:formz/formz.dart';

enum GenderValidationError {
  required('Gender can\'t be empty'),
  invalid('Gender value is not valid.');

  final String message;
  const GenderValidationError(this.message);
}

const List<String> genders = ['Male', 'Female', 'Other'];

class Gender extends FormzInput<String, GenderValidationError> {
  const Gender.pure() : super.pure('');
  const Gender.dirty([super.value = '']) : super.dirty();

  @override
  GenderValidationError? validator(String value) {
    return value.isEmpty
        ? GenderValidationError.required
        : genders.contains(value)
            ? null
            : GenderValidationError.invalid;
  }
}
