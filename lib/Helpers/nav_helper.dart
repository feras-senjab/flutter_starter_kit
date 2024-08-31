import 'package:flutter/material.dart';

class NavHelper {
  static void push(BuildContext context, Widget target) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => target,
      ),
    );
  }

  static void pushReplacement(BuildContext context, Widget target) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => target,
      ),
    );
  }

  static void pushAndRemoveUntil(BuildContext context, Widget target,
      {bool route = false}) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => target,
      ),
      (r) => route,
    );
  }
}
