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
      {required ProfileRepository profileRepository,
      required LocationRepository locationRepository})
      : _profileRepository = profileRepository,
        _locationRepository = locationRepository,
        super(LocationInitial()) {
    on<LocationInitialized>(_onLocationInitialized);
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

  final ProfileRepository _profileRepository;
  final LocationRepository _locationRepository;

  void _onLocationInitialized(
      LocationInitialized event, Emitter<LocationState> emit) {
    final location = event.profile.location != null &&
            event.profile.location?.label != null &&
            event.profile.location!.label!.isNotEmpty
        ? LocationInput.dirty(event.profile.location!.label!)
        : const LocationInput.pure();
    final range = event.profile.range;
    emit(state.copyWith(
        locationInput: location, range: range, fetchedCities: [], city: null));
  }

  void _onLocationUpdated(LocationUpdated event, Emitter<LocationState> emit) {
    final location =
        event.city.address.label != null && event.city.address.label!.isNotEmpty
            ? LocationInput.dirty(event.city.address.label!)
            : const LocationInput.pure();
    emit(state.copyWith(
      locationInput: location,
      city: event.city,
      fetchedCities: [],
    ));
  }

  void _onLocationFormSubmitted(
      LocationFormSubmitted event, Emitter<LocationState> emit) async {
    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
    ));
    if (state.locationInput.isNotValid) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          locationInput: LocationInput.dirty(state.locationInput.value)));
      return;
    }

    try {
      final cities =
          await _locationRepository.fetchCityData(state.locationInput.value);
      if (cities.isEmpty || cities.length > 1) {
        emit(state.copyWith(
            status: FormzSubmissionStatus.failure,
            locationInput: LocationInput.dirty(state.locationInput.value)));
        return;
      }
      final city = cities.first;
      if (city.address.label != state.locationInput.value) {
        emit(state.copyWith(
            status: FormzSubmissionStatus.failure,
            locationInput: LocationInput.dirty(state.locationInput.value)));
        return;
      }

      final profile = event.profile;
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
        _profileRepository.edit(id: event.userId, profile: updatedProfile);
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          locationInput: LocationInput.dirty(state.locationInput.value)));
      return;
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
}
