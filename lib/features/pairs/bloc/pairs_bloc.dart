import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bimbeer/features/pairs/models/interaction.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../profile/data/repositories/profile_repository.dart';
import '../../profile/models/matching_profile.dart';
import '../data/repositories/interactions_repository.dart';

part 'pairs_event.dart';
part 'pairs_state.dart';

const String like = 'like';
const String dislike = 'dislike';

class PairsBloc extends Bloc<PairsEvent, PairsState> {
  PairsBloc(
      {required ProfileRepository profileRepository,
      required AuthenticaionRepository authenticationRepository,
      required InteractionsRepository interactionsRepository})
      : _profileRepository = profileRepository,
        _authenticationRepository = authenticationRepository,
        _interactionsRepository = interactionsRepository,
        super(PairsEmpty()) {
    on<PairsFetched>(_onPairsFetched);
    on<PairsFinished>(_onPairsFinished);
    on<PairLiked>(_onPairLiked);
    on<PairDisliked>(_onPairDisliked);
  }

  final ProfileRepository _profileRepository;
  final AuthenticaionRepository _authenticationRepository;
  final InteractionsRepository _interactionsRepository;

  void _onPairsFetched(PairsFetched event, Emitter<PairsState> emit) async {
    if (_authenticationRepository.currentUser.id == '') {
      return emit(PairsEmpty());
    }

    emit(PairsLoading());
    try {
      final matches = await _profileRepository
          .getMatchingProfiles(_authenticationRepository.currentUser.id);
      if (matches.isNotEmpty) {
        emit(PairsNotEmpty(matches));
      } else {
        emit(PairsEmpty());
      }
    } catch (e) {
      emit(PairsEmpty());
    }
  }

  void _onPairsFinished(PairsFinished event, Emitter<PairsState> emit) {
    emit(PairsEmpty());
  }

  void _onPairLiked(PairLiked event, Emitter<PairsState> emit) {
    final interaction = Interaction(
        reactionType: like,
        recipient: event.matchingProfile.id,
        sender: _authenticationRepository.currentUser.id);

    _interactionsRepository.addInteraction(interaction);
  }

  void _onPairDisliked(PairDisliked event, Emitter<PairsState> emit) {
    final interaction = Interaction(
        reactionType: dislike,
        recipient: event.matchingProfile.id,
        sender: _authenticationRepository.currentUser.id);

    _interactionsRepository.addInteraction(interaction);
  }
}
