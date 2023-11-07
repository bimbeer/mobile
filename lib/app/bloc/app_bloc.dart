import 'dart:async';

import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/profile_repository.dart';
import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../features/authentication/models/user.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticaionRepository authenticationRepository,
    required ProfileRepository profileRepository,
  })  : _authenticationRepository = authenticationRepository,
        _profileRepository = profileRepository,
        super(const AppState.loading()) {
    on<_AppUserChanged>(_onUserChanged);
    on<_AppUserProfileChanged>(_onProfileChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    _userSubscription = _authenticationRepository.user.listen((user) {
      add(_AppUserChanged(user));
    });
  }

  final AuthenticaionRepository _authenticationRepository;
  final ProfileRepository _profileRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) async {
    final user = event.user;
    if (!user.isEmpty) {
      var profile = await _getUserProfile(user.id);
      emit(AppState.authenticated(event.user, profile));
      _profileRepository.profileStream(user.id).listen((profile) {
        add(_AppUserProfileChanged(user: user, profile: profile));
      });
    } else {
      emit(const AppState.unauthenticated());
    }
  }

  void _onProfileChanged(_AppUserProfileChanged event, Emitter<AppState> emit) {
    emit(AppState.authenticated(event.user, event.profile));
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    emit(const AppState.unauthenticated());
    unawaited(_authenticationRepository.logOut());
  }

  Future<Profile> _getUserProfile(String userId) async {
    var profile = await _profileRepository.get(userId);
    if (profile.isEmpty) {
      await _profileRepository.add(userId, Profile.empty);
      profile = await _profileRepository.get(userId);
    }
    return profile;
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
