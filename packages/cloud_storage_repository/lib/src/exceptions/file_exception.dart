/// A custom exception class to handle errors related to file operations.
/// This includes issues such as invalid file types, sizes exceeding limits, ..etc.
class FileException implements Exception {
  final String message;
  FileException(this.message);

  @override
  String toString() => 'FileException: $message';
}
