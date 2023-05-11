import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/asset_path.dart';
import '../../cubit/login_cubit.dart';

class FacebookLoginButton extends StatelessWidget {
  const FacebookLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () => context.read<LoginCubit>().logInWithFacebook(),
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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(AssetPath.facebookLogo, width: 20),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Sign in with Facebook',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white, letterSpacing: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}