part of 'pairs_bloc.dart';

abstract class PairsEvent extends Equatable {
  const PairsEvent();

  @override
  List<Object> get props => [];
}

class PairsFetched extends PairsEvent {}

class PairLiked extends PairsEvent {
  const PairLiked(this.matchingProfile);

  final MatchingProfile matchingProfile;

  @override
  List<Object> get props => [matchingProfile];
}

class PairDisliked extends PairsEvent {
  const PairDisliked(this.matchingProfile);

  final MatchingProfile matchingProfile;

  @override
  List<Object> get props => [matchingProfile];
}

class PairsFinished extends PairsEvent {}
