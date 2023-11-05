part of 'profile_first_setup_bloc.dart';

enum ProfileFirstSetupStatus { initial, loading, notFinished, finished, failure }

class ProfileFirstSetupState extends Equatable {
  const ProfileFirstSetupState(
      {required this.status,
      this.isPersonalInfoSet,
      this.isBeerInfoSet,
      this.isLocationInfoSet});

  final ProfileFirstSetupStatus status;
  final bool? isPersonalInfoSet;
  final bool? isBeerInfoSet;
  final bool? isLocationInfoSet;

  static ProfileFirstSetupState initial() => const ProfileFirstSetupState(
    status: ProfileFirstSetupStatus.initial,
    isPersonalInfoSet: false,
    isBeerInfoSet: false,
    isLocationInfoSet: false,
  );

  ProfileFirstSetupState copyWith({
    ProfileFirstSetupStatus? status,
    bool? isPersonalInfoSet,
    bool? isBeerInfoSet,
    bool? isLocationInfoSet,
  }) {
    return ProfileFirstSetupState(
      status: status ?? this.status,
      isPersonalInfoSet: isPersonalInfoSet ?? this.isPersonalInfoSet,
      isBeerInfoSet: isBeerInfoSet ?? this.isBeerInfoSet,
      isLocationInfoSet: isLocationInfoSet ?? this.isLocationInfoSet,
    );
  }

  @override
  List<Object?> get props => [status, isPersonalInfoSet, isBeerInfoSet, isLocationInfoSet];
}
