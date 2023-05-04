part of 'personal_info_bloc.dart';

abstract class PersonalInfoEvent {
  const PersonalInfoEvent();
}

class PersonalInfoLoaded extends PersonalInfoEvent {
  const PersonalInfoLoaded(this.profile);
  final Profile profile;
}

class FormSubmitted extends PersonalInfoEvent { 
  const FormSubmitted({required this.userId});
  final String userId;
}

class UsernameChanged extends PersonalInfoEvent {
  const UsernameChanged(this.username);

  final String username;
}

class FirstNameChanged extends PersonalInfoEvent {
  const FirstNameChanged(this.name);

  final String name;
}

class LastNameChanged extends PersonalInfoEvent {
  const LastNameChanged(this.lastName);

  final String lastName;
}

class AgeChanged extends PersonalInfoEvent {
  const AgeChanged(this.age);

  final int age;
}

class DescriptionChanged extends PersonalInfoEvent {
  const DescriptionChanged(this.description);

  final String description;
}

class GenderChanged extends PersonalInfoEvent {
  const GenderChanged(this.gender);

  final String gender;
}

class InterestChanged extends PersonalInfoEvent {
  const InterestChanged(this.interest);

  final String interest;
}
