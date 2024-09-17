import 'package:cloud_storage_repository/config.dart';
import 'package:cloud_storage_repository/src/exceptions/cloud_storage_exception.dart';
import 'package:cloud_storage_repository/src/exceptions/file_exception.dart';
import 'package:cloud_storage_repository/src/helpers/file_helper.dart';

import '../service/cloud_storage_service.dart';
import 'dart:io';

/// Handles user-specific operations related to Firebase Storage,
/// such as uploading and deleting user avatars, with validation of file type and size.
class CloudStorageUsersRepository {
  final CloudStorageService _service = CloudStorageService();

  /// Uploads a user avatar to Firebase Storage after validating the file type and size.
  ///
  /// Throws [FileException] if the file type is not an image or if the file size exceeds the allowed limit.
  ///
  /// Throws [CloudStorageException] if there is an error during the upload process.
  Future<String> uploadUserAvatar({
    required String userId,
    required File file,
  }) async {
    // Check if the file is an image
    if (!FileHelper.isImageFile(file)) {
      throw FileException('Invalid file type! Only images are accepted.');
    }

    // Check if the file size is within the accepted limit
    if (!FileHelper.isFileSizeAccepted(file, Config.userAvatarMaxFileSize)) {
      throw FileException(
        'File size exceeds the maximum allowed limit of ${FileHelper.formatBytes(Config.userAvatarMaxFileSize)}.',
      );
    }

    final path = Config.userAvatarPath(userId);
    try {
      // Attempt to upload the file and retrieve the download URL
      final resultUrl = await _service.uploadFile(path, file);
      return resultUrl;
    } on CloudStorageException {
      // The exception is rethrown without additional handling.
      // This is just to indicate it's expected to be handled by the caller.
      rethrow;
    }
  }

  /// Deletes a user's avatar from Firebase Storage.
  ///
  /// Throws [CloudStorageException] if there is an error during the deletion process.
  Future<void> deleteUserAvatar({
    required String userId,
  }) async {
    final path = Config.userAvatarPath(userId);
    try {
      // Attempt to delete the file from Firebase Storage
      await _service.deleteFile(path);
    } on CloudStorageException {
      // The exception is rethrown without additional handling.
      // This is just to indicate it's expected to be handled by the caller.
      rethrow;
    }
  }
}
