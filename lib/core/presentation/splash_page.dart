import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import '../../features/profile/view/profile_page.dart';
import '../router/app_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.authenticated) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoute.profile, (route) => false);
        } else if (state.status == AppStatus.unauthenticated) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoute.onboard, (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: context.read<AppBloc>().state.status == AppStatus.authenticated
            ? const ProfilePage()
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
