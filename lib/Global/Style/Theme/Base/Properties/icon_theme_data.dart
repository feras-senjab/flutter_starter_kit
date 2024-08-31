import 'package:flutter/material.dart';

import '../../theme_manager.dart';

class BaseIconThemeData {
  static IconThemeData get property {
    final colorScheme = ThemeManager().colorScheme;
    return IconThemeData(
      color: colorScheme.onSurface,
    );
  }
}
