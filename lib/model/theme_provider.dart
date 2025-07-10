import 'package:flutter/material.dart';
import 'theme_manager.dart';

class ThemeProvider extends ChangeNotifier {
  String _currentTheme = 'blue';

  String get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _currentTheme = await ThemeManager.getCurrentTheme();
    notifyListeners();
  }

  Future<void> changeTheme(String themeName) async {
    await ThemeManager.setTheme(themeName);
    _currentTheme = themeName;
    notifyListeners();
  }

  ColorScheme get colorScheme => ThemeManager.getColorScheme(_currentTheme);
} 