import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

class CustomLoading extends StatelessWidget {
  final Color? color;
  final double? size;
  final String? text;
  final TextStyle? textStyle;
  final double? spaceBetweenSpinnerAndText;

  const CustomLoading({
    super.key,
    this.color,
    this.size,
    this.text,
    this.textStyle,
    this.spaceBetweenSpinnerAndText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SpinKitCircle(
          color: color ?? Theme.of(context).colorScheme.primary,
          size: size ?? 25.w,
        ),
        if (text != null) SizedBox(height: spaceBetweenSpinnerAndText ?? 2.h),
        if (text != null)
          Text(
            text!,
            style: textStyle ??
                TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
      ],
    );
  }
}
