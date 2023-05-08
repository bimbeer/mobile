part of 'pairs_bloc.dart';

abstract class PairsEvent extends Equatable {
  const PairsEvent();

  @override
  List<Object> get props => [];
}

class PairsFetched extends PairsEvent {}

class PairsFinished extends PairsEvent {}
