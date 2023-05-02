import 'package:bimbeer/features/profile/bloc/profile_bloc.dart';
import 'package:bimbeer/features/profile/data/repositories/storage_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../app/bloc/app_bloc.dart';
import '../../profile/models/profile.dart';

part 'beer_event.dart';
part 'beer_state.dart';

class BeerBloc extends Bloc<BeerEvent, BeerState> {
  BeerBloc(
      {required StorageRepository storageRepository,
      required ProfileBloc profileBloc,
      required AppState appState})
      : _storageRepository = storageRepository,
        _profileBloc = profileBloc,
        _appState = appState,
        super(const BeerState()) {
    on<BeersFetched>(_onBeersFetched);
    on<SelectedBeer>(_onSelectedBeer);
  }

  final StorageRepository _storageRepository;
  final ProfileBloc _profileBloc;
  final AppState _appState;

  Future<void> _onBeersFetched(
      BeersFetched event, Emitter<BeerState> emit) async {
    try {
      emit(state.copyWith(status: BeerStatus.loading));
      var beerURLs = await _storageRepository.getAllFiles(storagePath: 'beers');
      emit(state.copyWith(status: BeerStatus.loaded, beerURLs: beerURLs));
    } catch (e) {
      emit(state.copyWith(status: BeerStatus.loadingFailed));
    }
  }

  Future<void> _onSelectedBeer(
      SelectedBeer event, Emitter<BeerState> emit) async {
    try {
      var beers = [...?_appState.profile.beers, Beer(link: event.imageURL, name: '')];

      _profileBloc.add(ProfileModified(userId: _appState.user.id, profile: _profileBloc.state.profile.copyWith(beers: beers)));
      var selectedBeers = [...state.selectedBeerURLs, event.imageURL];
      emit(state.copyWith(status: BeerStatus.selectSuccess, selectedBeerURLs: selectedBeers, selected: event.imageURL));
    } catch (e) {
      emit(state.copyWith(status: BeerStatus.selectFailed));
    }
  }
}
