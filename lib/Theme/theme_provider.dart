import 'package:flutter/material.dart';
import 'package:ptinr/Theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themedata) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    print(_themeData.toString());
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
