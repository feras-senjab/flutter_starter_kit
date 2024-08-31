import 'package:flutter/material.dart';

enum ButtonType {
  elevatedButton,
  outlinedButton,
  textButton,
}

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final ButtonType buttonType;
  final bool enabled;

  /// Setting fitContentWidth to true makes width takes no effect.
  final bool fitContentWidth;
  final double? width;
  final double? height;

  final Color? foregroundColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonType = ButtonType.elevatedButton,
    this.enabled = true,
    this.fitContentWidth = false,
    this.width,
    this.height,
    this.foregroundColor,
    this.backgroundColor,
    this.textStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
  });

  Widget _getButton(ButtonType buttonType) {
    if (buttonType == ButtonType.elevatedButton) {
      return ElevatedButton(
        onPressed: enabled ? () => onPressed() : null,
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          textStyle: textStyle,
        ),
        child: Text(text),
      );
    } else if (buttonType == ButtonType.outlinedButton) {
      return OutlinedButton(
        onPressed: enabled ? () => onPressed() : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          textStyle: textStyle,
        ),
        child: Text(text),
      );
    } else {
      //textButton
      return TextButton(
        onPressed: enabled ? () => onPressed() : null,
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          textStyle: textStyle,
        ),
        child: Text(text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    final btn = SizedBox(
      width: fitContentWidth ? null : width,
      height: height,
      child: _getButton(buttonType),
    );
    //
    return width == null && !fitContentWidth
        ? btn
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              btn,
            ],
          );
  }
}
