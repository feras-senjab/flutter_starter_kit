import 'package:flutter/material.dart';

/// A utility class that simplifies navigation by reducing the
/// required parameters of the regular Navigator methods.
class NavHelper {
  /// Pushes a new route onto the navigator stack.
  ///
  /// Returns a Future that resolves to the result of the pushed route.
  static Future<T?> push<T>(BuildContext context, Widget target) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (_) => target,
      ),
    );
  }

  /// Replaces the current route with a new route.
  ///
  /// Optionally returns a result to the previous route.
  static Future<T?> pushReplacement<T, TO>(
    BuildContext context,
    Widget target, {
    TO? result,
  }) {
    return Navigator.of(context).pushReplacement<T, TO>(
      MaterialPageRoute(
        builder: (_) => target,
      ),
      result: result,
    );
  }

  /// Pushes a new route and removes routes until the specified predicate returns true.
  ///
  /// If no predicate is provided, all previous routes will be removed.
  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget target,
      {RoutePredicate? predicate}) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute(
        builder: (_) => target,
      ),
      predicate ?? (Route<dynamic> route) => false,
    );
  }
}
