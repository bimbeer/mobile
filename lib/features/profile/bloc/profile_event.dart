part of 'profile_bloc.dart';

abstract class ProfileEvent {
  const ProfileEvent({this.profile = Profile.empty});

  final Profile profile;
}

class ProfileFetched extends ProfileEvent {
  const ProfileFetched({required super.profile});
}

class ProfileModified extends ProfileEvent {
  const ProfileModified({required this.userId, super.profile});

  final String userId;
}