import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/widgets/pop_page_button.dart';
import '../bloc/beer_bloc.dart';

class BeerPage extends StatelessWidget {
  const BeerPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<BeerBloc>().state.status == BeerStatus.initial) {
      context.read<BeerBloc>().add(BeersFetched());
    }
    return const BeerView();
  }
}

class BeerView extends StatelessWidget {
  const BeerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Text(
                    'Pick your favorite beers',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      child: PopPageButton(),
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<BeerBloc, BeerState>(
              buildWhen: (prev, current) => prev.status != current.status,
              builder: (context, state) {
                return Expanded(
                  child: GridView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (state.status == BeerStatus.loading) {
                        const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.status == BeerStatus.loaded &&
                          state.beerURLs.isNotEmpty) {
                        return BeerTile(imageURL: state.beerURLs[index]);
                      }
                    },
                    itemCount: state.beerURLs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    padding: const EdgeInsets.all(40),
                    shrinkWrap: true,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BeerTile extends StatelessWidget {
  const BeerTile({
    required this.imageURL,
    super.key,
  });

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.read<BeerBloc>().add(SelectedBeer(imageURL));
        },
        child: BlocBuilder<BeerBloc, BeerState>(
          buildWhen: (previous, current) {
            return previous.status != current.status;
          },
          builder: (context, state) {
            bool selected = false;
            if (state.status == BeerStatus.selectSuccess &&
                state.selected == imageURL) {
              selected = true;
            }

            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                color: selected
                    ? const Color(0xFFd4af37)
                    : Theme.of(context).cardColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: GridTile(
                  child: Image.network(imageURL),
                ),
              ),
            );
          },
        ));
  }
}
