import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../profile/models/matching_profile.dart';

part 'profile_card_event.dart';
part 'profile_card_state.dart';

class ProfileCardBloc extends Bloc<ProfileCardEvent, ProfileCardState> {
  ProfileCardBloc({required MatchingProfile profile})
      : super(ProfileCardState(matchingProfile: profile, currentBeerIndex: 0)) {
    on<ProfileCardShowNextBeer>(_onProfileCardShowNextBeer);
    on<ProfileCardShowPreviousBeer>(_onProfileCardShowPreviousBeer);
  }

  void _onProfileCardShowNextBeer(
      ProfileCardShowNextBeer event, Emitter<ProfileCardState> emit) {
    final nextBeerIndex =
        state.currentBeerIndex == state.matchingProfile.profile.beers?.length
            ? state.currentBeerIndex
            : state.currentBeerIndex + 1;
    emit(state.copyWith(currentBeerIndex: nextBeerIndex));
  }

  void _onProfileCardShowPreviousBeer(
      ProfileCardShowPreviousBeer event, Emitter<ProfileCardState> emit) {
    final previousBeerIndex = state.currentBeerIndex == 0
        ? state.currentBeerIndex
        : state.currentBeerIndex - 1;
    emit(state.copyWith(currentBeerIndex: previousBeerIndex));
  }
}
