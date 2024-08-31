import 'package:flutter/material.dart';
import 'Themes/light_theme.dart';
import 'Themes/dark_theme.dart';

enum AppTheme {
  light,
  dark,
  // You can add more new themes..
}

extension AppThemeExtension on AppTheme {
  ThemeData get themeData {
    switch (this) {
      case AppTheme.light:
        return LightTheme.theme;
      case AppTheme.dark:
        return DarkTheme.theme;
      // You can add more cases here as you introduce new themes.
      default:
        return LightTheme.theme; // default theme
    }
  }
}
