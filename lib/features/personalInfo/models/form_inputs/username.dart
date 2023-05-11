import 'package:formz/formz.dart';

enum UsernameError {
  required('Username can\'t be empty'),
  invalid('Username you have entered is not valid.');

  final String message;
  const UsernameError(this.message);
}

class Username extends FormzInput<String, UsernameError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  static final _usernameRegex = RegExp(
      r"[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ]+(([',. -][a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ ])?[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ]*)*$");

  @override
  UsernameError? validator(String value) {
    return value.isEmpty
        ? UsernameError.required
        : _usernameRegex.hasMatch(value)
            ? null
            : UsernameError.invalid;
  }
}
