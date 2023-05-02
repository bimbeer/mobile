part of 'beer_bloc.dart';

abstract class BeerEvent extends Equatable {
  const BeerEvent();

  @override
  List<Object> get props => [];
}

class BeersFetched extends BeerEvent {}

class SelectedBeer extends BeerEvent {
  const SelectedBeer(this.imageURL);
  final String imageURL;
}