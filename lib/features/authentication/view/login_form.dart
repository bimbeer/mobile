import 'package:bimbeer/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../app/bloc/app_bloc.dart';
import '../../../core/router/app_router.dart';
import '../cubit/login_cubit.dart';
import 'widgets/facebook_login_button.dart';
import 'widgets/form_buttons_divider.dart';
import 'widgets/google_login_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoute.profile, (route) => false);
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure')));
        }
      },
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        _EmailInput(),
        const SizedBox(
          height: 10,
        ),
        _PasswordInput(),
        const SizedBox(
          height: 20,
        ),
        _LoginButton(),
        const SizedBox(
          height: 50,
        ),
        const FormButtonsDivider(),
        const SizedBox(
          height: 20,
        ),
        const GoogleLoginButton(),
        const SizedBox(
          height: 10,
        ),
        const FacebookLoginButton(),
      ]),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                errorText:
                    state.email.isNotValid && state.email.value.isNotEmpty
                        ? 'Invalid email'
                        : null,
                constraints: const BoxConstraints(maxWidth: 300),
                hintText: 'Email',
                contentPadding: const EdgeInsets.only(left: 20),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor));
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            obscureText: true,
            decoration: InputDecoration(
                errorText:
                    state.password.isNotValid && state.password.value.isNotEmpty
                        ? 'Invalid password'
                        : null,
                constraints: const BoxConstraints(maxWidth: 300),
                hintText: 'Password',
                contentPadding: const EdgeInsets.only(left: 20),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor));
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 40,
                child: ElevatedButton(
                  key: const Key('loginForm_continue_elevatedButton'),
                  onPressed: () {
                    context.read<LoginCubit>().logInWithCredentials();
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                        color: Theme.of(context).colorScheme.primary)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Theme.of(context).colorScheme.primary;
                      }
                      return null;
                    }),
                  ),
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.email),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Login',
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
      },
    );
  }
}
