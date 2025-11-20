// theme_manager.dart
import 'package:flutter/material.dart';

class ThemeManager {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
  
  static void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
  
  static bool get isDarkMode => themeMode.value == ThemeMode.dark;
}