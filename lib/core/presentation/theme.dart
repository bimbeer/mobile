import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_schemes.g.dart';

final _font = TextStyle(fontFamily: GoogleFonts.poppins().fontFamily);

final darkTheme = ThemeData.dark().copyWith(
    colorScheme: darkColorScheme,
    textTheme: TextTheme(
      displaySmall: _font,
      displayMedium: _font,
      displayLarge: _font,
      bodySmall: _font,
      bodyMedium: _font,
      bodyLarge: _font,
      headlineSmall: _font,
      headlineMedium: _font,
      headlineLarge: _font,
      titleSmall: _font,
      titleMedium: _font,
      titleLarge: _font,
      labelSmall: _font,
      labelMedium: _font,
      labelLarge: _font,
    )
);

final lightTheme = darkTheme.copyWith(
    colorScheme: lightColorScheme,
);
