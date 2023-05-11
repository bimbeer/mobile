import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../core/presentation/widgets/edit_screen_title.dart';
import '../bloc/location_bloc.dart';
import 'location_form.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LocationView();
  }
}

class LocationView extends StatelessWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Discovery settings updated')));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(children: const [
            EditScreenTitle(
              pageTitle: 'Discovery settings',
            ),
            SizedBox(
              height: 30,
            ),
            LocationForm(),
          ]),
        ),
      ),
    );
  }
}
