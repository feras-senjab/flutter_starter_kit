import 'package:flutter/material.dart';

class DialogHelper {
  static Future<void> showCustomAlert({
    required BuildContext context,
    required String title,
    required String content,
    bool dismissible = true,
    String btnText = 'Ok',
    bool popDialogOnBtn1Pressed = true,
    Function? onBtnPressed,
    String? btn2TextNullIfOneBtn,
    Function? onBtn2PressedNullIfOneBtn,
    bool popDialogOnBtn2Pressed = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: dismissible,
      builder: (BuildContext context) {
        return PopScope(
          canPop: dismissible,
          child: AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                child: Text(btnText),
                onPressed: () {
                  if (popDialogOnBtn1Pressed) {
                    Navigator.of(context).pop();
                  }
                  if (onBtnPressed != null) {
                    onBtnPressed();
                  }
                },
              ),
              btn2TextNullIfOneBtn != null
                  ? TextButton(
                      child: Text(btn2TextNullIfOneBtn),
                      onPressed: () {
                        if (popDialogOnBtn2Pressed) {
                          Navigator.of(context).pop();
                        }
                        if (onBtn2PressedNullIfOneBtn != null) {
                          onBtn2PressedNullIfOneBtn();
                        }
                      },
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showCustomDialog({
    required BuildContext context,
    required Dialog dialog,
    bool dismissible = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: dismissible,
      builder: (BuildContext context) {
        return PopScope(
          canPop: dismissible,
          child: dialog,
        );
      },
    );
  }
}
