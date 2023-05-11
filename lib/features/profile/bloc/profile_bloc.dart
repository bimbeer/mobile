import 'dart:async';

import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repositories/profile_repository.dart';
import '../models/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
      {required ProfileRepository profileRepository,
      required AuthenticaionRepository authenticationRepository})
      : _profileRepository = profileRepository,
        _authenticationRepository = authenticationRepository,
        super(const ProfileState.empty()) {
    _profileSubscription = _profileRepository
        .profileStream(_authenticationRepository.currentUser.id)
        .listen((profile) => add(ProfileFetched(profile: profile)));

    on<ProfileFetched>(_onProfileFetched);
    on<ProfileModified>(_onProfileModified);
  }

  final ProfileRepository _profileRepository;
  final AuthenticaionRepository _authenticationRepository;
  late final StreamSubscription _profileSubscription;

  void _onProfileFetched(ProfileFetched event, Emitter<ProfileState> emit) {
    emit(ProfileState.loaded(event.profile));
  }

  void _onProfileModified(ProfileModified event, Emitter<ProfileState> emit) {
    _profileRepository.edit(id: event.userId, profile: event.profile);
    emit(ProfileState.modified(event.profile));
  }

  @override
  Future<void> close() {
    _profileSubscription.cancel();
    return super.close();
  }
}
