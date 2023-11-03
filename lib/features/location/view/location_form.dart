import 'package:bimbeer/app/bloc/app_bloc.dart';
import 'package:bimbeer/features/location/view/location_form_inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/location_bloc.dart';

class LocationForm extends StatelessWidget {
  const LocationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LocationInputLabel(),
        LocationFormInputs(),
        Center(child: _SaveLocationButton()),
      ],
    );
  }
}

class _LocationInputLabel extends StatelessWidget {
  const _LocationInputLabel();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
      child: Text(
        'LOCATION',
      ),
    );
  }
}

class _SaveLocationButton extends StatelessWidget {
  const _SaveLocationButton();

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
        child: ElevatedButton(
          key: const Key('editLocationForm_submitButton'),
          onPressed: () {
            final userId = context.read<AppBloc>().state.user.id;
            final profile = context.read<AppBloc>().state.profile;
            context
                .read<LocationBloc>()
                .add(LocationFormSubmitted(userId: userId, profile: profile));
          },
          style: buttonStyle,
          child: Center(
            heightFactor: 1.5,
            child: BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
              return state.status == FormzSubmissionStatus.inProgress
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Save Changes',
                    );
            }),
          ),
        ));
  }
}
