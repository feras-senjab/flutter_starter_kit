import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/Helpers/dialog_helper.dart';
import 'package:sizer/sizer.dart';

class EditUserAvatarButton extends StatelessWidget {
  final Function onRemoveAvatarSelected;
  final Function onChooseFromGallerySelected;
  final Function onTakePictureSelected;

  const EditUserAvatarButton({
    super.key,
    required this.onRemoveAvatarSelected,
    required this.onChooseFromGallerySelected,
    required this.onTakePictureSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      child: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          DialogHelper.showCustomDialog(
            context: context,
            dialog: Dialog(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 4.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Remove Avatar
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        onRemoveAvatarSelected();
                      },
                      child: const ListTile(
                        title: Text(
                          'Remove your avatar',
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.delete),
                      ),
                    ),
                    // Choose from gallery
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        onChooseFromGallerySelected();
                      },
                      child: const ListTile(
                        title: Text(
                          'Choose from gallery',
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.file_upload_outlined),
                      ),
                    ),
                    // Take a picture
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        onTakePictureSelected();
                      },
                      child: const ListTile(
                        title: Text(
                          'Take a picture',
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
