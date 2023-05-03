import 'package:bimbeer/core/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/router/app_router.dart';
import '../../features/authentication/data/repositories/authentication_repository.dart';
import '../../features/beer/bloc/beer_list_bloc.dart';
import '../../features/navigation/cubit/navigation_cubit.dart';
import '../../features/profile/bloc/personal_info_bloc.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/profile/data/repositories/storage_repository.dart';
import '../../features/profile/view/profile_page.dart';
import '../bloc/app_bloc.dart';

class App extends StatelessWidget {
  App(
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

  late final ProfileBloc _profileBloc =
      ProfileBloc(profileRepository: _profileRepository);
  late final PersonalInfoBloc _personalInfoBloc =
      PersonalInfoBloc(profileBloc: _profileBloc);
  late final AppBloc _appBloc = AppBloc(
    authenticationRepository: _authenticationRepository,
    profileRepository: _profileRepository,
    profileBloc: _profileBloc,
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _profileRepository),
        RepositoryProvider.value(value: _storageRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _personalInfoBloc),
          BlocProvider.value(value: _profileBloc),
          BlocProvider.value(value: _appBloc),
          BlocProvider(
            create: (_) => NavigationCubit(),
          ),
          BlocProvider(
            create: (_) => BeerListBloc(
                storageRepository: _storageRepository,
                profileRepository: _profileRepository,
                authenticationRepository: _authenticationRepository),
          ),
        ],
        child: AppView(appRouter: AppRouter()),
      ),
    );
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
