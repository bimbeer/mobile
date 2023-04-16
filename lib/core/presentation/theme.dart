import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_schemes.g.dart';

final darkTheme = ThemeData.dark().copyWith(
    colorScheme: darkColorScheme,
    textTheme: TextTheme(
      displaySmall: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
      displayMedium: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
      displayLarge: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
    )
);

final lightTheme = darkTheme.copyWith(
    colorScheme: lightColorScheme,
);
