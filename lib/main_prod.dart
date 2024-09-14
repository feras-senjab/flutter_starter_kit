import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/Global/enums.dart';
import 'package:flutter_starter_kit/app.dart';

/// Main entry point for the production flavor of the app.
///
/// Usage: Run the app with the production flavor using:
/// `flutter run --target=lib/main_prod.dart --flavor prod`
void main() async {
  await App.initializeApp();
  runApp(const App(flavor: Flavor.prod));
}
