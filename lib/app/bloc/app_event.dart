part of 'app_bloc.dart';

abstract class AppEvent {
  const AppEvent();
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

class _AppUserChanged extends AppEvent {
  const _AppUserChanged(this.user);

  final User user;
}

class _AppUserProfileChanged extends AppEvent {
  const _AppUserProfileChanged({required this.user, required this.profile});

  final User user;
  final Profile profile;
}
