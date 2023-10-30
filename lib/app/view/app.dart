import 'package:bimbeer/core/presentation/theme.dart';
import 'package:bimbeer/features/chat/bloc/chat_bloc.dart';
import 'package:bimbeer/features/chat/bloc/conversation_bloc.dart';
import 'package:bimbeer/features/chat/data/repositories/message_repository.dart';
import 'package:bimbeer/features/location/data/repositories/location_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/router/app_router.dart';
import '../../features/authentication/data/repositories/authentication_repository.dart';
import '../../features/beer/bloc/beer_list_bloc.dart';
import '../../features/location/bloc/location_bloc.dart';
import '../../features/navigation/cubit/navigation_cubit.dart';
import '../../features/pairs/bloc/pairs_bloc.dart';
import '../../features/pairs/data/repositories/interactions_repository.dart';
import '../../features/personalInfo/bloc/personal_info_bloc.dart';
import '../../features/profile/bloc/avatar_bloc.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/profile/data/repositories/storage_repository.dart';
import '../bloc/app_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoriesProvider();
  }
}

class RepositoriesProvider extends StatelessWidget {
  RepositoriesProvider({super.key});

  final authenticationRepository = AuthenticaionRepository()..user.first;
  final profileRepository = ProfileRepository();
  final storageRepository = StorageRepository();
  final locationRepository = LocationRepository();
  final interactionsRepository = InteractionsRepository();
  final messageRepository = MessageRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: profileRepository),
        RepositoryProvider.value(value: storageRepository),
        RepositoryProvider.value(value: locationRepository),
        RepositoryProvider.value(value: interactionsRepository),
        RepositoryProvider.value(value: messageRepository),
      ],
      child: const AppBlocProvider(),
    );
  }
}

class AppBlocProvider extends StatefulWidget {
  const AppBlocProvider({super.key});

  @override
  State<AppBlocProvider> createState() => _AppBlocProviderState();
}

class _AppBlocProviderState extends State<AppBlocProvider> {
  @override
  Widget build(BuildContext context) {
    final appBloc = AppBloc(
      authenticationRepository: context.read<AuthenticaionRepository>(),
      profileRepository: context.read<ProfileRepository>(),
    );

    return BlocProvider.value(value: appBloc, child: const BlocProviders());
  }
}

class BlocProviders extends StatelessWidget {
  const BlocProviders({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationCubit = NavigationCubit();

    final personalInfoBloc =
        PersonalInfoBloc(profileRepository: context.read<ProfileRepository>());

    final beerBloc = BeerListBloc(
        storageRepository: context.read<StorageRepository>(),
        profileRepository: context.read<ProfileRepository>());

    final avatarBloc = AvatarBloc(
        storageRepository: context.read<StorageRepository>(),
        profileRepository: context.read<ProfileRepository>());

    final locationBloc = LocationBloc(
      profileRepository: context.read<ProfileRepository>(),
      locationRepository: context.read<LocationRepository>(),
    );

    final pairsBloc = PairsBloc(
      profileRepository: context.read<ProfileRepository>(),
      interactionsRepository: context.read<InteractionsRepository>(),
    );

    final chatBloc = ChatBloc(
      profileRepository: context.read<ProfileRepository>(),
      interactionsRepository: context.read<InteractionsRepository>(),
      messageRepository: context.read<MessageRepository>(),
    );

    final conversationBloc =
        ConversationBloc(messageRepository: context.read<MessageRepository>());

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: personalInfoBloc),
        BlocProvider.value(value: navigationCubit),
        BlocProvider.value(value: beerBloc),
        BlocProvider.value(value: avatarBloc),
        BlocProvider.value(value: locationBloc),
        BlocProvider.value(value: pairsBloc),
        BlocProvider.value(value: chatBloc),
        BlocProvider.value(value: conversationBloc),
      ],
      child: const AppStartupEventsDispatcher(),
    );
  }
}

class AppStartupEventsDispatcher extends StatelessWidget {
  const AppStartupEventsDispatcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      if (state.status == AppStatus.authenticated) {
        context
            .read<PersonalInfoBloc>()
            .add(PersonalInfoLoaded(context.read<AppBloc>().state.profile));
        context
            .read<LocationBloc>()
            .add(LocationInitialized(context.read<AppBloc>().state.profile));
        context.read<BeerListBloc>().add(
            BeerListFetched(profile: context.read<AppBloc>().state.profile));
        context
            .read<PairsBloc>()
            .add(PairsFetched(context.read<AppBloc>().state.user.id));
        context.read<ChatBloc>().add(
            ChatListFetched(userId: context.read<AppBloc>().state.user.id));
      }
      return AppRunner();
    });
  }
}

class AppRunner extends StatelessWidget {
  AppRunner({super.key});

  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return MaterialApp(
          onGenerateRoute: appRouter.onGenerateRoute,
          title: 'BimBeer',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.dark,
        );
      },
    );
  }
}
