import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/Components/custom_loading.dart';

class LoadingHelper {
  // Store the BuildContext when loading is shown
  static BuildContext? _loadingContext;

  // Show loading dialog
  static void showLoading(BuildContext context) {
    // Check if the dialog is already being displayed
    if (_loadingContext != null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Store the context to be able to dismiss it later
        _loadingContext = dialogContext;
        // Use a Builder to always get the latest context
        return Builder(
          builder: (BuildContext context) {
            return Scaffold(
              backgroundColor:
                  Theme.of(context).colorScheme.surface.withOpacity(0.8),
              body: const Center(
                child: CustomLoading(
                  text: 'Loading...',
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      // Reset the context when the dialog is dismissed
      _loadingContext = null;
    });
  }

  // Dismiss loading dialog
  static void dismissLoading() {
    if (_loadingContext != null && Navigator.of(_loadingContext!).canPop()) {
      Navigator.of(_loadingContext!).pop();
      _loadingContext = null; // Reset the context
    }
  }
}
