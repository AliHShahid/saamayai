import 'package:flutter/material.dart';
import 'theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _theme = AppThemes.whiteClassic; // default theme
  String _themeName = "White";

  ThemeData get theme => _theme;
  String get themeName => _themeName;

  void setTheme(String themeName) {
    if (themeName == "Dark") {
      _theme = AppThemes.dark;
    } else {
      _theme = AppThemes.whiteClassic;
      themeName = "White"; // Ensure consistency
    }
    _themeName = themeName;
    notifyListeners();
  }
}
