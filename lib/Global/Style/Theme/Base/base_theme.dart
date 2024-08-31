import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/Base/Properties/app_bar_theme.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/Base/Properties/bottom_navigation_bar_theme_data.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/Base/Properties/elevated_button_theme_data.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/Base/Properties/icon_theme_data.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/Base/Properties/input_decoration_theme.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/Base/Properties/outlined_button_theme_data.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/Base/Properties/text_button_theme_data.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/Base/Properties/text_theme.dart';

import '../theme_manager.dart';

class BaseTheme {
  static ThemeData base({
    required Brightness brightness,
    required ColorScheme colorScheme,
  }) {
    // Set the global theme values
    ThemeManager().setTheme(colorScheme: colorScheme, brightness: brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      appBarTheme: BaseAppBarTheme.property,
      bottomNavigationBarTheme: BaseBottomNavigationBarThemeData.property,
      textTheme: BaseTextTheme.property,
      inputDecorationTheme: BaseInputDecorationTheme.property,
      iconTheme: BaseIconThemeData.property,
      elevatedButtonTheme: BaseElevatedButtonThemeData.property,
      outlinedButtonTheme: BaseOutlinedButtonThemeData.property,
      textButtonTheme: BaseTextButtonThemeData.property,
      // More common styles...
    );
  }
}
