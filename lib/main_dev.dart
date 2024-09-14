import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/Global/enums.dart';
import 'package:flutter_starter_kit/app.dart';

/// Main entry point for the development flavor of the app.
///
/// Usage: Run the app with the development flavor using:
/// `flutter run --target=lib/main_dev.dart --flavor dev`
void main() async {
  await App.initializeApp();
  runApp(const App(flavor: Flavor.dev));
}
