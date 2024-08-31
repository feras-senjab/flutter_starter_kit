import 'package:flutter/material.dart';
import '../Base/base_theme.dart';
import '../../colors.dart';

class DarkTheme {
  static ThemeData get theme {
    return BaseTheme.base(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.primaryColorDark,
        primary: AppColors.primaryColorDark,
        onPrimary: AppColors.onPrimaryColorDark,
        onSurface: AppColors.onSurfaceColorDark,
        // Other color customizations
      ),
    );
  }
}
