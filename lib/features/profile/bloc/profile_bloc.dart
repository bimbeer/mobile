import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repositories/profile_repository.dart';
import '../models/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const ProfileState.empty()) {
    on<ProfileFetched>(_onProfileFetched);
    on<ProfileModified>(_onProfileModified);
  }

  final ProfileRepository _profileRepository;

  void _onProfileFetched(ProfileFetched event, Emitter<ProfileState> emit) {
    emit(ProfileState.loaded(event.profile));
  }

  void _onProfileModified(ProfileModified event, Emitter<ProfileState> emit) {
    // Update profile using repo
    _profileRepository.editProfile(id: event.userId, profile: event.profile);
    emit(ProfileState.modified(event.profile));
  }
}
