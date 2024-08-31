import 'package:flutter/material.dart';

import '../../theme_manager.dart';

class BaseBottomNavigationBarThemeData {
  static BottomNavigationBarThemeData get property {
    ColorScheme colorScheme = ThemeManager().colorScheme;

    return BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface,
    );
  }
}
