import 'package:flutter/material.dart';
import 'theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _theme = AppThemes.whiteClassic; // default theme
  String _themeName = "White";

  ThemeData get theme => _theme;
  String get themeName => _themeName;

  void setTheme(String themeName) {
    if (themeName == "Nature Green") {
      _theme = AppThemes.natureGreen;
    } else if (themeName == "Freezed Ice") {
      _theme = AppThemes.freezedIce;
    } else if (themeName == "Dark") {
      _theme = AppThemes.dark;
    } else if (themeName == "White") {
      _theme = AppThemes.whiteClassic;
    }
    _themeName = themeName;
    notifyListeners();
  }
}
