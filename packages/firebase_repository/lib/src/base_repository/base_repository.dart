import 'package:cloud_firestore/cloud_firestore.dart';

import 'query_helpers/condition.dart';
import 'query_helpers/order_by.dart';
import 'query_helpers/pagination.dart';

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
abstract class BaseRepository<T> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Define the collection path in Firestore
  String get collectionPath;

  // Functions to convert between model and map
  final T Function(Map<String, dynamic> map) fromMap;
  final Map<String, dynamic> Function(T model) toMap;

  BaseRepository({required this.fromMap, required this.toMap});

  /// Checks if a document exists by its ID.
  ///
  /// Parameters:
  /// - [id] : The document ID to check.
  ///
  /// Returns:
  /// - A `Future` that resolves to `true` if the document exists, `false` otherwise.
  /// Throws:
  /// - An `Exception` if the operation fails.
  Future<bool> isExisted({
    required String id,
  }) async {
    try {
      final doc = await _firestore.collection(collectionPath).doc(id).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check if document is existed: $e');
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
  /// - An `Exception` if [id] passed, [replaceExistedDoc] set to true, and a document is existed.
  /// - An `Exception` if the operation fails.
  Future<String> create({
    required T model,
    String? id,
    bool replaceExistedDoc = false,
  }) async {
    // Process existed doc..
    if (id != null && await isExisted(id: id)) {
      if (!replaceExistedDoc) {
        throw Exception('There is an existed document with the same Id!');
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
      throw Exception('Failed to create document: $e');
    }
  }

  /// Updates a document with the given ID.
  ///
  /// Parameters:
  /// - [id] : The document ID to update.
  /// - [model] : The model instance with updated data.
  ///
  /// Throws:
  /// - An `Exception` if the operation fails.
  Future<void> update({
    required String id,
    required T model,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(id).update(toMap(model));
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  /// Deletes a document by ID.
  ///
  /// Parameters:
  /// - [id] : The document ID to delete.
  ///
  /// Throws:
  /// - An `Exception` if the operation fails.
  Future<void> delete({
    required String id,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
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
  /// Throws:
  /// - An `Exception` if the query fails.
  Future<T?> getById({
    required String id,
  }) async {
    try {
      final doc = await _firestore.collection(collectionPath).doc(id).get();
      return doc.exists ? fromMap(doc.data()!) : null;
    } catch (e) {
      throw Exception('Failed to get document: $e');
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
  /// Throws:
  /// - An `Exception` if the query fails.
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
            .then((snapshot) => snapshot.docs.last);

        query = query.startAfterDocument(startAfterDoc);
        query = query.limit(pagination.pageSize);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get documents: $e');
    }
  }
}
