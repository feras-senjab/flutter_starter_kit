import 'package:cloud_firestore/cloud_firestore.dart';

import 'exceptions/firestore_exception.dart';
import 'query_helpers/query_helpers.dart';

/// Base class for Firestore repositories.
///
/// Provides common CRUD operations and querying functionality for Firestore collections.
/// Subclasses must specify the collection path and how to convert between models and Firestore documents.
///
/// Type Parameters:
/// - [T] : The type of model used by this repository.
///
/// Constructor Parameters:
/// - [fromMap] : Function to convert Firestore document data into a model instance.
/// - [toMap] : Function to convert a model instance into Firestore document data.
abstract class BaseFirestoreRepository<T> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Define the collection path in Firestore.
  String get collectionPath;

  // Functions to convert between model and map
  final T Function(Map<String, dynamic> map) fromMap;
  final Map<String, dynamic> Function(T model) toMap;

  BaseFirestoreRepository({required this.fromMap, required this.toMap});

  /// Checks if a document exists by its ID.
  ///
  /// Parameters:
  /// - [id] : The document ID to check.
  ///
  /// Returns:
  /// - A `Future` that resolves to `true` if the document exists, `false` otherwise.
  ///
  /// Throws [FirestoreException] if the operation fails.
  Future<bool> isExisted({required String id}) async {
    try {
      final doc = await _firestore.collection(collectionPath).doc(id).get();
      return doc.exists;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to check if document exists: $e',
        code: e is FirebaseException ? e.code : null,
      );
    }
  }

  /// Creates a document with a specific or random ID.
  ///
  /// Parameters:
  /// - [model] : The model instance to create.
  /// - [id] : Optional. The specific document ID. If not provided, a random ID is generated.
  /// - [replaceExistedDoc] : bool value (default is false) that takes effect only in case an [id] is passed. determine decision of replacing document in case there is another existed document with the same ID.
  ///
  /// Returns:
  /// - A `Future` that resolves to the document ID.
  ///
  /// Throws:
  /// - [FirestoreException] if [id] is provided, [replaceExistedDoc] is set to false, and a document with the same ID exists.
  /// - [FirestoreException] if the operation fails.
  Future<String> create({
    required T model,
    String? id,
    bool replaceExistedDoc = false,
  }) async {
    // Check for existing document
    if (id != null && await isExisted(id: id)) {
      if (!replaceExistedDoc) {
        throw FirestoreException(
            message: 'A document with the same ID already exists!');
      }
    }

    try {
      final collectionRef = _firestore.collection(collectionPath);
      DocumentReference docRef = id != null
          ? collectionRef.doc(id)
          : collectionRef.doc(); // Generate a new document reference

      await docRef.set(toMap(model));
      return docRef.id; // Return the document ID
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to create document: $e',
        code: e is FirebaseException ? e.code : null,
      );
    }
  }

  /// Updates the entire document in Firestore with the given model.
  ///
  /// Warning: This operation writes all fields, which can increase Firestore costs.
  /// Use this method only when all (or most of) fields need to be updated.
  ///
  /// Parameters:
  /// - [id] : The document ID to update.
  /// - [model] : The model instance with the updated data.
  ///
  /// Throws [FirestoreException] if the operation fails.
  Future<void> updateFullDocument({
    required String id,
    required T model,
  }) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(id)
          .update(toMap(model)); // Update only specified fields
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to update the full document: $e',
        code: e is FirebaseException ? e.code : null,
      );
    }
  }

  /// Updates specific fields using the provided map of field-value pairs.
  /// This method minimizes write costs in Firestore.
  ///
  ///
  /// Warning: Be careful with spelling and key names, as Firestore will not validate them.
  /// Ensure that the map only contains the correct fields and values.
  ///
  /// Parameters:
  /// - [id] : The document ID to update.
  /// - [updateMap] : A `Map<String, dynamic>` of the fields and their new values to update.
  ///
  /// Throws [FirestoreException] if the operation fails.
  Future<void> updateFieldsFromMap({
    required String id,
    required Map<String, dynamic> updateMap,
  }) async {
    if (updateMap.isEmpty) return;
    try {
      await _firestore
          .collection(collectionPath)
          .doc(id)
          .update(updateMap); // Update the fields in the document
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to update fields: $e',
        code: e is FirebaseException ? e.code : null,
      );
    }
  }

  /// Deletes a document by ID.
  ///
  /// Parameters:
  /// - [id] : The document ID to delete.
  ///
  /// Throws [FirestoreException] if the operation fails.
  Future<void> delete({required String id}) async {
    try {
      await _firestore.collection(collectionPath).doc(id).delete();
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to delete document: $e',
        code: e is FirebaseException ? e.code : null,
      );
    }
  }

  /// Retrieves an item by its document's ID.
  ///
  /// Parameters:
  /// - [id] : The document ID to fetch.
  ///
  /// Returns:
  /// - A `Future` that resolves to the model instance, or `null` if the document does not exist.
  ///
  /// Throws [FirestoreException] if the query fails.
  Future<T?> getById({required String id}) async {
    try {
      final doc = await _firestore.collection(collectionPath).doc(id).get();
      return doc.exists ? fromMap(doc.data()!) : null;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to get document: $e',
        code: e is FirebaseException ? e.code : null,
      );
    }
  }

  /// Retrieves items of documents with optional filtering, ordering, and pagination.
  ///
  /// Parameters:
  /// - [pagination] : Optional. Controls pagination (page size and number).
  /// - [orderBy] : Optional. List of fields to order results by, with optional descending flag.
  /// - [conditions] : Optional. List of conditions to filter results.
  ///
  /// Returns:
  /// - A `Future` that resolves to a `List<T>` of items matching the criteria.
  ///
  /// Throws [FirestoreException] if the query fails.
  Future<List<T>> getItems({
    Pagination? pagination,
    List<OrderBy>? orderBy,
    List<Condition>? conditions,
  }) async {
    try {
      Query query = _firestore.collection(collectionPath);

      // Apply conditions
      if (conditions != null) {
        for (final condition in conditions) {
          query = condition.apply(query);
        }
      }

      // Apply ordering
      if (orderBy != null) {
        for (final order in orderBy) {
          query = query.orderBy(order.field, descending: order.descending);
        }
      }

      // Apply pagination
      if (pagination != null) {
        final startAfterDoc = await _firestore
            .collection(collectionPath)
            .limit(pagination.calculateStartAfter())
            .get()
            .then((snapshot) =>
                snapshot.docs.isNotEmpty ? snapshot.docs.last : null);

        if (startAfterDoc != null) {
          query = query.startAfterDocument(startAfterDoc);
        }
        query = query.limit(pagination.pageSize);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return fromMap(data);
      }).toList();
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to get documents: $e',
        code: e is FirebaseException ? e.code : null,
      );
    }
  }
}
