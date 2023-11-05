import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../profile/data/repositories/profile_repository.dart';
import '../models/form_inputs/age.dart';
import '../models/form_inputs/description.dart';
import '../models/form_inputs/first_name.dart';
import '../models/form_inputs/gender.dart';
import '../models/form_inputs/interest.dart';
import '../models/form_inputs/last_name.dart';
import '../models/form_inputs/username.dart';

part 'personal_info_event.dart';
part 'personal_info_state.dart';

class PersonalInfoBloc extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  PersonalInfoBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const PersonalInfoState()) {
    on<PersonalInfoLoaded>(_onProfileFetched);
    on<UsernameChanged>(_onUsernameChanged);
    on<FirstNameChanged>(_onFirstNameChanged);
    on<FormSubmitted>(_onPersonalInfoFormSubmitted);
    on<LastNameChanged>(_onLastNameChanged);
    on<AgeChanged>(_onAgeChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<GenderChanged>(_onGenderChanged);
    on<InterestChanged>(_onInterestChanged);
  }

  final ProfileRepository _profileRepository;

  void _onProfileFetched(
      PersonalInfoLoaded event, Emitter<PersonalInfoState> emit) {
    final username =
        event.profile.username != null && event.profile.username!.isNotEmpty
            ? Username.dirty(event.profile.username!)
            : const Username.pure();
    final firstName =
        event.profile.firstName != null && event.profile.firstName!.isNotEmpty
            ? FirstName.dirty(event.profile.firstName!)
            : const FirstName.pure();
    final lastName =
        event.profile.lastName != null && event.profile.lastName!.isNotEmpty
            ? LastName.dirty(event.profile.lastName!)
            : const LastName.pure();
    final age = event.profile.age != null
        ? Age.dirty(event.profile.age!)
        : const Age.pure();
    final description = event.profile.description != null
        ? Description.dirty(event.profile.description!)
        : const Description.pure();
    final gender =
        event.profile.gender != null && event.profile.gender!.isNotEmpty
            ? Gender.dirty(event.profile.gender!)
            : const Gender.pure();
    final interest =
        event.profile.interest != null && event.profile.interest!.isNotEmpty
            ? Interest.dirty(event.profile.interest!)
            : const Interest.pure();

    emit(state.copyWith(
      username: username,
      firstName: firstName,
      lastName: lastName,
      age: age,
      description: description,
      gender: gender,
      interest: interest,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onUsernameChanged(
      UsernameChanged event, Emitter<PersonalInfoState> emit) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(username: username));
  }

  void _onFirstNameChanged(
      FirstNameChanged event, Emitter<PersonalInfoState> emit) {
    final name = FirstName.dirty(event.name);
    emit(state.copyWith(firstName: name));
  }

  void _onLastNameChanged(
      LastNameChanged event, Emitter<PersonalInfoState> emit) {
    final lastName = LastName.dirty(event.lastName);
    emit(state.copyWith(lastName: lastName));
  }

  void _onAgeChanged(AgeChanged event, Emitter<PersonalInfoState> emit) {
    final age = Age.dirty(event.age);
    emit(state.copyWith(age: age));
  }

  void _onDescriptionChanged(
      DescriptionChanged event, Emitter<PersonalInfoState> emit) {
    final description = Description.dirty(event.description);
    emit(state.copyWith(description: description));
  }

  void _onGenderChanged(GenderChanged event, Emitter<PersonalInfoState> emit) {
    final gender = Gender.dirty(event.gender);
    emit(state.copyWith(gender: gender));
  }

  void _onInterestChanged(
      InterestChanged event, Emitter<PersonalInfoState> emit) {
    final interest = Interest.dirty(event.interest);
    emit(state.copyWith(interest: interest));
  }

  void _onPersonalInfoFormSubmitted(
      FormSubmitted event, Emitter<PersonalInfoState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    if (state.username.isNotValid ||
        state.firstName.isNotValid ||
        state.lastName.isNotValid ||
        state.age.isNotValid | state.description.isNotValid ||
        state.gender.isNotValid ||
        state.interest.isNotValid) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        username: Username.dirty(state.username.value),
        firstName: FirstName.dirty(state.firstName.value),
        lastName: LastName.dirty(state.lastName.value),
        age: Age.dirty(state.age.value),
        gender: Gender.dirty(state.gender.value),
        interest: Interest.dirty(state.interest.value),
      ));
      return;
    }

    Profile profile = event.profile.copyWith(
        username: state.username.value,
        firstName: state.firstName.value,
        lastName: state.lastName.value,
        age: state.age.value,
        description: state.description.value,
        gender: state.gender.value,
        interest: state.interest.value);

    try {
      if (event.profile == Profile.empty) {
        _profileRepository.add(event.userId, profile);
      } else {
        _profileRepository.edit(id: event.userId, profile: profile);
      }
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
