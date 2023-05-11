import 'package:formz/formz.dart';

enum LastNameValidationError {
  required('Surname can\'t be empty'),
  invalid('Surname you have entered is not valid.');

  final String message;
  const LastNameValidationError(this.message);
}

class LastName extends FormzInput<String, LastNameValidationError> {
  const LastName.pure() : super.pure('');
  const LastName.dirty([super.value = '']) : super.dirty();

  static final _surnameRegex =
      RegExp(
      r"[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ]+(([',. -][a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ ])?[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ]*)*$");

  @override
  LastNameValidationError? validator(String value) {
    return value.isEmpty
        ? LastNameValidationError.required
        : _surnameRegex.hasMatch(value)
            ? null
            : LastNameValidationError.invalid;
  }
}
