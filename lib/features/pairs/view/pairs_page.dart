import 'package:bimbeer/features/navigation/view/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:swipe_cards/swipe_cards.dart';

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
          child: Column(
        children: const [NavBar(), ProfileCards()],
      )),
    );
  }
}

class ProfileCards extends StatelessWidget {
  const ProfileCards({super.key});

  @override
  Widget build(BuildContext context) {
    MatchEngine matchEngine;

    return BlocBuilder<PairsBloc, PairsState>(
      builder: (context, state) {
        if (state is PairsNotEmpty) {
          final swipeItems = <SwipeItem>[
            ...state.pairs.map((e) =>
                SwipeItem(content: e, likeAction: () {}, nopeAction: () {}))
          ];
          matchEngine = MatchEngine(swipeItems: swipeItems);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              height: 600,
              child: SwipeCards(
                  itemBuilder: (context, index) {
                    return BlocProvider(
                      create: (context) =>
                          ProfileCardBloc(profile: state.pairs[index]),
                      child: const ProfileCard(),
                    );
                  },
                  matchEngine: matchEngine,
                  onStackFinished: () {
                    context.read<PairsBloc>().add(PairsFinished());
                  }),
            ),
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
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

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
