import 'package:flutter/material.dart';

import '../../theme_manager.dart';

class BaseTextButtonThemeData {
  static TextButtonThemeData get property {
    ColorScheme colorScheme = ThemeManager().colorScheme;

    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary, // Text color
        disabledForegroundColor:
            colorScheme.onSurface.withOpacity(0.38), // Disabled text color
      ),
    );
  }
}
