import 'package:bimbeer/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/bloc/app_bloc.dart';
import '../../../core/presentation/widgets/edit_screen_title.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.onboard, (route) => false);
        }
      },
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: const [
          EditScreenTitle(
            pageTitle: 'Settings',
          ),
          SizedBox(
            height: 30,
          ),
          _LogoutButton(),
        ],
      )),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
      side: MaterialStateProperty.all(
          BorderSide(color: Theme.of(context).colorScheme.primary)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      )),
    );

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ElevatedButton(
          key: const Key('editLocationForm_submitButton'),
          onPressed: () =>
              context.read<AppBloc>().add(const AppLogoutRequested()),
          style: buttonStyle,
          child: Center(
            heightFactor: 1.5,
            child: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
              return state.status == AppStatus.loading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Logout',
                    );
            }),
          ),
        ));
  }
}
