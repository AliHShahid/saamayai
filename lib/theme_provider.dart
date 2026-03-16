import 'package:flutter/material.dart';
import 'theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _theme = AppThemes.whiteClassic; // default theme
  String _themeName = "White";

  ThemeData get theme => _theme;
  String get themeName => _themeName;

  void setTheme(String themeName) {
    // Enforce light theme as per user request "all pages... like light theme of login"
    _theme = AppThemes.whiteClassic;
    _themeName = "White";
    notifyListeners();
  }
}
