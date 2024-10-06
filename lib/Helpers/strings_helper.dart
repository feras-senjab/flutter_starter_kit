class StringsHelper {
  /// Removes unnecessary spaces from the given [input] string.
  /// This includes:
  /// - Leading spaces (spaces at the beginning)
  /// - Trailing spaces (spaces at the end)
  /// - Extra spaces between words (reducing multiple spaces to a single space)
  ///
  /// Example:
  /// ```dart
  /// removeExtraSpaces(input: '   This    is   an   example  ')
  /// ```
  /// The result will be: `'This is an example'`
  static String removeExtraSpaces({required String input}) {
    // Use regular expression to replace multiple spaces with a single space
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
