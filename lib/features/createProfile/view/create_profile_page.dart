import 'package:bimbeer/app/bloc/app_bloc.dart';
import 'package:bimbeer/features/beer/view/beer_page.dart';
import 'package:bimbeer/features/location/bloc/location_bloc.dart';
import 'package:bimbeer/features/location/view/location_page.dart';
import 'package:bimbeer/features/personalInfo/bloc/personal_info_bloc.dart';
import 'package:bimbeer/features/personalInfo/view/personal_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProfilePage extends StatelessWidget {
  const CreateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MultiStepForm(),
    );
  }
}

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final List<Widget> _pages = [
    const PersonalInfoPage(),
    const LocationPage(),
    const BeerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your profile'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                if (_currentPage > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              },
              child: const Text('Previous'),
            ),
            MaterialButton(
              onPressed: () {
                if (_currentPage < _pages.length - 1) {
                  if (_currentPage == 0) {
                    final userId = context.read<AppBloc>().state.user.id;
                    final profile = context.read<AppBloc>().state.profile;
                    context
                        .read<PersonalInfoBloc>()
                        .add(FormSubmitted(userId: userId, profile: profile));
                  } else if (_currentPage == 1) {
                    final userId = context.read<AppBloc>().state.user.id;
                    final profile = context.read<AppBloc>().state.profile;
                    context.read<LocationBloc>().add(LocationFormSubmitted(
                        userId: userId, profile: profile));
                  }
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                } else {
                  // TODO navigate to profile if submit
                }
              },
              child: Text(_currentPage < _pages.length - 1 ? 'Next' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
