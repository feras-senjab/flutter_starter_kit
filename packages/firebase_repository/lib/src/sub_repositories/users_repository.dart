import '../../../config.dart';
import '../base_repository/base_repository.dart';
import '../models/user.dart';

/// A repository for managing user documents in Firestore.
///
/// Extends [BaseRepository] to handle user-specific operations and manage
/// interactions with Firestore collections based on deployment environments.
class FirebaseUsersRepository extends BaseRepository<FirebaseUserModel> {
  FirebaseUsersRepository()
      : super(
          fromMap: (map) => FirebaseUserModel.fromMap(map),
          toMap: (user) => user.toMap(),
        );

  @override
  String get collectionPath => Config.usersCollection;
}
