import 'package:bimbeer/features/beer/view/beer_tiles.dart';
import 'package:flutter/material.dart';

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
