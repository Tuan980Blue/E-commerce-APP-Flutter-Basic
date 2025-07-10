import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _themeKey = 'selected_theme';
  
  // Danh sách các theme có sẵn
  static final Map<String, ColorScheme> _themes = {
    'blue': ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
    'green': ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
    'purple': ColorScheme.fromSeed(seedColor: const Color(0xFF9C27B0)),
    'orange': ColorScheme.fromSeed(seedColor: const Color(0xFFFF9800)),
    'red': ColorScheme.fromSeed(seedColor: const Color(0xFFF44336)),
    'teal': ColorScheme.fromSeed(seedColor: const Color(0xFF009688)),
    'pink': ColorScheme.fromSeed(seedColor: const Color(0xFFE91E63)),
    'indigo': ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5)),
  };

  // Lấy theme hiện tại
  static Future<String> getCurrentTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'blue';
  }

  // Lưu theme được chọn
  static Future<void> setTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeName);
  }

  // Lấy ColorScheme theo tên theme
  static ColorScheme getColorScheme(String themeName) {
    return _themes[themeName] ?? _themes['blue']!;
  }

  // Lấy danh sách tất cả themes
  static Map<String, ColorScheme> getAllThemes() {
    return _themes;
  }

  // Lấy danh sách tên themes
  static List<String> getThemeNames() {
    return _themes.keys.toList();
  }

  // Lấy tên hiển thị cho theme
  static String getThemeDisplayName(String themeName) {
    switch (themeName) {
      case 'blue': return 'Xanh dương';
      case 'green': return 'Xanh lá';
      case 'purple': return 'Tím';
      case 'orange': return 'Cam';
      case 'red': return 'Đỏ';
      case 'teal': return 'Xanh ngọc';
      case 'pink': return 'Hồng';
      case 'indigo': return 'Chàm';
      default: return 'Xanh dương';
    }
  }
} 