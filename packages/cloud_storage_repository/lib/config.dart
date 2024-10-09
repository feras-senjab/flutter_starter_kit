class Config {
  /// Maximum allowed user avatar file size in Bytes
  static int get userAvatarMaxFileSize => 2 * 1024 * 1024;

  /// Path of user's avatar folder
  static String userAvatarFolder(String userId) => 'users/$userId/avatar';
}
