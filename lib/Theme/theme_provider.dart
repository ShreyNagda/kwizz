import 'package:flutter/material.dart';
import 'package:kwizz/Theme/dark_theme.dart';
import 'package:kwizz/Theme/light_theme.dart';
import 'package:kwizz/main.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = prefs.containsKey("dark") && prefs.getBool("dark")!
      ? darkTheme
      : lightTheme;
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkTheme;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeData == lightTheme) {
      themeData = darkTheme;
      await prefs.setBool("dark", true);
    } else {
      themeData = lightTheme;
      await prefs.setBool("dark", false);
    }
    print(prefs.getBool("dark"));
    notifyListeners();
  }
}
