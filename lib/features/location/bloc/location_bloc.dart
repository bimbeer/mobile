import 'dart:async';

import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../profile/data/repositories/profile_repository.dart';
import '../models/form/address.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc(
      {required AuthenticaionRepository authenticationRepository,
      required ProfileRepository profileRepository})
      : _authenticationRepository = authenticationRepository,
        _profileRepository = profileRepository,
        super(LocationInitial()) {
    _listenToProfile();
    on<LocationLoaded>(_onLocationLoaded);
    on<AddressChanged>(_onAddressChanged);
    on<RangeChanged>(_onRangeChanged);
  }

  final AuthenticaionRepository _authenticationRepository;
  final ProfileRepository _profileRepository;
  late final StreamSubscription _profileSubscription;
  Profile _cachedProfile = Profile.empty;

  void _onLocationLoaded(LocationLoaded event, Emitter<LocationState> emit) {}

  void _onAddressChanged(AddressChanged event, Emitter<LocationState> emit) {}

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
