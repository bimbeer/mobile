import 'package:bimbeer/features/personalInfo/view/personal_info_form_inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/bloc/app_bloc.dart';
import '../bloc/personal_info_bloc.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PersonalInfoFormInputs(),
        Center(child: _SavePersonalInfoButton()),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }
}

class _SavePersonalInfoButton extends StatelessWidget {
  const _SavePersonalInfoButton();

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
      side: MaterialStateProperty.all(
          BorderSide(color: Theme.of(context).colorScheme.primary)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      )),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          return ElevatedButton(
            key: const Key('personalInfoForm_save_elevatedButton'),
            onPressed: () {
              final userId = context.read<AppBloc>().state.user.id;
              final profile = context.read<AppBloc>().state.profile;
              context
                  .read<PersonalInfoBloc>()
                  .add(FormSubmitted(userId: userId, profile: profile));
            },
            style: buttonStyle,
            child: const Center(
              heightFactor: 1.5,
              child: Text(
                'Save Changes',
              ),
            ),
          );
        },
      ),
    );
  }
}
