import 'dart:async';

import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/user.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticaionRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AppState.loading()) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    _userSubscription = _authenticationRepository.user
        .listen((user) => add(_AppUserChanged(user)));
  }

  final AuthenticaionRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) {
    emit(!event.user.isEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated());
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
