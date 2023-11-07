import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../core/presentation/widgets/edit_screen_title.dart';
import '../bloc/personal_info_bloc.dart';
import 'personal_info_form.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PersonalInfoView();
  }
}

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: reset fields values on exit - without save
    return BlocListener<PersonalInfoBloc, PersonalInfoState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('All fields are required')));
        }
        if (state.status == FormzSubmissionStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Personal info updated')));
        }
      },
      child: const Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            EditScreenTitle(
              pageTitle: 'Edit personal info',
            ),
            SizedBox(
              height: 30,
            ),
            PersonalInfoForm(),
          ]),
        )),
      ),
    );
  }
}
