import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {

  static ThemeData whiteClassic = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 36, 37, 36),
      secondary: Colors.grey,
      surface: Color.fromARGB(255, 246, 247, 246),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    // scaffoldBackgroundColor: Colors.black,
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.blue.shade400,
      secondary: Colors.cyan.shade300,
      surface: const Color(0xFF1E1E1E), // Darker surface for cards
      surfaceContainer: const Color(0xFF2C2C2C), // Slightly lighter for containers
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212), // True dark mode background
    cardColor: const Color(0xFF1E1E1E), // Explicit card color
    dividerColor: Colors.grey.shade700,
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
  );
}
