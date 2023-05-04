part of 'personal_info_bloc.dart';

class PersonalInfoState extends Equatable {
  const PersonalInfoState({
    this.username = const Username.pure(),
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.age = const Age.pure(),
    this.description = const Description.pure(),
    this.gender = const Gender.pure(),
    this.interest = const Interest.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final Username username;
  final FirstName firstName;
  final LastName lastName;
  final Age age;
  final Description description;
  final Gender gender;
  final Interest interest;

  final FormzSubmissionStatus status;
  final String? errorMessage;

  PersonalInfoState copyWith({
    Username? username,
    FirstName? firstName,
    LastName? lastName,
    Age? age,
    Description? description,
    Gender? gender,
    Interest? interest,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return PersonalInfoState(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      description: description ?? this.description,
      gender: gender ?? this.gender,
      interest: interest ?? this.interest,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        username,
        firstName,
        lastName,
        age,
        description,
        gender,
        interest,
        status,
        errorMessage,
      ];
}
