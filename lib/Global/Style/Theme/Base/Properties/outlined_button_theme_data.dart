import 'package:flutter/material.dart';

import '../../theme_manager.dart';

class BaseOutlinedButtonThemeData {
  static OutlinedButtonThemeData get property {
    ColorScheme colorScheme = ThemeManager().colorScheme;

    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary, // Text color
        side: BorderSide(
          color: colorScheme.primary, // Border color
        ),
        disabledForegroundColor:
            colorScheme.onSurface.withOpacity(0.38), // Disabled text color
        disabledBackgroundColor: colorScheme.onSurface
            .withOpacity(0.12), // Disabled background color
      ),
    );
  }
}
