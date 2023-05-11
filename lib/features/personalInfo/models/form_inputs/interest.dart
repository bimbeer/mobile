import 'package:formz/formz.dart';

enum InterestValidationError {
  required('Preference can\'t be empty'),
  invalid('Preference value is not valid.');

  final String message;
  const InterestValidationError(this.message);
}

const List<String> interests = ['Man', 'Woman', 'All'];

class Interest extends FormzInput<String, InterestValidationError> {
  const Interest.pure() : super.pure('');
  const Interest.dirty([super.value = '']) : super.dirty();

  @override
  InterestValidationError? validator(String value) {
    return value.isEmpty
        ? InterestValidationError.required
        : interests.contains(value)
            ? null
            : InterestValidationError.invalid;
  }
}
