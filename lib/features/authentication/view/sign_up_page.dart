import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/login_cubit.dart';
import '../cubit/sign_up_cubit.dart';
import 'sign_up_form.dart';
import '../../../core/presentation/widgets/pop_page_button.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SignUpCubit(context.read<AuthenticaionRepository>()),
        ),
        BlocProvider(
          create: (context) => LoginCubit(context.read<AuthenticaionRepository>()),
        ),
      ],
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 20, 0),
              child: PopPageButton(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('CREATE ACCOUNT',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(letterSpacing: 3)),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(width: 300, child: SignUpForm()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
