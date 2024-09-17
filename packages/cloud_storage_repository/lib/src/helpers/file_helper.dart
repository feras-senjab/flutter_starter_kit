import 'dart:io';
import 'package:mime_type/mime_type.dart';

class FileHelper {
  /// Check if the file is an image (JPG, PNG, etc.)
  static bool isImageFile(File file) {
    final mimeType = mime(file.path);
    return mimeType != null && mimeType.startsWith('image/');
  }

  /// Check if the file is a PDF
  static bool isPdfFile(File file) {
    final mimeType = mime(file.path);
    return mimeType == 'application/pdf';
  }

  /// Check if the file size is within the allowed limit (size in bytes)
  static bool isFileSizeAccepted(File file, int maxSizeInBytes) {
    return file.lengthSync() <= maxSizeInBytes;
  }

  /// Converts bytes to a human-readable string format.
  ///
  /// Examples:
  /// - 1024 bytes will be formatted as "1.00 KB".
  /// - 1048576 bytes will be formatted as "1.00 MB".
  static String formatBytes(int bytes) {
    const int kb = 1024;
    const int mb = kb * 1024;

    if (bytes >= mb) {
      return '${(bytes / mb).toStringAsFixed(2)} MB';
    } else if (bytes >= kb) {
      return '${(bytes / kb).toStringAsFixed(2)} KB';
    } else {
      return '$bytes bytes';
    }
  }
}
