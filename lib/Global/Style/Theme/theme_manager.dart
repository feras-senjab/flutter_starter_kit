import 'package:flutter/material.dart';

/// Singleton class to manage and provide access to the app's current color scheme and brightness.
/// This allows for dynamic switching and customization of themes throughout the app.
class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();
  late ColorScheme _colorScheme;
  late Brightness _brightness;

  factory ThemeManager() {
    return _instance;
  }

  ThemeManager._internal();

  /// Sets the theme using the provided [colorScheme] and [brightness].
  void setTheme(
      {required ColorScheme colorScheme, required Brightness brightness}) {
    _colorScheme = colorScheme;
    _brightness = brightness;
  }

  /// Returns the current color scheme.
  ColorScheme get colorScheme => _colorScheme;

  /// Returns the current brightness setting (light or dark).
  Brightness get brightness => _brightness;
}
