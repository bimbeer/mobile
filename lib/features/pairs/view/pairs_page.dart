import 'package:bimbeer/core/presentation/asset_path.dart';
import 'package:bimbeer/features/navigation/view/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../profile/models/profile.dart';
import '../bloc/pairs_bloc.dart';
import '../bloc/profile_card_bloc.dart';

class PairsPage extends StatelessWidget {
  const PairsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PairsView();
  }
}

class PairsView extends StatelessWidget {
  const PairsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: const [NavBar(), PairsViewContent()],
        ),
      )),
    );
  }
}

class PairsViewContent extends StatelessWidget {
  const PairsViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    MatchEngine matchEngine;

    return BlocBuilder<PairsBloc, PairsState>(
      builder: (context, state) {
        if (state is PairsNotEmpty) {
          List<SwipeItem> swipeItems = _getSwipeItems(state);
          matchEngine = MatchEngine(swipeItems: swipeItems);

          return Column(
            children: [
              ProfileCards(
                matchEngine: matchEngine,
                pairs: state.pairs,
              ),
              const SizedBox(
                height: 20,
              ),
              SwipeButtons(matchEngine),
            ],
          );
        } else if (state is PairsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Center(
              child: Text(
            'No matches found',
            style: Theme.of(context).textTheme.bodyLarge,
          ));
        }
      },
    );
  }

  List<SwipeItem> _getSwipeItems(PairsNotEmpty state) {
    final swipeItems = <SwipeItem>[
      ...state.pairs.map(
          (e) => SwipeItem(content: e, likeAction: () {}, nopeAction: () {}))
    ];
    return swipeItems;
  }
}

class ProfileCards extends StatelessWidget {
  const ProfileCards({
    super.key,
    required this.matchEngine,
    required this.pairs,
  });

  final MatchEngine matchEngine;
  final List<Profile> pairs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        height: 600,
        child: SwipeCards(
            itemBuilder: (context, index) {
              return BlocProvider(
                create: (context) => ProfileCardBloc(profile: pairs[index]),
                child: ProfileCard(matchEngine),
              );
            },
            matchEngine: matchEngine,
            onStackFinished: () {
              context.read<PairsBloc>().add(PairsFinished());
            }),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.matchEngine, {super.key});

  final MatchEngine matchEngine;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCardBloc, ProfileCardState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 10),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.network(
                        state.profile.beers![state.currentBeerIndex].link,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StepProgressIndicator(
                        totalSteps: state.profile.beers!.length,
                        currentStep: state.currentBeerIndex + 1,
                        selectedColor: Theme.of(context).colorScheme.primary,
                        unselectedColor: Colors.grey,
                        roundedEdges: const Radius.circular(5),
                        padding: 2,
                      ),
                      Flexible(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  // left button
                                  context
                                      .read<ProfileCardBloc>()
                                      .add(ProfileCardShowPreviousBeer());
                                },
                                child: const SizedBox(
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Flexible(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  // right button
                                  context
                                      .read<ProfileCardBloc>()
                                      .add(ProfileCardShowNextBeer());
                                },
                                child: const SizedBox(
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            // details button
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.profile.username ?? 'Empty'}, ${state.profile.age}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                state.profile.location?.label ?? 'Empty',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          )),
                    ])
              ],
            ),
          ),
        );
      },
    );
  }
}

class SwipeButtons extends StatelessWidget {
  const SwipeButtons(this.matchEngine, {super.key});

  final MatchEngine matchEngine;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(70, 70),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            side: BorderSide(color: Colors.red[400]!),
            foregroundColor: Colors.red[400],
          ),
          child: Icon(
            Icons.close,
            size: 40,
            color: Colors.red[300],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(70, 70),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            side: const BorderSide(color: Colors.green),
            foregroundColor: Colors.green,
          ),
          child: Image.asset(
            AssetPath.greenBeerMug,
          ),
        )
      ],
    );
  }
}
