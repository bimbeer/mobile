import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/asset_path.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AssetPath().beerLogo,
          height: 60,
        ),
        const SizedBox(
          width: 10,
        ),
        Text('Bimbeer',
            style: GoogleFonts.pacifico(
                textStyle: Theme.of(context).textTheme.headlineMedium)),
      ],
    );
  }
}
