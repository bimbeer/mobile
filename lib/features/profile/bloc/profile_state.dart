part of 'profile_bloc.dart';

enum ProfileStatus {
  empty,
  loaded,
  modfied,
}

class ProfileState extends Equatable {
  const ProfileState._({this.profile = Profile.empty, required this.status});

  const ProfileState.empty() : this._(status: ProfileStatus.empty);

  const ProfileState.loaded(Profile profile)
      : this._(status: ProfileStatus.loaded, profile: profile);

  const ProfileState.modified(Profile profile)
      : this._(status: ProfileStatus.modfied, profile: profile);

  final Profile profile;
  final ProfileStatus status;

  @override
  List<Object> get props => [profile, status];
}
