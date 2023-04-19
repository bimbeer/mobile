import 'package:flutter/material.dart';

import 'login_form.dart';
import 'widgets/navigate_to_onboard_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 30, 0),
              child: NavigateToOnboardButton(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('SIGN IN',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(letterSpacing: 3)),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(width: 300, child: LoginForm()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}