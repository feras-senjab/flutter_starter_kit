import '../../../config.dart';
import '../base_repository/base_repository.dart';
import '../models/user.dart';

/// A repository for managing user documents in Firestore.
///
/// Extends [BaseRepository] to implement and manage CRUD operations for users.
class FirebaseUsersRepository extends BaseRepository<FirebaseUserModel> {
  FirebaseUsersRepository()
      : super(
          fromMap: (map) => FirebaseUserModel.fromMap(map),
          toMap: (user) => user.toMap(),
        );

  @override
  String get collectionPath => Config.usersCollection;
}
