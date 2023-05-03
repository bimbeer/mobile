import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/widgets/pop_page_button.dart';
import '../bloc/beer_list_bloc.dart';

class BeerPage extends StatelessWidget {
  const BeerPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<BeerListBloc>().state.status == BeerListStatus.initial) {
      context.read<BeerListBloc>().add(BeerListFetched());
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
            BlocBuilder<BeerListBloc, BeerListState>(builder: (context, state) {
              if (state.status == BeerListStatus.loadingFailed) {
                return Center(
                  child: Text(
                    'Could not load beer list. Try again later',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              } else {
                return Expanded(
                  child: GridView.builder(
                    itemCount: state.beers.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (state.status == BeerListStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.status == BeerListStatus.updateFailed) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                              duration: Duration(seconds: 2),
                              content:
                                  Text('Could not update selected beer.')));
                      } else {
                        return BeerTile(beer: state.beers[index]);
                      }
                    },
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
              }
            })
          ],
        ),
      ),
    );
  }
}

class BeerTile extends StatelessWidget {
  const BeerTile({
    required this.beer,
    super.key,
  });

  final Beer beer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.read<BeerListBloc>().add(BeerToggled(beer));
        },
        child: BlocBuilder<BeerListBloc, BeerListState>(
          buildWhen: (previous, current) {
            return (previous.selectedBeers.contains(beer) &&
                    !current.selectedBeers.contains(beer)) ||
                (!previous.selectedBeers.contains(beer) &&
                    current.selectedBeers.contains(beer));
          },
          builder: (context, state) {
            bool selected = state.selectedBeers.contains(beer);

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
                  child: Image.network(beer.link),
                ),
              ),
            );
          },
        ));
  }
}
