part of 'profile_card_bloc.dart';

class ProfileCardState extends Equatable {
  const ProfileCardState(
      {required this.profile, required this.currentBeerIndex});

  ProfileCardState copyWith({Profile? profile, int? currentBeerIndex}) {
    return ProfileCardState(
        profile: profile ?? this.profile,
        currentBeerIndex: currentBeerIndex ?? this.currentBeerIndex);
  }

  final Profile profile;
  final int currentBeerIndex;

  @override
  List<Object> get props => [profile, currentBeerIndex];
}
