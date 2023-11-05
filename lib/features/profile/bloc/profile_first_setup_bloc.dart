import 'dart:async';

import 'package:bimbeer/features/profile/data/repositories/profile_repository.dart';
import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_first_setup_event.dart';
part 'profile_first_setup_state.dart';

class ProfileFirstSetupBloc
    extends Bloc<ProfileFirstSetupEvent, ProfileFirstSetupState> {
  ProfileFirstSetupBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(ProfileFirstSetupState.initial()) {
    on<ProfileFirstSetupStarted>(_onProfileFirstSetupStarted);
  }
  final ProfileRepository _profileRepository;

  FutureOr<void> _onProfileFirstSetupStarted(ProfileFirstSetupStarted event,
      Emitter<ProfileFirstSetupState> emit) async {
    emit(const ProfileFirstSetupState(
        status: ProfileFirstSetupStatus.loading));
    final profile = await _profileRepository.get(event.userId);
    if (profile.isEmpty) {
      emit(const ProfileFirstSetupState(status: ProfileFirstSetupStatus.notFinished));
    } else {
      final isPersonalInfoSet = _isPersonalInfoSet(profile);
      final isLocationInfoSet = _isLocationInfoSet(profile);
      final isBeerInfoSet = _isBeerInfoSet(profile);
      if (isPersonalInfoSet && isLocationInfoSet && isBeerInfoSet) {
        emit(const ProfileFirstSetupState(status: ProfileFirstSetupStatus.finished));
      } else {
        emit(const ProfileFirstSetupState(status: ProfileFirstSetupStatus.notFinished));
      }
    }
  }

  bool _isPersonalInfoSet(Profile profile) {
    return profile.firstName != null &&
        profile.firstName!.isNotEmpty &&
        profile.lastName != null &&
        profile.lastName!.isNotEmpty &&
        profile.username != null &&
        profile.username!.isNotEmpty &&
        profile.age != null &&
        profile.age! > 0 &&
        profile.gender != null &&
        profile.gender!.isNotEmpty &&
        profile.interest != null &&
        profile.interest!.isNotEmpty;
  }

  bool _isLocationInfoSet(Profile profile) {
    return profile.location != null &&
        profile.location?.label != null &&
        profile.location!.label!.isNotEmpty &&
        profile.range != null &&
        profile.range! > 0;
  }

  bool _isBeerInfoSet(Profile profile) {
    return profile.beers != null && profile.beers!.isNotEmpty;
  }
}
