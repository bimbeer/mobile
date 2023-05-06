import 'dart:async';

import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_geo_hash/geohash.dart';
import 'package:formz/formz.dart';
import 'package:rxdart/rxdart.dart';

import '../../profile/data/repositories/profile_repository.dart';
import '../data/repositories/location_repository.dart';
import '../models/form/location_input.dart';
import '../models/geocode_city.dart';

part 'location_event.dart';
part 'location_state.dart';

const int searchCitiesDebounceMs = 1000;

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc(
      {required AuthenticaionRepository authenticationRepository,
      required ProfileRepository profileRepository,
      required LocationRepository locationRepository})
      : _authenticationRepository = authenticationRepository,
        _profileRepository = profileRepository,
        _locationRepository = locationRepository,
        super(LocationInitial()) {
    _listenToProfile();
    on<LocationLoaded>(_onLocationLoaded);
    on<LocationUpdated>(_onLocationUpdated);
    on<RangeValueChanged>(_onRangeValueChanged);
    on<LocationInputValueChanged>(
      _onLocationInputValueChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: searchCitiesDebounceMs))
          .asyncExpand(mapper),
    );
    on<LocationFormSubmitted>(_onLocationFormSubmitted);
  }

  final AuthenticaionRepository _authenticationRepository;
  final ProfileRepository _profileRepository;
  final LocationRepository _locationRepository;
  late final StreamSubscription _profileSubscription;
  Profile _cachedProfile = Profile.empty;

  void _onLocationLoaded(LocationLoaded event, Emitter<LocationState> emit) {
    final location = LocationInput.dirty(event.profile.location!.label);
    emit(state.copyWith(locationInput: location, range: event.profile.range));
  }

  void _onLocationUpdated(LocationUpdated event, Emitter<LocationState> emit) {
    final location = LocationInput.dirty(event.location);
    emit(state.copyWith(
      locationInput: location,
      fetchedCities: [],
    ));
  }

  void _onLocationFormSubmitted(
      LocationFormSubmitted event, Emitter<LocationState> emit) async {
    if (state.city == null) {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
      return;
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final profile = _profileRepository.currentProfile;
    final label = state.city?.address.label;
    final lat = state.city?.position.lat;
    final lng = state.city?.position.lng;
    final range = state.range;

    final myGeoHash = MyGeoHash();
    final geohash = myGeoHash.geoHashForLocation(GeoPoint(lat!, lng!));

    var location = Location(
        label: label!,
        position: Position(coordinates: [lat, lng], geohash: geohash));

    final updatedProfile = profile.copyWith(location: location, range: range);
    try {
      _profileRepository.edit(
          id: _authenticationRepository.currentUser.id,
          profile: updatedProfile);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  void _onLocationInputValueChanged(
      LocationInputValueChanged event, Emitter<LocationState> emit) async {
    List<GeocodeCity> fetchedCities =
        await _locationRepository.fetchCityData(event.location);
    emit(state.copyWith(fetchedCities: fetchedCities));
  }

  void _onRangeValueChanged(
      RangeValueChanged event, Emitter<LocationState> emit) {
    emit(state.copyWith(range: event.range));
  }

  void _listenToProfile() {
    _profileSubscription = _profileRepository
        .profileStream(_authenticationRepository.currentUser.id)
        .listen((profile) => {
              if (profile.location != _cachedProfile.location)
                {
                  add(LocationLoaded(profile)),
                  _cachedProfile = profile,
                }
            });
  }

  @override
  Future<void> close() {
    _profileSubscription.cancel();
    return super.close();
  }
}
