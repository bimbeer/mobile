import 'dart:async';

import 'package:bimbeer/features/profile/data/repositories/profile_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/storage_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../profile/models/profile.dart';
import '../utils/beer_list_util.dart';

part 'beer_list_event.dart';
part 'beer_list_state.dart';

class BeerListBloc extends Bloc<BeerListEvent, BeerListState> {
  BeerListBloc({
    required StorageRepository storageRepository,
    required ProfileRepository profileRepository,
  })  : _storageRepository = storageRepository,
        _profileRepository = profileRepository,
        super(const BeerListState()) {
    on<_BeerListInitialized>(_onBeersInitialized);
    on<BeerListFetched>(_onBeersFetched);
    on<BeerToggled>(_onBeerToggled);

    add(const _BeerListInitialized());
  }

  final StorageRepository _storageRepository;
  final ProfileRepository _profileRepository;

  Future<void> _onBeersInitialized(
      _BeerListInitialized event, Emitter<BeerListState> emit) async {
    try {
      emit(state.copyWith(status: BeerListStatus.loading));
      final beerURLs =
          await _storageRepository.getAllFiles(storagePath: 'beers');
      final beers = beerURLs
          .map((e) =>
              Beer(link: e, name: BeerListUtil.getBeerNameByLink(e) ?? ''))
          .toList();

      emit(state.copyWith(
          status: BeerListStatus.loaded, beers: beers, selectedBeers: []));
    } catch (e) {
      emit(state.copyWith(status: BeerListStatus.loadingFailed));
    }
  }

  Future<void> _onBeersFetched(
      BeerListFetched event, Emitter<BeerListState> emit) async {
    try {
      emit(state.copyWith(status: BeerListStatus.loading));
      final beerURLs =
          await _storageRepository.getAllFiles(storagePath: 'beers');
      final beers = beerURLs
          .map((e) =>
              Beer(link: e, name: BeerListUtil.getBeerNameByLink(e) ?? ''))
          .toList();

      final selectedBeers = event.profile.beers?.toList();

      emit(state.copyWith(
          status: BeerListStatus.loaded,
          beers: beers,
          selectedBeers: selectedBeers));
    } catch (e) {
      emit(state.copyWith(status: BeerListStatus.loadingFailed));
    }
  }

  Future<void> _onBeerToggled(
      BeerToggled event, Emitter<BeerListState> emit) async {
    try {
      List<Beer> updatedSelectedBeers = List.from(state.selectedBeers);

      if (updatedSelectedBeers.where((beer) => beer == event.beer).isNotEmpty) {
        updatedSelectedBeers.removeWhere((beer) => beer == event.beer);
        event.profile.beers?.removeWhere((beer) => beer == event.beer);
      } else {
        updatedSelectedBeers.add(event.beer);
        event.profile.beers?.add(event.beer);
      }

      _profileRepository.edit(id: event.userId, profile: event.profile);
      emit(state.copyWith(
        status: BeerListStatus.updated,
        selectedBeers: updatedSelectedBeers,
      ));
    } catch (e) {
      emit(state.copyWith(status: BeerListStatus.updateFailed));
    }
  }
}
