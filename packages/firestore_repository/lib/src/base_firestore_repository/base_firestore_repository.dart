import 'package:cloud_firestore/cloud_firestore.dart';

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
  /// Throws:
  /// - An `Exception` if the operation fails.
  Future<bool> isExisted({required String id}) async {
    try {
      final doc = await _firestore.collection(collectionPath).doc(id).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check if document exists: $e');
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
  /// - An `Exception` if [id] is provided, [replaceExistedDoc] is set to false, and a document with the same ID exists.
  /// - An `Exception` if the operation fails.
  Future<String> create({
    required T model,
    String? id,
    bool replaceExistedDoc = false,
  }) async {
    // Check for existing document
    if (id != null && await isExisted(id: id)) {
      if (!replaceExistedDoc) {
        throw Exception('A document with the same ID already exists!');
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

  /// Private helper to detect and return only the fields that have changed between two models.
  ///
  /// Compares the old model and new model and returns a map of the changed fields.
  ///
  /// Parameters:
  /// - [oldModel] : The original model instance before any updates.
  /// - [newModel] : The updated model instance that may contain new data.
  ///
  /// Returns:
  /// - A `Map<String, dynamic>` representing the fields that have been updated
  ///   from the old model to the new model.
  Map<String, dynamic> _getChangedFields({
    required T oldModel,
    required T newModel,
  }) {
    final oldModelMap = toMap(oldModel);
    final newModelMap = toMap(newModel);
    final changes = <String, dynamic>{};

    // Loop through the keys in the new model map
    newModelMap.forEach((key, newValue) {
      final oldValue = oldModelMap[key];
      // If the values are different, add to the changes map
      if (newValue != oldValue) {
        changes[key] = newValue;
      }
    });

    return changes;
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
  /// Throws:
  /// - An `Exception` if the operation fails.
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
      throw Exception('Failed to update the full document: $e');
    }
  }

  /// Updates only the fields that have changed between the old and new models.
  /// The method minimizes write costs in Firestore.
  ///
  /// Warning: The comparison requires extra computation to detect changes, but minimizes write costs in Firestore.
  ///
  /// Warning: This method compares each field to detect changes, which can be computationally
  /// expensive if the model has a large number of fields or deeply nested data.
  ///
  /// Parameters:
  /// - [id] : The document ID to update.
  /// - [oldModel] : The original model instance before updates.
  /// - [newModel] : The updated model instance containing new data.
  ///
  /// Throws:
  /// - An `Exception` if the operation fails.
  Future<void> updateChangedFields({
    required String id,
    required T oldModel,
    required T newModel,
  }) async {
    try {
      // Get only the updated fields using the private helper
      final updatedFields = _getChangedFields(
        oldModel: oldModel,
        newModel: newModel,
      );

      // Update Firestore only if there are changes
      if (updatedFields.isNotEmpty) {
        await _firestore
            .collection(collectionPath)
            .doc(id)
            .update(updatedFields);
      }
    } catch (e) {
      throw Exception('Failed to update document\'s changed fields: $e');
    }
  }

  /// Updates specific fields using the provided map of field-value pairs.
  /// This method minimizes write costs in Firestore and doesn't require extra computation.
  ///
  ///
  /// Warning: Be careful with spelling and key names, as Firestore will not validate them.
  /// Ensure that the map only contains the correct fields and values.
  ///
  /// Parameters:
  /// - [id] : The document ID to update.
  /// - [fields] : A `Map<String, dynamic>` of the fields and their new values to update.
  ///
  /// Throws:
  /// - An `Exception` if the operation fails.
  Future<void> updateFieldsFromMap({
    required String id,
    required Map<String, dynamic> fields,
  }) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(id)
          .update(fields); // Update the fields in the document
    } catch (e) {
      throw Exception('Failed to update fields: $e');
    }
  }

  /// Deletes a document by ID.
  ///
  /// Parameters:
  /// - [id] : The document ID to delete.
  ///
  /// Throws:
  /// - An `Exception` if the operation fails.
  Future<void> delete({required String id}) async {
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
  Future<T?> getById({required String id}) async {
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
      throw Exception('Failed to get documents: $e');
    }
  }
}
