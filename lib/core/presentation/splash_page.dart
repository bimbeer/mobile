import 'package:bimbeer/core/presentation/loading_view.dart';
import 'package:bimbeer/features/profile/bloc/profile_first_setup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import '../router/app_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            final profileFirstSetupState =
                context.read<ProfileFirstSetupBloc>().state;
            if (state.status == AppStatus.authenticated &&
                profileFirstSetupState.status ==
                    ProfileFirstSetupStatus.finished) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoute.profile, (route) => false);
            } else if (state.status == AppStatus.unauthenticated) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoute.onboard, (route) => false);
            }
          },
        ),
        BlocListener<ProfileFirstSetupBloc, ProfileFirstSetupState>(
          listener: (context, state) {
            if (state.status == ProfileFirstSetupStatus.notFinished) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoute.profileFirstSetupPage, (route) => false);
            } else if (state.status == ProfileFirstSetupStatus.finished) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoute.profile, (route) => false);
              // AppRoute.profile, (route) => false);
            }
          },
        ),
      ],
      child: const LoadingView(),
    );
  }
}
