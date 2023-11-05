part of 'profile_first_setup_bloc.dart';

enum ProfileFirstSetupStatus { initial, loading, notFinished, finished }

class ProfileFirstSetupState extends Equatable {
  const ProfileFirstSetupState(
      {required this.status});

  final ProfileFirstSetupStatus status;

  static ProfileFirstSetupState initial() => const ProfileFirstSetupState(
    status: ProfileFirstSetupStatus.initial,
  );

  @override
  List<Object?> get props => [status];
}
