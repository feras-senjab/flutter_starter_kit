class Config {
  static int get userAvatarMaxFileSize => 2 * 1024 * 1024;

  static String userAvatarPath(String userId) =>
      'users/$userId/avatar/avatar.jpg';
}
