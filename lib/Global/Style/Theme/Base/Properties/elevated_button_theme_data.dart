import 'package:flutter/material.dart';

import '../../theme_manager.dart';

class BaseElevatedButtonThemeData {
  static ElevatedButtonThemeData get property {
    final colorScheme = ThemeManager().colorScheme;

    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
      ),
    );
  }
}
