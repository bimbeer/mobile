import 'package:bimbeer/features/beer/bloc/beer_list_bloc.dart';
import 'package:bimbeer/features/beer/view/beer_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/widgets/edit_screen_title.dart';

class BeerPage extends StatelessWidget {
  const BeerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BeerView();
  }
}

class BeerView extends StatelessWidget {
  const BeerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EditScreenTitle(
              pageTitle: 'Pick your favorite beers',
            ),
            BeerTiles()
          ],
        ),
      ),
    );
  }
}

class BeerTilesLayout extends StatelessWidget {
  const BeerTilesLayout({super.key});

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
        return const Expanded(
            child: Padding(
          padding: EdgeInsets.all(40),
          child: BeerTiles(),
        ));
      }
    });
  }
}
