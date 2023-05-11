import 'package:formz/formz.dart';

enum FirstNameValidationError {
  required('Name can\'t be empty'),
  invalid('Name you have entered is not valid.');

  final String message;
  const FirstNameValidationError(this.message);
}

class FirstName extends FormzInput<String, FirstNameValidationError> {
  const FirstName.pure() : super.pure('');
  const FirstName.dirty([super.value = '']) : super.dirty();

  static final _nameRegex = RegExp(
      r"[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ]+(([',. -][a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ ])?[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ]*)*$");

  @override
  FirstNameValidationError? validator(String value) {
    return value.isEmpty
        ? FirstNameValidationError.required
        : _nameRegex.hasMatch(value)
            ? null
            : FirstNameValidationError.invalid;
  }
}
