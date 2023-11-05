import 'package:bimbeer/app/bloc/app_bloc.dart';
import 'package:bimbeer/core/router/app_router.dart';
import 'package:bimbeer/features/beer/bloc/beer_list_bloc.dart';
import 'package:bimbeer/features/beer/view/beer_tiles.dart';
import 'package:bimbeer/features/location/bloc/location_bloc.dart';
import 'package:bimbeer/features/location/view/location_form_inputs.dart';
import 'package:bimbeer/features/personalInfo/bloc/personal_info_bloc.dart';
import 'package:bimbeer/features/personalInfo/view/personal_info_form_inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

enum ProfileFirstSetupStep { personalInfo, location, beers }

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
  int _futureStep = 0;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final personalInfoState = context.watch<PersonalInfoBloc>().state;
      final locationState = context.watch<LocationBloc>().state;
      final beerListBlocState = context.watch<BeerListBloc>().state;

      final isLoading =
          personalInfoState.status == FormzSubmissionStatus.inProgress ||
              locationState.status == FormzSubmissionStatus.inProgress ||
              beerListBlocState.status == BeerListStatus.loading;

      int getCurrentStep() {
        if (_futureStep == ProfileFirstSetupStep.location.index &&
            personalInfoState.status == FormzSubmissionStatus.success) {
          _step = _futureStep;
        } else if (_futureStep == ProfileFirstSetupStep.beers.index &&
            locationState.status == FormzSubmissionStatus.success) {
          _step = _futureStep;
        }
        return _step;
      }

      return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SafeArea(
          child: Stack(children: [
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            Opacity(
              opacity: isLoading ? 0.5 : 1,
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: getCurrentStep(),
                onStepCancel: () {
                  setState(() {
                    if (_step > 0) {
                      _step -= 1;
                      _futureStep = _step;
                    }
                  });
                },
                onStepContinue: () {
                  final userId = context.read<AppBloc>().state.user.id;
                  final profile = context.read<AppBloc>().state.profile;
                  if (_step == ProfileFirstSetupStep.personalInfo.index) {
                    context
                        .read<PersonalInfoBloc>()
                        .add(FormSubmitted(userId: userId, profile: profile));
                    setState(() => _futureStep = ProfileFirstSetupStep.location.index);
                  } else if (_step == ProfileFirstSetupStep.location.index) {
                    context.read<LocationBloc>().add(LocationFormSubmitted(
                        userId: userId, profile: profile));
                    setState(() => _futureStep =  ProfileFirstSetupStep.beers.index);
                  } else if (_step == ProfileFirstSetupStep.beers.index) {
                    if (beerListBlocState.beers.isNotEmpty) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoute.profile, (route) => false);
                    }
                  }
                },
                steps: <Step>[
                  Step(
                    isActive: _step >= ProfileFirstSetupStep.personalInfo.index,
                    state: _step <= ProfileFirstSetupStep.personalInfo.index
                        ? StepState.editing
                        : StepState.complete,
                    title: const Text('Personal Information'),
                    content: const PersonalInfoFormInputs(),
                  ),
                  Step(
                    isActive: _step >= ProfileFirstSetupStep.location.index,
                    state: _step <= ProfileFirstSetupStep.location.index
                        ? StepState.editing
                        : StepState.complete,
                    title: const Text('Location'),
                    content: const LocationFormInputs(),
                  ),
                  Step(
                    isActive: _step >= ProfileFirstSetupStep.beers.index,
                    state: StepState.complete,
                    title: const Text('Beers'),
                    content: const SingleChildScrollView(child: BeerTiles()),
                  ),
                ],
              ),
            ),
          ]),
        ),
      );
    });
  }
}
