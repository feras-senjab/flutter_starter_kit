import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/Base/Properties/helpers/widget_state_helper.dart';

import '../../theme_manager.dart';
import 'models/color_pair.dart';

class BaseInputDecorationTheme {
  static InputDecorationTheme get property {
    final colorScheme = ThemeManager().colorScheme;
    //final brightness = ThemeManager().brightness;

    //--------------- Colors & ColorPairs ---------------//
    final ColorPair fillColorDefaultPair = ColorPair(
      light: colorScheme.surfaceContainerLow,
      dark: colorScheme.surfaceContainerLow,
    );

    final ColorPair fillColorDisabledPair = ColorPair(
      light: colorScheme.surfaceContainerHigh,
      dark: colorScheme.surfaceContainerHigh,
    );

    final ColorPair labelDefaultPair = ColorPair(
      light: colorScheme.primary,
      dark: Colors.white70,
    );

    final ColorPair labelDisabledPair = ColorPair(
      light: Colors.grey,
      dark: Colors.grey.shade600,
    );

    const Color hintColor = Colors.grey;
    final Color errorColor = colorScheme.error;
    final Color borderColor = colorScheme.primary;
    //---------------------------------------------------//

    return InputDecorationTheme(
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: WidgetStateHelper.resolveColorForState(
        defaultPair: fillColorDefaultPair,
        disabledPair: fillColorDisabledPair,
      ),
      labelStyle: WidgetStateHelper.widgetStateTextStyleColor(
        baseTextStyle: const TextStyle(),
        defaultPair: labelDefaultPair,
        disabledPair: labelDisabledPair,
      ),
      floatingLabelStyle: WidgetStateHelper.widgetStateTextStyleColor(
        baseTextStyle: const TextStyle(),
        defaultPair: labelDefaultPair,
        disabledPair: labelDisabledPair,
      ),
      hintStyle: const TextStyle(
        color: hintColor,
      ),
      errorStyle: TextStyle(
        color: errorColor,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: borderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: borderColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: errorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: errorColor,
          width: 2,
        ),
      ),
    );
  }
}
