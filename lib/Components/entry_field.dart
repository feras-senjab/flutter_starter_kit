import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EntryField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final Color? labelColor;
  final String? initialValue;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final bool expands;
  final String? hint;
  final Widget? prefix;
  final Widget? suffixIcon;
  final Function? onTap;
  final TextCapitalization? textCapitalization;
  final Color? fillColor;
  final EdgeInsets? padding;
  final Widget? counter;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final InputBorder? inputBorder;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final void Function(String)? onChanged;
  final bool obscureText;
  final String? errorText;
  final bool enabled;

  const EntryField({
    super.key,
    this.controller,
    this.label,
    this.labelColor,
    this.initialValue,
    this.readOnly,
    this.keyboardType,
    this.maxLength,
    this.hint,
    this.prefix,
    this.minLines,
    this.maxLines,
    this.expands = false,
    this.suffixIcon,
    this.onTap,
    this.textCapitalization,
    this.fillColor,
    this.padding,
    this.counter,
    this.hintStyle,
    this.errorStyle,
    this.inputBorder,
    this.enabledBorder,
    this.focusedBorder,
    this.textAlign,
    this.textStyle,
    this.onChanged,
    this.obscureText = false,
    this.errorText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            vertical: 1.w,
          ),
      child: TextFormField(
        enabled: enabled,
        onChanged: onChanged,
        obscureText: obscureText,
        style: textStyle,
        enableInteractiveSelection: true,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        onTap: onTap as void Function()?,
        autofocus: false,
        controller: controller,
        initialValue: initialValue,
        readOnly: readOnly ?? false,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLength: maxLength,
        maxLines: obscureText ? 1 : maxLines,
        expands: expands,
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          fillColor: fillColor,
          prefixIcon: prefix,
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: labelColor == null
              ? null
              : TextStyle(
                  color: labelColor,
                ),
          hintText: hint,
          hintStyle: hintStyle,
          errorText: errorText,
          errorStyle: errorStyle,
          errorMaxLines: 3,
          counter: counter ?? const Offstage(),
          border: inputBorder,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
        ),
      ),
    );
  }
}
