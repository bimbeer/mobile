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
  late final StreamSubscription<Profile> _profileSubscription;

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) async {
    final user = event.user;
    if (!user.isEmpty) {
      final profile = await _profileRepository.get(user.id);
      emit(AppState.authenticated(event.user, profile));
      _profileSubscription =
          _profileRepository.profileStream(user.id).listen((profile) {
        add(_AppUserProfileChanged(profile));
      });
    } else {
      emit(const AppState.unauthenticated());
    }
  }

  void _onProfileChanged(_AppUserProfileChanged event, Emitter<AppState> emit) {
    emit(AppState.authenticated(state.user, event.profile));
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    emit(const AppState.unauthenticated());
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _profileSubscription.cancel();
    return super.close();
  }
}
