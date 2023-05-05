import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/edit_screen_title.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Column(children: const [
          EditScreenTitle(
            pageTitle: 'Discovery settings',
          ),
          SizedBox(height: 30,),
          LocationForm(),
        ]),
      ),
    );
  }
}
