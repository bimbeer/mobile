import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/login_cubit.dart';
import '../cubit/sign_up_cubit.dart';
import 'sign_up_view.dart';

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
