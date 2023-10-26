part of 'pairs_bloc.dart';

abstract class PairsEvent extends Equatable {
  const PairsEvent();

  @override
  List<Object> get props => [];
}

class PairsFetched extends PairsEvent {
  const PairsFetched(this.userId);

  final String userId;

  @override
  List<Object> get props => [userId];

}

class PairLiked extends PairsEvent {
  const PairLiked({required this.userId ,required this.matchingProfile});

  final String userId;
  final MatchingProfile matchingProfile;

  @override
  List<Object> get props => [userId, matchingProfile];
}

class PairDisliked extends PairsEvent {
  const PairDisliked({required this.userId,required this.matchingProfile});

  final String userId;
  final MatchingProfile matchingProfile;

  @override
  List<Object> get props => [userId, matchingProfile];
}

class PairsFinished extends PairsEvent {}
