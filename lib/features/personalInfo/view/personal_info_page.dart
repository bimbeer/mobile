import 'package:bimbeer/features/profile/bloc/profile_bloc.dart';
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
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.modfied) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('Profile Succesfully updated')));
            }
          },
        ),
        BlocListener<PersonalInfoBloc, PersonalInfoState>(
          listener: (context, state) {
            if (state.status == FormzSubmissionStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('All fields are required')));
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: const [
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