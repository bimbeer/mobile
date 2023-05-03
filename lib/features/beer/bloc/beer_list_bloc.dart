import 'dart:async';

import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/profile_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/storage_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../profile/models/profile.dart';

part 'beer_list_event.dart';
part 'beer_list_state.dart';

class BeerListBloc extends Bloc<BeerListEvent, BeerListState> {
  BeerListBloc({
    required StorageRepository storageRepository,
    required ProfileRepository profileRepository,
    required AuthenticaionRepository authenticationRepository,
  })  : _storageRepository = storageRepository,
        _profileRepository = profileRepository,
        _authenticationRepository = authenticationRepository,
        super(const BeerListState()) {
    _profileSubscription = _profileRepository
        .profileStream(_authenticationRepository.currentUser.id)
        .listen((profile) {
      if (!listEquals(profile.beers, state.selectedBeers)) {
        add(BeerListFetched());
      }
    });

    on<BeerListFetched>(_onBeersFetched);
    on<BeerToggled>(_onBeerToggled);
  }

  final StorageRepository _storageRepository;
  final ProfileRepository _profileRepository;
  final AuthenticaionRepository _authenticationRepository;
  late StreamSubscription _profileSubscription;

  Future<void> _onBeersFetched(
      BeerListFetched event, Emitter<BeerListState> emit) async {
    try {
      emit(state.copyWith(status: BeerListStatus.loading));
      final beerURLs =
          await _storageRepository.getAllFiles(storagePath: 'beers');
      final beers = beerURLs.map((e) => Beer(link: e, name: '')).toList();

      final Profile profile = await _profileRepository
          .get(_authenticationRepository.currentUser.id);
      final selectedBeers = profile.beers?.toList();

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
      final id = _authenticationRepository.currentUser.id;
      final profile = await _profileRepository.get(id);

      List<Beer> updatedSelectedBeers = List.from(state.selectedBeers);

      if (updatedSelectedBeers.where((beer) => beer == event.beer).isNotEmpty) {
        updatedSelectedBeers.removeWhere((beer) => beer == event.beer);
        profile.beers?.removeWhere((beer) => beer == event.beer);
      } else {
        updatedSelectedBeers.add(event.beer);
        profile.beers?.add(event.beer);
      }

      _profileRepository.edit(id: id, profile: profile);

      emit(state.copyWith(
        status: BeerListStatus.updated,
        selectedBeers: updatedSelectedBeers,
      ));
    } catch (e) {
      emit(state.copyWith(status: BeerListStatus.updateFailed));
    }
  }

  @override
  Future<void> close() {
    _profileSubscription.cancel();
    return super.close();
  }
}
