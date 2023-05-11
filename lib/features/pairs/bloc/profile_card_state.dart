part of 'profile_card_bloc.dart';

class ProfileCardState extends Equatable {
  const ProfileCardState(
      {required this.matchingProfile, required this.currentBeerIndex});

  ProfileCardState copyWith({MatchingProfile? profile, int? currentBeerIndex}) {
    return ProfileCardState(
        matchingProfile: profile ?? this.matchingProfile,
        currentBeerIndex: currentBeerIndex ?? this.currentBeerIndex);
  }

  final MatchingProfile matchingProfile;
  final int currentBeerIndex;

  @override
  List<Object> get props => [matchingProfile, currentBeerIndex];
}
