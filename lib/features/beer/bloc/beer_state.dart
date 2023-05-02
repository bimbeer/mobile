part of 'beer_bloc.dart';

enum BeerStatus { initial, loading, loaded, loadingFailed, selectFailed, selectSuccess }

class BeerState extends Equatable {
  const BeerState(
      {this.status = BeerStatus.initial,
      this.beerURLs = const <String>[],
      this.selectedBeerURLs = const <String>[],
      this.selected});

  final BeerStatus status;
  final List<String> beerURLs;
  final List<String> selectedBeerURLs;
  final String? selected;

  BeerState copyWith({
    BeerStatus? status,
    List<String>? beerURLs,
    List<String>? selectedBeerURLs,
    String? selected,
  }) {
    return BeerState(
        status: status ?? this.status,
        beerURLs: beerURLs ?? this.beerURLs,
        selectedBeerURLs: selectedBeerURLs ?? this.selectedBeerURLs,
        selected: selected ?? selected ?? this.selected);
  }

  @override
  List<Object> get props => [status, beerURLs, selectedBeerURLs];
}
