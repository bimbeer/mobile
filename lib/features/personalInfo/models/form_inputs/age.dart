import 'package:formz/formz.dart';

enum AgeValidationError {
  invalid('Age you have entered is not valid.');

  final String message;
  const AgeValidationError(this.message);
}

class Age extends FormzInput<int, AgeValidationError> {
  const Age.pure() : super.pure(0);
  const Age.dirty([super.value = 0]) : super.dirty();

  @override
  AgeValidationError? validator(int value) {
    return value.isNaN
        ? AgeValidationError.invalid
        : null;
  }
}
