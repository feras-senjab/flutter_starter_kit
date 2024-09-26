import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../exceptions/platform_exception.dart';

/// Manages low-level interactions with Firebase Storage,
/// such as uploading, downloading, and deleting files, while handling storage-specific exceptions.
class CloudStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  /// Uploads a file to the specified path in Firebase Storage.
  Future<String> uploadFile(String path, File file) async {
    try {
      final ref = _firebaseStorage.ref().child(path);
      final uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw CloudStoragePlatformException('Failed to upload file: $e');
    }
  }

  /// Downloads a file from the specified path in Firebase Storage.
  Future<File> downloadFile(String path, String localPath) async {
    try {
      final ref = _firebaseStorage.ref().child(path);
      final file = File(localPath);
      await ref.writeToFile(file);
      return file;
    } catch (e) {
      throw CloudStoragePlatformException('Failed to download file: $e');
    }
  }

  /// Deletes a file from the specified path in Firebase Storage.
  Future<void> deleteFile(String path) async {
    try {
      final ref = _firebaseStorage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw CloudStoragePlatformException('Failed to delete file: $e');
    }
  }
}
