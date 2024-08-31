import 'package:flutter/material.dart';
import '../Base/base_theme.dart';
import '../../colors.dart';

class LightTheme {
  static ThemeData get theme {
    return BaseTheme.base(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColorLight,
        brightness: Brightness.light,
        primary: AppColors.primaryColorLight,
        onPrimary: AppColors.onPrimaryColorLight,
        onSurface: AppColors.onSurfaceColorLight,
        // Other color customizations
      ),
    );
  }
}
