import 'package:cloud_firestore/cloud_firestore.dart';

/// A generic utility class to help with Firestore field updates based on the type [T].
/// This class provides various factory constructors for different Firestore operations
/// such as setting fields, deleting fields, incrementing numeric values, and manipulating arrays.
///
/// [T] is used to ensure type safety, ensuring the field update is appropriate for the given data type.
class FirestoreFieldUpdater<T> {
  final dynamic _fieldValue;

  /// Private constructor to initialize the field update value.
  ///
  /// [fieldValue] is the value that will be passed to Firestore for the update.
  const FirestoreFieldUpdater._({dynamic fieldValue})
      : _fieldValue = fieldValue;

  /// Returns the value to be used for the Firestore update.
  get fieldValue => _fieldValue;

  /// Factory constructor to create an update for setting a field to a new value.
  ///
  /// Example usage:
  /// ```dart
  /// FirestoreFieldUpdater.setField('newValue');
  /// ```
  factory FirestoreFieldUpdater.setField(T? value) {
    return FirestoreFieldUpdater._(fieldValue: value);
  }

  /// Creates an update to delete a field from a Firestore document.
  ///
  /// Example usage:
  /// ```dart
  /// FirestoreFieldUpdater.deleteField();
  /// ```
  factory FirestoreFieldUpdater.deleteField() {
    return FirestoreFieldUpdater._(fieldValue: FieldValue.delete());
  }

  /// Factory constructor to create an update to increment a numeric field by a specific value.
  ///
  /// Throws an [ArgumentError] if the field's type is NOT a numeric type.
  ///
  /// Example usage:
  /// ```dart
  /// FirestoreFieldUpdater.increment(5);  // for integer fields
  /// ```
  factory FirestoreFieldUpdater.increment(T number) {
    // Check If the passed generic type <T> is NOT num
    if (<T>[] is! List<num>) {
      throw ArgumentError(
          'Increment operation failed. Expected a numeric field (int or double), but recieved $T.');
    }
    return FirestoreFieldUpdater._(
        fieldValue: FieldValue.increment(number as num));
  }

  /// Factory constructor to create an update to add elements to an array field in Firestore without duplicating elements.
  ///
  /// Throws an [ArgumentError] if the field's type is NOT a [List].
  ///
  /// Warning: This works only for list of primitives. If nested data is present, Firestore might
  /// NOT detect duplicates as it uses reference comparison.
  ///
  /// Example usage:
  /// ```dart
  /// FirestoreFieldUpdater.arrayUnion([1, 2, 3]);
  /// ```
  factory FirestoreFieldUpdater.arrayUnion(List array) {
    // Check If the passed generic type <T> is NOT List
    if (<T>[] is! List<List>) {
      throw ArgumentError(
          'Array union operation failed. Expected a List field, but recieved $T.');
    }

    return FirestoreFieldUpdater._(fieldValue: FieldValue.arrayUnion(array));
  }

  /// Factory constructor to create an update to remove elements from an array field in Firestore.
  ///
  /// Throws an [ArgumentError] if the field's type is NOT a [List].
  ///
  /// Warning: This works only for lists containing primitive values. For nested data, you
  /// may need to replace the entire array.
  ///
  /// Example usage:
  /// ```dart
  /// FirestoreFieldUpdater.arrayRemove([1, 2]);
  /// ```
  factory FirestoreFieldUpdater.arrayRemove(List array) {
    // Check If the passed generic type <T> is NOT List
    if (<T>[] is! List<List>) {
      throw ArgumentError(
          'Array remove operation failed. Expected a List field, but recieved $T.');
    }

    return FirestoreFieldUpdater._(fieldValue: FieldValue.arrayRemove(array));
  }

  /// Factory constructor to create an update to set the field to the server timestamp.
  ///
  /// Throws an [ArgumentError] if the fields type is NOT a [DateTime].
  ///
  /// Example usage:
  /// ```dart
  /// FirestoreFieldUpdater.serverTimestamp();
  /// ```
  factory FirestoreFieldUpdater.serverTimestamp() {
    // Check If the passed generic type <T> is NOT DateTime
    if (<T>[] is! List<DateTime>) {
      throw ArgumentError(
          'Setting field to serverTimestamp operation failed. Expected a DateTime field, but recieved $T');
    }
    return FirestoreFieldUpdater._(fieldValue: FieldValue.serverTimestamp());
  }
}
