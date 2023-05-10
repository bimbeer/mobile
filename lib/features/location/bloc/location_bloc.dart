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
    on<LocationInitialized>(_onLocationInitialized);
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

  void _onLocationInitialized(
      LocationInitialized event, Emitter<LocationState> emit) {
    final location =
        LocationInput.dirty(_profileRepository.currentProfile.location!.label);
    final range = _profileRepository.currentProfile.range;
    emit(state.copyWith(
        locationInput: location, range: range, fetchedCities: [], city: null));
  }

  void _onLocationLoaded(LocationLoaded event, Emitter<LocationState> emit) {
    final location = LocationInput.dirty(event.profile.location!.label);
    final range = event.profile.range;
    emit(state.copyWith(locationInput: location, range: range));
  }

  void _onLocationUpdated(LocationUpdated event, Emitter<LocationState> emit) {
    final location = LocationInput.dirty(event.city.address.label);
    emit(state.copyWith(
      locationInput: location,
      city: event.city,
      fetchedCities: [],
    ));
  }

  void _onLocationFormSubmitted(
      LocationFormSubmitted event, Emitter<LocationState> emit) async {
    late final GeocodeCity city;
    if (state.locationInput.isNotValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
      return;
    }
    if (state.city == null) {
      final cities =
          await _locationRepository.fetchCityData(state.locationInput.value);
      city = cities.first;
    } else {
      city = state.city!;
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final profile = _profileRepository.currentProfile;
    final label = city.address.label;
    final lat = city.position.lat;
    final lng = city.position.lng;
    final range = state.range;

    final myGeoHash = MyGeoHash();
    final geohash = myGeoHash.geoHashForLocation(GeoPoint(lat, lng));

    var location = Location(
        label: label,
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
    emit(state.copyWith(
        status: FormzSubmissionStatus.initial,
        fetchedCities: fetchedCities,
        locationInput: LocationInput.dirty(event.location)));
  }

  void _onRangeValueChanged(
      RangeValueChanged event, Emitter<LocationState> emit) {
    emit(state.copyWith(
      range: event.range,
      status: FormzSubmissionStatus.initial,
    ));
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
