import 'dart:async';

import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../features/authentication/models/user.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/profile/models/profile.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(
      {required AuthenticaionRepository authenticationRepository,
      required ProfileRepository profileRepository,
      required ProfileBloc profileBloc})
      : _authenticationRepository = authenticationRepository,
        _profileRepository = profileRepository,
        _profileBloc = profileBloc,
        super(const AppState.loading()) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    _userSubscription = _authenticationRepository.user.listen((user) {
      _profileSubscription = _profileRepository.profileStream(user.id).listen((profile) {
        add(_AppUserChanged(user, profile));
        _profileBloc.add(ProfileFetched(profile: profile));
      });
    });

    _authenticationRepository.user.first
        .then((user) => {_profileRepository.get(user.id)});
  }

  final AuthenticaionRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;
  final ProfileRepository _profileRepository;
  late final StreamSubscription<Profile> _profileSubscription;
  final ProfileBloc _profileBloc;

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) {
    emit(!event.user.isEmpty
        ? AppState.authenticated(event.user, event.profile)
        : const AppState.unauthenticated());
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _profileSubscription.cancel();
    _userSubscription.cancel();
    return super.close();
  }
}
