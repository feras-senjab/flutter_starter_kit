import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/Components/custom_loading.dart';

class LoadingHelper {
  static OverlayEntry? _overlayEntry;

  static void showLoading(BuildContext context) {
    // Ensure the overlay is not already shown
    if (_overlayEntry != null) return;

    // Create and insert the overlay entry
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Material(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
          child: const Center(
            child: CustomLoading(
              text: 'Loading...',
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void dismissLoading() {
    // Check if the overlay exists and is still valid
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  // Optional: A method to check if loading is currently shown
  static bool isLoadingShown() {
    return _overlayEntry != null;
  }
}
