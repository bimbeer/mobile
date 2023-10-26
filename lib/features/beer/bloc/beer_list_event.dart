part of 'beer_list_bloc.dart';

abstract class BeerListEvent extends Equatable {
  const BeerListEvent();

  @override
  List<Object> get props => [];
}

class BeerListFetched extends BeerListEvent {
  const BeerListFetched({required this.profile});

  final Profile profile;

  @override
  List<Object> get props => [profile];
}

class BeerToggled extends BeerListEvent {
  const BeerToggled(
      {required this.userId, required this.profile, required this.beer});

  final String userId;
  final Profile profile;
  final Beer beer;

  @override
  List<Object> get props => [userId, profile, beer];
}
