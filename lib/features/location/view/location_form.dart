import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/location_bloc.dart';

class LocationForm extends StatelessWidget {
  const LocationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LocationInput(),
        const SizedBox(
          height: 20,
        ),
        const _SliderTextValue(),
        const _RangeSlider(),
      ],
    );
  }
}

class _LocationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
        child: Text(
          'ADDRESS',
        ),
      ),
      BlocBuilder<LocationBloc, LocationState>(
          buildWhen: (previous, current) => previous.address != current.address,
          builder: (context, state) {
            context
                .read<LocationBloc>()
                .add(AddressChanged(state.address.value));

            return TextFormField(
              initialValue: state.address.value,
              key: const Key('editLocationForm_addressInput_textField'),
              onChanged: (value) =>
                  {context.read<LocationBloc>().add(AddressChanged(value))},
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                errorText: state.address.error?.message,
                contentPadding: const EdgeInsets.only(left: 20),
                filled: true,
              ),
            );
          })
    ]);
  }
}

class _SliderTextValue extends StatelessWidget {
  const _SliderTextValue();

  @override
  Widget build(BuildContext context) {
    final locationBloc = context.watch<LocationBloc>();

    return Center(
      child: Text('${locationBloc.state.range.toInt().toString()} Km',
          style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _RangeSlider extends StatelessWidget {
  const _RangeSlider();

  @override
  Widget build(BuildContext context) {
    final locationBloc = context.watch<LocationBloc>();

    return Slider(
        value: locationBloc.state.range.toDouble(),
        min: LocationState.minRange.toDouble(),
        max: LocationState.maxRange.toDouble(),
        divisions: LocationState.maxRange - LocationState.minRange,
        onChanged: (range) {
          locationBloc.add(RangeChanged(range.toInt()));
        });
  }
}
