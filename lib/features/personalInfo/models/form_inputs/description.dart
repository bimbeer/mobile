import 'package:formz/formz.dart';

enum DescriptionValidationError {
  invalid('Description you have entered is not valid.');

  final String message;
  const DescriptionValidationError(this.message);
}

class Description extends FormzInput<String, DescriptionValidationError> {
  const Description.pure() : super.pure('');
  const Description.dirty([super.value = '']) : super.dirty();

  static final _descriptionRegex = RegExp(r"^[\w\W\u0100-\u017F]{0,500}$");

  @override
  DescriptionValidationError? validator(String value) {
    return _descriptionRegex.hasMatch(value)
        ? null
        : DescriptionValidationError.invalid;
  }
}
