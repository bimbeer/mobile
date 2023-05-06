import 'dart:async';

import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:rxdart/rxdart.dart';

import '../../profile/data/repositories/profile_repository.dart';
import '../data/repositories/location_repository.dart';
import '../models/form/address_input.dart';
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
    on<AddressChanged>(
      _onAddressChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: searchCitiesDebounceMs))
          .asyncExpand(mapper),
    );
    on<RangeChanged>(_onRangeChanged);
  }

  final AuthenticaionRepository _authenticationRepository;
  final ProfileRepository _profileRepository;
  final LocationRepository _locationRepository;
  late final StreamSubscription _profileSubscription;
  Profile _cachedProfile = Profile.empty;

  void _onLocationLoaded(LocationLoaded event, Emitter<LocationState> emit) {}

  void _onAddressChanged(
      AddressChanged event, Emitter<LocationState> emit) async {
    List<GeocodeCity> fetchedCities =
        await _locationRepository.fetchCityData(event.address);
    emit(state.copyWith(fetchedCities: fetchedCities));
  }

  void _onRangeChanged(RangeChanged event, Emitter<LocationState> emit) {
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
