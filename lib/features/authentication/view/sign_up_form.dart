import 'package:bimbeer/features/authentication/view/widgets/google_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../cubit/login_cubit.dart';
import '../cubit/sign_up_cubit.dart';
import 'widgets/form_buttons_divider.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.status.isSuccess) {
              Navigator.of(context).popAndPushNamed('/pairs');
            } else if (state.status.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.errorMessage ?? 'Sign Up Failure')));
            }
          },
        ),
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status.isSuccess) {
              Navigator.of(context).popAndPushNamed('/pairs');
            } else if (state.status.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.errorMessage ?? 'Sign Up Failure')));
            }
          },
        ),
      ],
      child: Form(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _EmailInput(),
          const SizedBox(
            height: 10,
          ),
          _PasswordInput(),
          const SizedBox(
            height: 20,
          ),
          _SignUpButton(),
          const SizedBox(
            height: 50,
          ),
          const FormButtonsDivider(),
          const SizedBox(
            height: 20,
          ),
          const GoogleLoginButton(),
        ]),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
            key: const Key('signUpForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<SignUpCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                errorText:
                    state.email.isNotValid && state.email.value.isNotEmpty
                        ? 'invalid email'
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
            key: const Key('signUpForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<SignUpCubit>().passwordChanged(password),
            obscureText: true,
            decoration: InputDecoration(
                errorText:
                    state.password.isNotValid && state.password.value.isNotEmpty
                        ? 'invalid password'
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

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 40,
                child: ElevatedButton(
                  key: const Key('signUpForm_continue_elevatedButton'),
                  onPressed: () {
                    context.read<SignUpCubit>().signUpFormSubmitted();
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
                          'Sign up with email',
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
