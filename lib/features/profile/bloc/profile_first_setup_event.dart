part of 'profile_first_setup_bloc.dart';

sealed class ProfileFirstSetupEvent extends Equatable {
  const ProfileFirstSetupEvent();

  @override
  List<Object> get props => [];
}

class ProfileFirstSetupStarted extends ProfileFirstSetupEvent {
  const ProfileFirstSetupStarted(this.userId);

  final String userId;

  @override
  List<Object> get props => [];
}