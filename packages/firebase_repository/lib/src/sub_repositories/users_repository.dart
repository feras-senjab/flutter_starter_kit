import '../../../config.dart';
import '../base_repository/base_repository.dart';
import '../models/user.dart';
//! ONLY this repo create/update/delete in all environments.

/// A repository for managing user documents in Firestore.
///
/// Extends [BaseRepository] to handle user-specific operations and manage
/// interactions with Firestore collections based on deployment environments.
class FirebaseUsersRepository extends BaseRepository<FirebaseUserModel> {
  /// The current deployment environment for this repository instance.
  final DeploymentEnv deploymentEnv;

  /// Constructs a [FirebaseUsersRepository] with the given deployment environment.
  ///
  /// Parameters:
  /// - [deploymentEnv] : The deployment environment (e.g., testing, production).
  FirebaseUsersRepository({
    required this.deploymentEnv,
  }) : super(
          fromMap: (map) => FirebaseUserModel.fromMap(map),
          toMap: (user) => user.toMap(),
        );

  @override
  String get collectionPath =>
      Config(deploymentEnv: deploymentEnv).usersCollection;

  /// Creates a user document in all deployment environments.
  ///
  /// Parameters:
  /// - [model] : The [FirebaseUserModel] instance to create.
  /// - [id] : The specific document ID. EVEN THIS ISN'T REQUIRED AN EXCEPTION WILL BE THROWN IF [id] NOT PASSED. That's because this is an overrided function.
  /// - [replaceExistedDoc] : Optional. Whether to replace an existing document with the same ID (default is false).
  ///
  /// Returns:
  /// - A `Future<String>` that resolves to the document ID.
  ///
  /// Throws:
  /// - [ArgumentError] if [id] is not provided.
  /// - [Exception] if the creation fails in any environment.
  @override
  Future<String> create({
    required FirebaseUserModel model,
    String? id,
    bool replaceExistedDoc = false,
  }) async {
    // Ensure that the ID is provided, as it is necessary for user creation.
    if (id == null) {
      throw ArgumentError('Document ID must be provided for user creation.');
    }
    // List of futures for creating the user in all deployment environments.
    List<Future> futuresList = [];

    // Create user documents in each deployment environment.
    for (var env in DeploymentEnv.values) {
      futuresList.add(
        FirebaseUsersRepository(deploymentEnv: env)._createInCurrentEnvironment(
            model: model, id: id, replaceExistedDoc: replaceExistedDoc),
      );
    }

    try {
      // Wait for all futures to complete.
      await Future.wait(futuresList);
    } catch (e) {
      // Catch and throw an exception if any user creation fails.
      throw Exception('Failed to create user in all environments: $e');
    }
    // Return the document ID after successful creation.
    return id;
  }

  /// helper private function to create user in current environment.
  Future<String> _createInCurrentEnvironment({
    required FirebaseUserModel model,
    required String id,
    bool replaceExistedDoc = false,
  }) async {
    try {
      // Create user in the current environment.
      var result = await super
          .create(model: model, id: id, replaceExistedDoc: replaceExistedDoc);
      return result;
    } catch (e) {
      throw Exception(
          'Failed to create user in environment $deploymentEnv: $e');
    }
  }

  /// Updates a user document in all deployment environments.
  ///
  /// Parameters:
  /// - [id] : The document ID of the user to update.
  /// - [model] : The [FirebaseUserModel] instance with updated data.
  ///
  /// Throws:
  /// - [Exception] if the update fails in any environment.
  @override
  Future<void> update({
    required String id,
    required FirebaseUserModel model,
  }) async {
    // List of futures for updating the user in all deployment environments.
    List<Future<void>> futuresList = [];

    // Update user documents in each deployment environment.
    for (var env in DeploymentEnv.values) {
      futuresList.add(
        FirebaseUsersRepository(deploymentEnv: env)
            ._updateInCurrentEnvironment(id: id, model: model),
      );
    }

    try {
      // Wait for all futures to complete.
      await Future.wait(futuresList);
    } catch (e) {
      // Catch and throw an exception if any user update fails.
      throw Exception('Failed to update user in all environments: $e');
    }
  }

  /// helper private function to update user in current environment.
  Future<void> _updateInCurrentEnvironment({
    required String id,
    required FirebaseUserModel model,
  }) async {
    try {
      // Update user in the current environment.
      await super.update(id: id, model: model);
    } catch (e) {
      throw Exception(
          'Failed to update user in environment $deploymentEnv: $e');
    }
  }

  /// Deletes a user document in all deployment environments.
  ///
  /// Parameters:
  /// - [id] : The document ID of the user to delete.
  ///
  /// Throws:
  /// - [Exception] if the deletion fails in any environment.
  @override
  Future<void> delete({
    required String id,
  }) async {
    // List of futures for deleting the user in all deployment environments.
    List<Future<void>> futuresList = [];

    // Delete user documents in each deployment environment.
    for (var env in DeploymentEnv.values) {
      futuresList.add(
        FirebaseUsersRepository(deploymentEnv: env)
            ._deleteInCurrentEnvironment(id: id),
      );
    }

    try {
      // Wait for all futures to complete.
      await Future.wait(futuresList);
    } catch (e) {
      // Catch and throw an exception if any user deletion fails.
      throw Exception('Failed to delete user in all environments: $e');
    }
  }

  /// helper private function to delete user in current environment.
  Future<void> _deleteInCurrentEnvironment({
    required String id,
  }) async {
    try {
      // Delete user in the current environment.
      await super.delete(id: id);
    } catch (e) {
      throw Exception(
          'Failed to delete user in environment $deploymentEnv: $e');
    }
  }
}
