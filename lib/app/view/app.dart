import 'package:bimbeer/core/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/router/app_router.dart';
import '../../features/authentication/data/repositories/authentication_repository.dart';
import '../../features/beer/bloc/beer_list_bloc.dart';
import '../../features/navigation/cubit/navigation_cubit.dart';
import '../../features/personalInfo/bloc/personal_info_bloc.dart';
import '../../features/profile/bloc/avatar_bloc.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/profile/data/repositories/storage_repository.dart';
import '../../features/profile/view/profile_page.dart';
import '../bloc/app_bloc.dart';

class App extends StatefulWidget {
  const App(
      {super.key,
      required AuthenticaionRepository authenticationRepository,
      required ProfileRepository profileRepository,
      required StorageRepository storageRepository})
      : _authenticationRepository = authenticationRepository,
        _profileRepository = profileRepository,
        _storageRepository = storageRepository;

  final AuthenticaionRepository _authenticationRepository;
  final ProfileRepository _profileRepository;
  final StorageRepository _storageRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppBloc _appBloc = AppBloc(
    authenticationRepository: widget._authenticationRepository,
  );

  late final ProfileBloc _profileBloc = ProfileBloc(
      profileRepository: widget._profileRepository,
      authenticationRepository: widget._authenticationRepository)
    ..add(ProfileFetched(profile: widget._profileRepository.currentProfile));

  late final PersonalInfoBloc _personalInfoBloc =
      PersonalInfoBloc(profileBloc: _profileBloc)
        ..add(PersonalInfoLoaded(widget._profileRepository.currentProfile));

  late final _beerBloc = BeerListBloc(
      storageRepository: widget._storageRepository,
      profileRepository: widget._profileRepository,
      authenticationRepository: widget._authenticationRepository)
    ..add(BeerListFetched());

  late final _navigationCubit = NavigationCubit();

  late final _avatarBloc = AvatarBloc(
      storageRepository: widget._storageRepository,
      authenticaionRepository: widget._authenticationRepository,
      profileRepository: widget._profileRepository);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: widget._authenticationRepository),
        RepositoryProvider.value(value: widget._profileRepository),
        RepositoryProvider.value(value: widget._storageRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _personalInfoBloc),
          BlocProvider.value(value: _profileBloc),
          BlocProvider.value(value: _appBloc),
          BlocProvider.value(value: _navigationCubit),
          BlocProvider.value(value: _beerBloc),
          BlocProvider.value(value: _avatarBloc),
        ],
        child: AppView(appRouter: AppRouter()),
      ),
    );
  }

  @override
  void dispose() {
    _appBloc.close();
    _profileBloc.close();
    _personalInfoBloc.close();
    _beerBloc.close();
    _navigationCubit.close();
    _avatarBloc.close();
    super.dispose();
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key, required AppRouter appRouter})
      : _appRouter = appRouter;

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProfilePage(),
      onGenerateRoute: _appRouter.onGenerateRoute,
      title: 'BimBeer',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
