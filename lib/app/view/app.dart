import 'package:bimbeer/core/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/router/app_router.dart';
import '../../features/authentication/data/repositories/authentication_repository.dart';
import '../bloc/app_bloc.dart';

class App extends StatelessWidget {
  const App(
      {super.key, required AuthenticaionRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  final AuthenticaionRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        ),
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
      onGenerateRoute: _appRouter.onGenerateRoute,
      title: 'BimBeer',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
