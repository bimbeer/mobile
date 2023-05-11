part of 'beer_list_bloc.dart';

enum BeerListStatus {
  initial,
  loading,
  loadingFailed,
  loaded,
  updated,
  updateFailed,
}

class BeerListState extends Equatable {
  const BeerListState(
      {this.status = BeerListStatus.initial,
      this.beers = const <Beer>[],
      this.selectedBeers = const <Beer>[]});

  final BeerListStatus status;
  final List<Beer> beers;
  final List<Beer> selectedBeers;

  BeerListState copyWith({
    BeerListStatus? status,
    List<Beer>? beers,
    List<Beer>? selectedBeers,
  }) {
    return BeerListState(
      status: status ?? this.status,
      beers: beers ?? this.beers,
      selectedBeers: selectedBeers ?? this.selectedBeers,
    );
  }

  @override
  List<Object> get props => [status, beers, selectedBeers];
}
