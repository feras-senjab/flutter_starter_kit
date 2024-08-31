import 'dart:ui';

class ColorPair {
  final Color light;
  final Color dark;

  ColorPair({
    required this.light,
    required this.dark,
  });
}

extension ColorPairExtension on ColorPair {
  Color getColorForBrightness(Brightness brightness) {
    return brightness == Brightness.light ? light : dark;
  }
}
