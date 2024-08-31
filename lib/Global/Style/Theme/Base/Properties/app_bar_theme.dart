import 'package:flutter/material.dart';

import '../../theme_manager.dart';

class BaseAppBarTheme {
  static AppBarTheme get property {
    final colorScheme = ThemeManager().colorScheme;

    return AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      // titleTextStyle: TextStyle(
      //   color: colorScheme.onPrimary,
      //   fontSize: 20,
      // ),
      // iconTheme: IconThemeData(
      //   color: colorScheme.onPrimary,
      // ),
      // actionsIconTheme: IconThemeData(
      //   color: colorScheme.onPrimary,
      // ),
    );
  }
}
