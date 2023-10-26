import 'package:bimbeer/app/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/location_bloc.dart';

class LocationForm extends StatefulWidget {
  const LocationForm({super.key});

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  late final TextEditingController _locationInputController;

  @override
  void initState() {
    _locationInputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fetchedCities = context.watch<LocationBloc>().state.fetchedCities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LocationInputLabel(),
        _LocationInput(_locationInputController),
        if (fetchedCities != null && fetchedCities.isNotEmpty)
          _SearchResults(_locationInputController),
        const SizedBox(
          height: 20,
        ),
        const _RangeSliderLabel(),
        const _RangeSlider(),
        const SizedBox(
          height: 20,
        ),
        const Center(child: _SaveLocationButton()),
      ],
    );
  }

  @override
  void dispose() {
    _locationInputController.clear();
    super.dispose();
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

class _LocationInput extends StatelessWidget {
  const _LocationInput(TextEditingController locationInputController)
      : _locationInputController = locationInputController;

  final TextEditingController _locationInputController;

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationBloc>().state.locationInput;
    _locationInputController.text = location.value;

    return TextFormField(
      controller: _locationInputController,
      key: const Key('editLocationForm_locationInput_textField'),
      onChanged: (value) =>
          {context.read<LocationBloc>().add(LocationInputValueChanged(value))},
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        errorText: location.error?.message,
        contentPadding: const EdgeInsets.only(left: 20),
        filled: true,
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults(TextEditingController locationInputController)
      : _locationInputController = locationInputController;

  final TextEditingController _locationInputController;

  @override
  Widget build(BuildContext context) {
    final fetchedCities = context.watch<LocationBloc>().state.fetchedCities;

    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: fetchedCities?.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              context
                  .read<LocationBloc>()
                  .add(LocationUpdated(fetchedCities![index]));
              _locationInputController.text =
                  fetchedCities[index].address.label;
            },
            title: Text(fetchedCities?[index].address.label ?? ''),
          );
        },
      ),
    );
  }
}

class _RangeSliderLabel extends StatelessWidget {
  const _RangeSliderLabel();

  @override
  Widget build(BuildContext context) {
    final range = context.watch<LocationBloc>().state.range;

    return Center(
      child: Text('${range.toString()} Km',
          style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _RangeSlider extends StatelessWidget {
  const _RangeSlider();

  @override
  Widget build(BuildContext context) {
    final range = context.watch<LocationBloc>().state.range;

    return Slider(
        value: range.toDouble(),
        min: LocationState.minRange.toDouble(),
        max: LocationState.maxRange.toDouble(),
        divisions: LocationState.maxRange - LocationState.minRange,
        onChanged: (range) {
          context.read<LocationBloc>().add(RangeValueChanged(range.toInt()));
        });
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
