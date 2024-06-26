import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {


  ThemeData _currentTheme;
  ThemeNotifier(this._currentTheme);

  ThemeData get currentTheme => _currentTheme;

  void updateTheme(ThemeData newTheme) {
    _currentTheme = newTheme;
    notifyListeners();
  }

}