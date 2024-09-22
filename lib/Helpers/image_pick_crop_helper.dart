import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// --------------- Settings classes --------------- //

/// Class to hold settings for picking an image
class ImagePickSettings {
  /// Source of the image (camera or gallery)
  final ImageSource source;

  /// Quality of the image (0-100)
  final int? imageQuality;

  /// Maximum height of the image
  final double? maxHeight;

  /// Maximum width of the image
  final double? maxWidth;

  /// Preferred camera (front or rear)
  final CameraDevice preferredCameraDevice;

  /// Whether to request full metadata
  final bool requestFullMetadata;

  ImagePickSettings({
    required this.source,
    this.imageQuality,
    this.maxHeight,
    this.maxWidth,
    this.preferredCameraDevice = CameraDevice.front,
    this.requestFullMetadata = true,
  });
}

/// Class to hold settings for cropping an image
class ImageCropSettings {
  /// Style of cropping (circular or rectangular)
  final CropStyle cropStyle;

  /// Aspect ratio for cropping
  final CropAspectRatio aspectRatio;

  /// Title of the toolbar
  final String toolbarTitle;

  /// Color of the toolbar
  final Color? toolbarColor;

  /// Color of the toolbar widgets
  final Color? toolbarWidgetColor;

  /// Whether to lock the aspect ratio
  final bool lockAspectRatio;

  ImageCropSettings({
    required this.cropStyle,
    this.aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1),
    this.toolbarTitle = 'Crop Image',
    this.toolbarColor,
    this.toolbarWidgetColor,
    this.lockAspectRatio = true,
  });
}

// -------------------- The Helper -------------------- //

/// Helper class for picking and cropping images
class ImagePickCropHelper {
  /// Method to pick an image using ImagePicker
  static Future<File?> pickImage({
    /// Use ImagePickSettings for picking
    required ImagePickSettings pickSettings,
  }) async {
    final pickedImage = await ImagePicker().pickImage(
      source: pickSettings.source,
      imageQuality: pickSettings.imageQuality,
      maxWidth: pickSettings.maxWidth,
      maxHeight: pickSettings.maxHeight,
      preferredCameraDevice: pickSettings.preferredCameraDevice,
      requestFullMetadata: pickSettings.requestFullMetadata,
    );

    if (pickedImage == null) {
      return null; // Return null if no image was picked
    }
    return File(pickedImage.path); // Return the picked image as a File
  }

  /// Method to crop an image using ImageCropper
  static Future<File?> cropImage({
    /// Path of the image to crop
    required String sourcePath,

    /// Use ImageCropSettings for cropping
    required ImageCropSettings cropSettings,
  }) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      aspectRatio: cropSettings.aspectRatio,
      uiSettings: [
        AndroidUiSettings(
          cropStyle: cropSettings.cropStyle,
          toolbarTitle: cropSettings.toolbarTitle,
          toolbarColor: cropSettings.toolbarColor,
          toolbarWidgetColor: cropSettings.toolbarWidgetColor,
          lockAspectRatio: cropSettings.lockAspectRatio,

          /// Notes:
          /// - Setting `aspectRatioPresets` doesn't take effect as `aspectRatio` is set.
          /// - In case of NOT setting `aspectRatio` on android, sadly an unlikely behavior happens,
          /// the image rotates accidently when try to resize with 2 fingers.. That's why I didn't
          /// implement `aspectRatioPresets` and used `aspectRatio`.
        ),
        IOSUiSettings(
          cropStyle: cropSettings.cropStyle,
          title: cropSettings.toolbarTitle,

          /// I Followed android with the `aspectRatio` and the `aspectRatioPresets` to have the same behavior.
        ),
        //!.. Can add WebUiSettings if web support needed.
      ],
    );

    if (croppedFile == null) {
      return null; // Return null if cropping was canceled
    }

    return File(croppedFile.path); // Return the cropped image as a File
  }

  /// Method to pick and crop an image using ImagePicker and ImageCropper
  static Future<File?> pickAndCropImage({
    /// Use ImagePickSettings for picking
    required ImagePickSettings pickSettings,

    /// Use ImageCropSettings for cropping
    required ImageCropSettings cropSettings,
  }) async {
    // Pick image..
    final pickedImage = await pickImage(pickSettings: pickSettings);

    if (pickedImage == null) {
      return null; // Return null if no image was picked
    }
    // Crop image..
    final croppedImage = await cropImage(
        sourcePath: pickedImage.path, cropSettings: cropSettings);

    if (croppedImage == null) {
      return null; // Return null if cropping was canceled
    }

    return croppedImage; // Return the final cropped image file
  }
}
