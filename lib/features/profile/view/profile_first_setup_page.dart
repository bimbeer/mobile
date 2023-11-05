import 'package:bimbeer/features/beer/view/beer_tiles.dart';
import 'package:bimbeer/features/location/view/location_form_inputs.dart';
import 'package:bimbeer/features/personalInfo/view/personal_info_form_inputs.dart';
import 'package:flutter/material.dart';

class ProfileFirstSetupPage extends StatelessWidget {
  const ProfileFirstSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileFirstSetupView();
  }
}

class _ProfileFirstSetupView extends StatefulWidget {
  @override
  State<_ProfileFirstSetupView> createState() => _ProfileFirstSetupViewState();
}

class _ProfileFirstSetupViewState extends State<_ProfileFirstSetupView> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
        child: Stepper(
          
          type: StepperType.horizontal,
          currentStep: _step,
          onStepCancel: () {
            setState(() {
              if (_step > 0) {
              _step -= 1;
              }
            });
          },
          onStepContinue: () {
            setState(() {
              // if (_step == 2) {
              //   context.read<ProfileFirstSetupBloc>().add(
              //       ProfileFirstSetupFinished(
              //           context.read<ProfileFirstSetupBloc>().state.profile));
              // }
              _step += 1;
            });
          },
          onStepTapped: (int value) {
            setState(() {
              _step = value;
            });
          },
          steps: <Step>[
            Step(
              isActive: _step >= 0,
              state: _step <= 0 ? StepState.editing : StepState.complete,
              title: const Text('Personal Information'),
              content: const PersonalInfoFormInputs(),
            ),
            Step(
              isActive: _step >= 1,
              state: _step <= 1 ? StepState.editing : StepState.complete,
              title: const Text('Location'),
              content: const LocationFormInputs(),
            ),
            Step(
              isActive: _step >= 2,
              state: StepState.complete,
              title: const Text('Beers'),
              content: const SingleChildScrollView(child: BeerTiles()),
            ),
          ],
        ),
      ),
    );
  }
}
