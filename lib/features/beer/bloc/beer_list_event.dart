part of 'beer_list_bloc.dart';

abstract class BeerListEvent extends Equatable {
  const BeerListEvent();

  @override
  List<Object> get props => [];
}

class BeerListFetched extends BeerListEvent {}

class BeerToggled extends BeerListEvent {
  const BeerToggled(this.beer);
  final Beer beer;
}
