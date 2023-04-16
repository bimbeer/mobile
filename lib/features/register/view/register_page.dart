import 'package:bimbeer/features/register/view/widgets/action_buttons.dart';
import 'package:flutter/material.dart';
import '../../../core/presentation/widgets/exit_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterView();
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

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
              child: ExitButton(),
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
                  const RegisterForm(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
        TextInput(
          hintText: 'Email',
        ),
        TextInput(
          hintText: 'Password',
        ),
        SizedBox(
          height: 20,
        ),
        SignUpActionButtons(),
      ]),
    );
  }
}

class TextInput extends StatelessWidget {
  final String hintText;

  const TextInput({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
            constraints: const BoxConstraints(maxWidth: 300),
            hintText: hintText,
            contentPadding: const EdgeInsets.only(left: 20),
            filled: true,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor));
  }
}
