import 'package:flutter/material.dart';

import '../../theme_manager.dart';

class BaseTextTheme {
  static TextTheme get property {
    final colorScheme = ThemeManager().colorScheme;

    // Default can be found here: https://api.flutter.dev/flutter/material/TextTheme-class.html

    return TextTheme(
      // Display styles for large, attention-grabbing text
      displayLarge: TextStyle(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),

      // Headline styles for section titles
      headlineLarge: TextStyle(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),

      // Title styles for smaller section headings
      titleLarge: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      titleMedium: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
      titleSmall: const TextStyle(
        fontWeight: FontWeight.w500,
      ),

      // Body styles for main content text
      bodyLarge: const TextStyle(),
      bodyMedium: const TextStyle(),
      bodySmall: const TextStyle(),

      // Label styles for other small, actionable text
      labelLarge: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      labelMedium: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      labelSmall: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
