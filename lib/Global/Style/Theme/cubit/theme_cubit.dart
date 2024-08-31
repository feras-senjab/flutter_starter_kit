import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/app_theme.dart';
import 'package:flutter_starter_kit/Global/Style/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> with WidgetsBindingObserver {
  /// The key for sharedPreferences Storage
  final String themePreferenceKey;
  ThemeCubit({required this.themePreferenceKey})
      : super(ThemeState(
          appTheme: _getSystemTheme(),
          isUsingSystemTheme: true,
        )) {
    // Set the system UI overlay style to fit initial theme
    _setSystemUIOverlayStyle(
        state.appTheme == AppTheme.light ? Brightness.light : Brightness.dark);
    // Add observer to listen for system theme changes
    _addObserver();
    // Load the theme during initialization
    _loadTheme();
  }

  // Set the system UI overlay style to fit brightness
  void _setSystemUIOverlayStyle(Brightness brightness) {
    SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      statusBarColor: brightness == Brightness.light
          ? AppColors.systemStatusBarColorLight
          : AppColors.systemStatusBarColorDark,
      systemNavigationBarColor: brightness == Brightness.light
          ? AppColors.systemNavigationBarColorLight
          : AppColors.systemNavigationBarColorDark,
      statusBarIconBrightness:
          brightness == Brightness.light ? Brightness.dark : Brightness.light,
      statusBarBrightness: brightness, // For iOS
      systemNavigationBarIconBrightness: brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light, // For Android
    );

    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  }

  // Override the emit function to update the system UI overlay style
  @override
  void emit(ThemeState state) {
    super.emit(state);
    // Call the function to set the system UI overlay style when theme changes
    _setSystemUIOverlayStyle(
        state.appTheme == AppTheme.light ? Brightness.light : Brightness.dark);
  }

  /// Adds the observer to listen for system theme changes
  void _addObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Removes the observer to stop listening for system theme changes
  void _removeObserver() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    var theme = _getSystemTheme();
    emit(state.copyWith(appTheme: theme, isUsingSystemTheme: true));
  }

  @override
  Future<void> close() {
    // Remove observer when the cubit is closed
    _removeObserver();
    return super.close();
  }

  /// Gets the current system theme (light or dark)
  static AppTheme _getSystemTheme() {
    final Brightness systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final systemTheme =
        systemBrightness == Brightness.light ? AppTheme.light : AppTheme.dark;
    return systemTheme;
  }

  /// Loads the theme from shared preferences or defaults to the system theme
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeName = prefs.getString(themePreferenceKey);

      if (themeName != null) {
        // If a theme is stored, use it
        developer.log('$themeName theme is loaded..');
        final savedTheme =
            AppTheme.values.firstWhere((theme) => theme.name == themeName);
        emit(state.copyWith(appTheme: savedTheme, isUsingSystemTheme: false));
        // Stop observing system theme changes if a custom theme is set
        _removeObserver();
      } else {
        // If no theme is stored, use the system theme
        emit(state.copyWith(
            appTheme: _getSystemTheme(), isUsingSystemTheme: true));
      }
    } catch (error, stackTrace) {
      // Log the error for debugging
      developer.log(
        'Error loading theme: $error',
        error: error,
        stackTrace: stackTrace,
      );

      // Fallback to system theme if an error occurs
      emit(state.copyWith(
          appTheme: _getSystemTheme(), isUsingSystemTheme: true));
    }
  }

  /// Saves the selected theme to shared preferences
  Future _saveTheme(AppTheme theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(themePreferenceKey, theme.name);
      developer.log('${theme.name} theme is stored..');
    } catch (error, stackTrace) {
      developer.log(
        'Error saving theme: $error',
        error: error,
        stackTrace: stackTrace,
      );
      // rethrow the error for the callers to react..
      rethrow;
    }
  }

  /// Sets the theme and optionally updates the UI on save error
  ///
  /// [updateUIOnStorageError] : represents whether to update ui even if storing theme fails.
  void setTheme(
    AppTheme theme, {
    bool updateUIOnStorageError = false,
  }) async {
    if (state.isUsingSystemTheme || state.appTheme != theme) {
      try {
        await _saveTheme(theme);
        emit(state.copyWith(appTheme: theme, isUsingSystemTheme: false));
        // Stop observing system theme changes when a custom theme is set
        _removeObserver();
      } catch (error, stackTrace) {
        developer.log(
          'Error saving theme: $error',
          error: error,
          stackTrace: stackTrace,
        );
        // UI update based on updateUIOnStorageError
        if (updateUIOnStorageError) {
          emit(state.copyWith(
              appTheme: theme, isUsingSystemTheme: theme == _getSystemTheme()));
        }
      }
    }
  }

  /// Remove stored theme from shared preferences if it exists
  Future _removeThemeFromStorage() async {
    try {
      // Remove stored theme if it exists..
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(themePreferenceKey);
    } catch (error, stackTrace) {
      developer.log(
        'Error removing stored theme: $error',
        error: error,
        stackTrace: stackTrace,
      );
      // rethrow the error for the callers to react..
      rethrow;
    }
  }

  /// Resets to the default system theme and re-adds observer
  ///
  /// [updateUIOnStorageError] : represents whether to update ui even if removing stored theme fails.
  void setDefaultTheme({
    bool updateUIOnStorageError = false,
  }) async {
    try {
      // Remove stored theme
      await _removeThemeFromStorage();
      // Emit system theme
      emit(state.copyWith(
          appTheme: _getSystemTheme(), isUsingSystemTheme: true));
      // Start observing system theme changes
      _addObserver();
    } catch (error, stackTrace) {
      developer.log(
        'Error setting default theme: $error',
        error: error,
        stackTrace: stackTrace,
      );
      // UI update based on updateUIOnStorageError
      if (updateUIOnStorageError) {
        emit(state.copyWith(
            appTheme: _getSystemTheme(), isUsingSystemTheme: true));
      }
    }
  }
}
