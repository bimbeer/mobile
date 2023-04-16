import 'package:bimbeer/features/onboard/view/widgets/welcome_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboard_bloc.dart';
import 'widgets/action_buttons.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardBloc(),
      child: const OnboardView(),
    );
  }
}

class OnboardView extends StatelessWidget {
  const OnboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardBloc, OnboardState>(
      listener: (context, state) {
        if (state is OnboardCreateAccount) {
          Navigator.of(context).pushNamed(state.route);
        } else if (state is OnboardSignIn) {
          Navigator.of(context).pushNamed(state.route);
        }
        context.read<OnboardBloc>().add(OnboardReset());
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Stack(
          children: const [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: WelcomeText(),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ActionButtons(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
