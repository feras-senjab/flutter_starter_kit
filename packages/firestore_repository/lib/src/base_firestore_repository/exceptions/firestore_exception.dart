/// Custom exception class for Firestore operations errors.
class FirestoreException implements Exception {
  final String message;
  final String? code;

  FirestoreException({
    required this.message,
    this.code,
  });
}
