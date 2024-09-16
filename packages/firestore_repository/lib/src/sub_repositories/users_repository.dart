import '../../../config.dart';
import '../base_repository/base_repository.dart';
import '../models/models.dart';

/// A repository for managing user documents in Firestore.
///
/// Extends [BaseRepository] to implement and manage CRUD operations for users.
class FirestoreUsersRepository extends BaseRepository<FirestoreUserModel> {
  FirestoreUsersRepository()
      : super(
          fromMap: (map) => FirestoreUserModel.fromMap(map),
          toMap: (user) => user.toMap(),
        );

  @override
  String get collectionPath => Config.usersCollection;
}
