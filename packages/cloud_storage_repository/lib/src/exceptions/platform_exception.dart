/// A custom exception class to handle errors related to cloud storage operations.
/// It helps to provide clear and specific error messages related to cloud storage actions.
class CloudStoragePlatformException implements Exception {
  final String message;
  CloudStoragePlatformException(this.message);

  @override
  String toString() => 'CloudStorageException: $message';
}
