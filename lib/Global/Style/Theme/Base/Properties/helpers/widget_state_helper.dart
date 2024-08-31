import 'package:flutter/material.dart';

import '../../../theme_manager.dart';
import '../models/color_pair.dart';

/// A helper class that provides utilities for handling widget states with control of properties' color.
class WidgetStateHelper {
  /// Returns a [WidgetStateColor] based on the different widget states.
  ///
  /// [defaultPair] is the default color to be used for the widget.
  /// Optional [ColorPair] parameters are provided to specify colors for various states:
  /// - [disabledPair] : Color for the disabled state.
  /// - [errorPair] : Color for the error state.
  /// - [pressedPair] : Color for the pressed state.
  /// - [focusedPair] : Color for the focused state.
  /// - [hoveredPair] : Color for the hovered state.
  static WidgetStateColor resolveColorForState({
    required ColorPair defaultPair,
    ColorPair? disabledPair,
    ColorPair? errorPair,
    ColorPair? pressedPair,
    ColorPair? focusedPair,
    ColorPair? hoveredPair,
  }) {
    final brightness = ThemeManager().brightness;
    return WidgetStateColor.resolveWith(
      (states) {
        if (disabledPair != null && states.contains(WidgetState.disabled)) {
          return disabledPair.getColorForBrightness(brightness);
        }
        if (errorPair != null && states.contains(WidgetState.error)) {
          return errorPair.getColorForBrightness(brightness);
        }
        if (pressedPair != null && states.contains(WidgetState.pressed)) {
          return pressedPair.getColorForBrightness(brightness);
        }
        if (focusedPair != null && states.contains(WidgetState.focused)) {
          return focusedPair.getColorForBrightness(brightness);
        }
        if (hoveredPair != null && states.contains(WidgetState.hovered)) {
          return hoveredPair.getColorForBrightness(brightness);
        }
        // .. can add more states if needed

        // Return the default color if no specific state is matched.
        return defaultPair.getColorForBrightness(brightness);
      },
    );
  }

  /// Returns a [WidgetStateTextStyle] based on different widget states.
  ///
  /// [defaultTextStyle] is the default text style to be used for the widget.
  /// Optional [TextStyle] parameters are provided to specify styles for various states:
  /// - [disabledTextStyle] : Text style for the disabled state.
  /// - [errorTextStyle] : Text style for the error state.
  /// - [pressedTextStyle] : Text style for the pressed state.
  /// - [focusedTextStyle] : Text style for the focused state.
  /// - [hoveredTextStyle] : Text style for the hovered state.
  static WidgetStateTextStyle resolveTextStyleColorForState({
    required TextStyle defaultTextStyle,
    TextStyle? disabledTextStyle,
    TextStyle? errorTextStyle,
    TextStyle? pressedTextStyle,
    TextStyle? focusedTextStyle,
    TextStyle? hoveredTextStyle,
  }) {
    return WidgetStateTextStyle.resolveWith(
      (states) {
        if (disabledTextStyle != null &&
            states.contains(WidgetState.disabled)) {
          return disabledTextStyle;
        }
        if (errorTextStyle != null && states.contains(WidgetState.error)) {
          return errorTextStyle;
        }
        if (pressedTextStyle != null && states.contains(WidgetState.pressed)) {
          return pressedTextStyle;
        }
        if (focusedTextStyle != null && states.contains(WidgetState.focused)) {
          return focusedTextStyle;
        }
        if (hoveredTextStyle != null && states.contains(WidgetState.hovered)) {
          return hoveredTextStyle;
        }
        // .. can add more states if needed

        // Return the default textStyle if no specific state is matched.
        return defaultTextStyle;
      },
    );
  }

  /// Returns a [WidgetStateTextStyle] with dynamic color based on different widget states.
  ///
  /// This function allows for the modification of the base text style's color
  /// based on the widget's state and the specified [ColorPair] for each state.
  ///
  /// [baseTextStyle] is the base text style to be used for the widget.
  /// [defaultPair] provides the default color to be used.
  /// Optional [ColorPair] parameters are provided to specify colors for various states:
  /// - [disabledPair] : Color for the disabled state.
  /// - [errorPair] : Color for the error state.
  /// - [pressedPair] : Color for the pressed state.
  /// - [focusedPair] : Color for the focused state.
  /// - [hoveredPair] : Color for the hovered state.
  static WidgetStateTextStyle widgetStateTextStyleColor({
    required TextStyle baseTextStyle,
    required ColorPair defaultPair,
    ColorPair? disabledPair,
    ColorPair? errorPair,
    ColorPair? pressedPair,
    ColorPair? focusedPair,
    ColorPair? hoveredPair,
  }) {
    final brightness = ThemeManager().brightness;
    return WidgetStateTextStyle.resolveWith(
      (states) {
        if (disabledPair != null && states.contains(WidgetState.disabled)) {
          return baseTextStyle.copyWith(
            color: disabledPair.getColorForBrightness(brightness),
          );
        }
        if (errorPair != null && states.contains(WidgetState.error)) {
          return baseTextStyle.copyWith(
            color: errorPair.getColorForBrightness(brightness),
          );
        }
        if (pressedPair != null && states.contains(WidgetState.pressed)) {
          return baseTextStyle.copyWith(
            color: pressedPair.getColorForBrightness(brightness),
          );
        }
        if (focusedPair != null && states.contains(WidgetState.focused)) {
          return baseTextStyle.copyWith(
            color: focusedPair.getColorForBrightness(brightness),
          );
        }
        if (hoveredPair != null && states.contains(WidgetState.hovered)) {
          return baseTextStyle.copyWith(
            color: hoveredPair.getColorForBrightness(brightness),
          );
        }
        // .. can add more states if needed

        // Return baseTextStyle with the default color if no specific state is matched.
        return baseTextStyle.copyWith(
          color: defaultPair.getColorForBrightness(brightness),
        );
      },
    );
  }
}
