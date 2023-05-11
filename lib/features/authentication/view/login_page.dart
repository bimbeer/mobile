import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/login_cubit.dart';
import '../data/repositories/authentication_repository.dart';
import 'login_form.dart';
import '../../../core/presentation/widgets/pop_page_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<AuthenticaionRepository>()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Column(
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 20, 0),
              child: PopPageButton(),
            ),
          ),
          Flexible(
            child: Align(
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
            ),
          )
        ],
      ),
    );
  }
}
