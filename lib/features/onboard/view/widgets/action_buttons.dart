import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/onboard_bloc.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OnboardButton(
          text: 'CREATE ACCOUNT',
          onPressed: () {
            context.read<OnboardBloc>().add(OnboardCreateAccountPressed());
          },
        ),
        const SizedBox(
          height: 20,
        ),
        OnboardButton(
          text: 'SIGN IN',
          onPressed: () {
            context.read<OnboardBloc>().add(OnboardSignInPressed());
          },
        ),
      ],
    );
  }
}

class OnboardButton extends StatelessWidget {
  const OnboardButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          side: MaterialStateProperty.all(
              BorderSide(color: Theme.of(context).colorScheme.primary)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          )),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Theme.of(context).colorScheme.primary;
            }
            return null;
          }),
        ),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.white, letterSpacing: 3),
        ),
      ),
    );
  }
}
