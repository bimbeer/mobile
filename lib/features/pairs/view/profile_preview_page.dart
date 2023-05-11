import 'package:bimbeer/core/presentation/widgets/pop_page_button.dart';
import 'package:bimbeer/features/profile/models/matching_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../profile/models/profile.dart';
import '../bloc/profile_card_bloc.dart';

class ProfilePreviewPage extends StatelessWidget {
  const ProfilePreviewPage({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileCardBloc(profile: MatchingProfile('', profile)),
      child: const _ProfilePreviewView(),
    );
  }
}

class _ProfilePreviewView extends StatelessWidget {
  const _ProfilePreviewView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Gallery(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Title(),
                SizedBox(
                  height: 10,
                ),
                _Subtitle(),
              ],
            ),
          ),
          const Expanded(child: _Content())
        ],
      )),
    );
  }
}

class _ExitButton extends StatelessWidget {
  const _ExitButton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
      child: Align(alignment: Alignment.topRight, child: PopPageButton()),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery();

  @override
  Widget build(BuildContext context) {
    final profileCardBloc = context.watch<ProfileCardBloc>();

    return GestureDetector(
      onPanEnd: (details) {
        if (beerListNotEmpty(context)) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            profileCardBloc.add(ProfileCardShowPreviousBeer());
          } else {
            profileCardBloc.add(ProfileCardShowNextBeer());
          }
        }
      },
      child: Container(
        color: Colors.black,
        height: 360,
        child: Stack(
          children: [
            const _ExitButton(),
            if (beerListNotEmpty(context))
              Padding(
                padding: const EdgeInsets.all(10),
                child: StepProgressIndicator(
                  totalSteps: profileCardBloc
                      .state.matchingProfile.profile.beers!.length,
                  currentStep: profileCardBloc.state.currentBeerIndex + 1,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  unselectedColor: Colors.grey,
                  roundedEdges: const Radius.circular(5),
                  padding: 2,
                ),
              ),
            if (beerListNotEmpty(context)) const _DisplayedImage()
          ],
        ),
      ),
    );
  }

  bool beerListNotEmpty(BuildContext context) {
    return context
                .read<ProfileCardBloc>()
                .state
                .matchingProfile
                .profile
                .beers
                ?.length !=
            null &&
        context
            .read<ProfileCardBloc>()
            .state
            .matchingProfile
            .profile
            .beers!
            .isNotEmpty;
  }
}

class _DisplayedImage extends StatelessWidget {
  const _DisplayedImage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.dstIn,
          child: Image.network(
            context
                .watch<ProfileCardBloc>()
                .state
                .matchingProfile
                .profile
                .beers![context.read<ProfileCardBloc>().state.currentBeerIndex]
                .link,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final profile =
        context.read<ProfileCardBloc>().state.matchingProfile.profile;

    return Text(
      '${profile.firstName} ${profile.lastName}, ${profile.age}',
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle();

  @override
  Widget build(BuildContext context) {
    final profile =
        context.read<ProfileCardBloc>().state.matchingProfile.profile;

    return Text(
      '@${profile.username}',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final profile =
        context.read<ProfileCardBloc>().state.matchingProfile.profile;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              color: Color(0xFF1a202c),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Text('${profile.description}'),
            ),
          )),
    );
  }
}
