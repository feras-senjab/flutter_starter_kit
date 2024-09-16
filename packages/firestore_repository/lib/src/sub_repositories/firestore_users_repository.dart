import '../../../config.dart';
import '../base_firestore_repository/base_firestore_repository.dart';
import '../models/models.dart';

/// A repository for managing user documents in Firestore.
///
/// Extends [BaseFirestoreRepository] to implement and manage CRUD operations for users.
class FirestoreUsersRepository
    extends BaseFirestoreRepository<FirestoreUserModel> {
  FirestoreUsersRepository()
      : super(
          fromMap: (map) => FirestoreUserModel.fromMap(map),
          toMap: (user) => user.toMap(),
        );

  @override
  String get collectionPath => Config.usersCollection;
}
