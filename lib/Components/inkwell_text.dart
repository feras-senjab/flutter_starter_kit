import 'package:flutter/material.dart';

class InkwellText extends StatelessWidget {
  const InkwellText({
    super.key,
    required this.text,
    required this.onTap,
    this.textStyle,
    this.textAlign,
    this.enabled = true,
    this.disabledTextStyle,
  });

  final String text;
  final Function onTap;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final bool enabled;
  final TextStyle? disabledTextStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => onTap() : null,
      child: Text(
        text,
        textAlign: textAlign,
        style: enabled
            ? (textStyle ??
                TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ))
            : (disabledTextStyle ??
                TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontWeight: FontWeight.bold,
                )),
      ),
    );
  }
}
