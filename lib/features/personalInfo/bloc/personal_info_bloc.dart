import 'dart:async';
import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../profile/data/repositories/profile_repository.dart';
import '../models/form_inputs/age.dart';
import '../models/form_inputs/description.dart';
import '../models/form_inputs/gender.dart';
import '../models/form_inputs/first_name.dart';
import '../models/form_inputs/interest.dart';
import '../models/form_inputs/last_name.dart';
import '../models/form_inputs/username.dart';

part 'personal_info_event.dart';
part 'personal_info_state.dart';

class PersonalInfoBloc extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  PersonalInfoBloc(
      {required AuthenticaionRepository authenticationRepository,
      required ProfileRepository profileRepository})
      : _authenticationRepository = authenticationRepository,
        _profileRepository = profileRepository,
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

    _listenToProfileBloc();
  }

  final AuthenticaionRepository _authenticationRepository;
  final ProfileRepository _profileRepository;
  late final StreamSubscription _profileSubscription;

  void _onProfileFetched(
      PersonalInfoLoaded event, Emitter<PersonalInfoState> emit) {
    final username = event.profile.username != null
        ? Username.dirty(event.profile.username!)
        : const Username.pure();
    final firstName = event.profile.firstName != null
        ? FirstName.dirty(event.profile.firstName!)
        : const FirstName.pure();
    final lastName = event.profile.lastName != null
        ? LastName.dirty(event.profile.lastName!)
        : const LastName.pure();
    final age = event.profile.age != null
        ? Age.dirty(event.profile.age!)
        : const Age.pure();
    final description = event.profile.description != null
        ? Description.dirty(event.profile.description!)
        : const Description.pure();
    final gender = event.profile.gender != null
        ? Gender.dirty(event.profile.gender!)
        : const Gender.pure();
    final interest = event.profile.interest != null
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
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      return;
    }

    Profile profile = _profileRepository.currentProfile.copyWith(
        username: state.username.value,
        firstName: state.firstName.value,
        lastName: state.lastName.value,
        age: state.age.value,
        description: state.description.value,
        gender: state.gender.value,
        interest: state.interest.value);

    final userProfile =
        await _profileRepository.get(_authenticationRepository.currentUser.id);
    if (userProfile == Profile.empty) {
      _profileRepository.add(_authenticationRepository.currentUser.id, profile);
    } else {
      _profileRepository.edit(
          id: _authenticationRepository.currentUser.id, profile: profile);
    }
  }

  void _listenToProfileBloc() {
    _profileSubscription = _profileRepository
        .profileStream(_authenticationRepository.currentUser.id)
        .listen((profile) {
      add(PersonalInfoLoaded(profile));
    });
  }

  @override
  Future<void> close() {
    _profileSubscription.cancel();
    return super.close();
  }
}
