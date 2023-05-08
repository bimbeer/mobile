part of 'pairs_bloc.dart';

abstract class PairsState extends Equatable {
  const PairsState();

  @override
  List<Object> get props => [];
}

class PairsEmpty extends PairsState {}

class PairsLoading extends PairsState {}

class PairsNotEmpty extends PairsState {
  final List<Profile> pairs;

  const PairsNotEmpty(this.pairs);
}

