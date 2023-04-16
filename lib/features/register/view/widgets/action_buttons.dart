import 'package:bimbeer/core/presentation/asset_path.dart';
import 'package:flutter/material.dart';

class SignUpActionButtons extends StatelessWidget {
  const SignUpActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          _SignUpButton(
            text: 'Sign up',
            onPressed: () {},
            icon: const Icon(Icons.email),
          ),
          const SizedBox(height: 50,),
          const _Divider(),
          const SizedBox(height: 20,),
          _SignUpButton(
            text: 'Sign in with Google',
            onPressed: () {},
            icon: Image.asset(AssetPath().googleLogo, width: 20),
          ),
          const SizedBox(height: 10,),
          _SignUpButton(
            text: 'Sign in with Facebook',
            onPressed: () {},
            icon: Image.asset(AssetPath().facebookLogo, width: 20),
          )
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: icon,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
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
