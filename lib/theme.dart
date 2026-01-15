import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static ThemeData natureGreen = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Colors.green.shade700,
      secondary: Colors.greenAccent,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: Colors.green.shade50,
  );

  static ThemeData freezedIce = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade300,
      secondary: Colors.cyanAccent,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: Colors.blue.shade50,
  );

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
      surface: Colors.grey.shade900,
      surfaceContainer: Colors.grey.shade800,
    ),
    scaffoldBackgroundColor: Colors.grey.shade900,
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: Colors.grey.shade800,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
  );

  // static ThemeData dark = ThemeData(
  //   brightness: Brightness.dark,
  //   colorScheme: const ColorScheme.dark(
  //     primary: Color.fromARGB(255, 206, 186, 186),
  //     secondary: Colors.grey,
  //     surface: Color.fromARGB(255, 23, 22, 22),
  //   ),
  //   textTheme: GoogleFonts.poppinsTextTheme(),
  //   // scaffoldBackgroundColor: Colors.black,
  // );
}
