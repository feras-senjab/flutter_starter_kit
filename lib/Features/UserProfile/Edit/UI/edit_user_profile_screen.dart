import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Components/custom_button.dart';
import 'package:flutter_starter_kit/Components/custom_image.dart';
import 'package:flutter_starter_kit/Components/entry_field.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_starter_kit/Features/UserProfile/Edit/cubit/edit_user_profile_cubit.dart';
import 'package:flutter_starter_kit/Global/Models/image_model.dart';
import 'package:flutter_starter_kit/Global/app_values.dart';
import 'package:flutter_starter_kit/Helpers/dialog_helper.dart';
import 'package:flutter_starter_kit/Helpers/image_pick_crop_helper.dart';
import 'package:flutter_starter_kit/Helpers/loading_helper.dart';
import 'package:form_validators/form_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import 'widgets/edit_user_avatar_button.dart';

class EditUserProfileScreen extends StatelessWidget {
  const EditUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //---------------- Helper Method --------------------//
    /// Picks and Crops an image from the specified source,
    /// then updates the user's avatar in the EditUserProfileCubit.
    Future pickCropAndSetUserAvatar(
        BuildContext context, ImageSource imageSource) async {
      final pickedCropped = await ImagePickCropHelper.pickAndCropImage(
        pickSettings: ImagePickSettings(source: imageSource),
        cropSettings: ImageCropSettings(
          cropStyle: CropStyle.circle,
          maxWidth: AppValues.userAvatarMaxWidth,
          maxHeight: AppValues.userAvatarMaxHeight,
          compressQuality: AppValues.userAvatarQuality,
        ),
      );

      if (pickedCropped != null && context.mounted) {
        final imageModel = ImageModel.file(pickedCropped);
        context.read<EditUserProfileCubit>().avatarChanged(imageModel);
      }
    }

    //---------------- BlocProvider --------------------//
    return BlocProvider(
      create: (context) => EditUserProfileCubit(
        userModelCubit: context.read<UserModelCubit>(),
      ),
      //---------------- BlocConsumer --------------------//
      child: BlocConsumer<EditUserProfileCubit, EditUserProfileState>(
        listenWhen: (previous, current) => previous.status != current.status,
        //---------------- Listener --------------------//
        listener: (context, state) {
          if (state.status == FormzStatus.submissionInProgress) {
            LoadingHelper.showLoading(context);
          } else {
            LoadingHelper.dismissLoading();
            if (state.status == FormzStatus.submissionFailure) {
              DialogHelper.showCustomAlert(
                context: context,
                title: 'Error',
                content: state.errorMessage ?? 'Something Wrong!',
              );
            } else if (state.status == FormzStatus.submissionSuccess) {
              Navigator.of(context).pop();
            }
          }
        },
        builder: (context, state) {
          //---------------- UI Layout --------------------//
          return GestureDetector(
            // Keyboard Dismissal
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Edit Profile'),
              ),
              body: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                ),
                children: [
                  SizedBox(height: 2.h),

                  //---------------- Avatar --------------------//
                  Align(
                    child: Stack(
                      children: [
                        CustomImage(
                          imageModel: state.avatar,
                          size: Size(120.sp, 120.sp),
                          shape: BoxShape.circle,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: EditUserAvatarButton(
                            // Remove Avatar
                            onRemoveAvatarSelected: () {
                              //TODO
                            },
                            // From Gallery
                            onChooseFromGallerySelected: () =>
                                pickCropAndSetUserAvatar(
                                    context, ImageSource.gallery),
                            // From Camera
                            onTakePictureSelected: () =>
                                pickCropAndSetUserAvatar(
                                    context, ImageSource.camera),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  //---------------- Name --------------------//
                  EntryField(
                    label: 'Name',
                    initialValue: state.name.value,
                  ),

                  SizedBox(height: 2.h),

                  //---------------- About --------------------//
                  EntryField(
                    label: 'About',
                    initialValue: state.about,
                    maxLines: 3,
                    maxLength: AppValues.userAboutMaxLength,
                  ),

                  SizedBox(height: 2.h),

                  //---------------- Submit --------------------//
                  CustomButton(
                    text: 'Submit',
                    onPressed: () {
                      //TODO
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
