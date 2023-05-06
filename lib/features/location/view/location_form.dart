import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/location_bloc.dart';

const int rangeChangeDebonceMs = 300;
const int locationInputChangeDebonceMs = 300;

class LocationForm extends StatelessWidget {
  const LocationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final fetchedCities = context.watch<LocationBloc>().state.fetchedCities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LocationInputLabel(),
        _LocationInput(),
        if (fetchedCities != null && fetchedCities.isNotEmpty)
          const _SearchResults(),
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
  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationBloc>().state.locationInput;

    return TextFormField(
      initialValue: location.value,
      key: const Key('editLocationForm_locationInput_textField'),
      onChanged: (value) => {
        Future.delayed(
            const Duration(milliseconds: locationInputChangeDebonceMs), () {
          context.read<LocationBloc>().add(LocationInputValueChanged(value));
        })
      },
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
  const _SearchResults();

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
                  .add(LocationUpdated(fetchedCities![index].address.label));
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
          Future.delayed(const Duration(milliseconds: rangeChangeDebonceMs),
              () {
            context.read<LocationBloc>().add(RangeValueChanged(range.toInt()));
          });
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
        onPressed: () =>
            context.read<LocationBloc>().add(LocationFormSubmitted()),
        style: buttonStyle,
        child: const Center(
          heightFactor: 1.5,
          child: Text(
            'Save Changes',
          ),
        ),
      ),
    );
  }
}
