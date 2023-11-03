import 'package:bimbeer/app/bloc/app_bloc.dart';
import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/beer_list_bloc.dart';

class BeerTiles extends StatelessWidget {
  const BeerTiles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BeerListBloc, BeerListState>(builder: (context, state) {
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
                      content: Text('Could not update selected beer.')));
              } else if (state.status == BeerListStatus.loaded ||
                  state.status == BeerListStatus.updated) {
                return BeerTile(beer: state.beers[index]);
              }
              return null;
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            padding: const EdgeInsets.all(40),
            shrinkWrap: true,
          ),
        );
      }
    });
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
          final userId = context.read<AppBloc>().state.user.id;
          final profile = context.read<AppBloc>().state.profile;
          context
              .read<BeerListBloc>()
              .add(BeerToggled(userId: userId, profile: profile, beer: beer));
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
