import 'package:cloud_storage_repository/cloud_storage_repository.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Components/custom_button.dart';
import 'package:flutter_starter_kit/Components/custom_image.dart';
import 'package:flutter_starter_kit/Components/entry_field.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_starter_kit/Features/UserProfile/Edit/cubit/edit_user_profile_cubit.dart';
import 'package:flutter_starter_kit/Global/Models/image_model.dart';
import 'package:flutter_starter_kit/Global/app_assets.dart';
import 'package:flutter_starter_kit/Global/app_values.dart';
import 'package:flutter_starter_kit/Helpers/dialog_helper.dart';
import 'package:flutter_starter_kit/Helpers/image_pick_crop_helper.dart';
import 'package:flutter_starter_kit/Helpers/loading_helper.dart';
import 'package:form_validators/form_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import 'widgets/edit_user_avatar_button.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  /// Initializes the text editing controllers for the form fields by retrieving the current user's information.
  void _initializeFieldsControllers() {
    final userModel = context.read<UserModelCubit>().state.userModel!;
    _nameController.text = userModel.name;
    _aboutController.text = userModel.about ?? '';
  }

  @override
  void initState() {
    _initializeFieldsControllers();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

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
        userModel: context.read<UserModelCubit>().state.userModel!,
        usersRepository: context.read<FirestoreUsersRepository>(),
        usersStorageRepository: context.read<CloudStorageUsersRepository>(),
        emptyAvatarImageModel:
            const ImageModel.asset(AppAssets.userDefaultAvatar),
      ),
      //---------------- BlocConsumer --------------------//
      child: BlocConsumer<EditUserProfileCubit, EditUserProfileState>(
        listenWhen: (previous, current) => previous.status != current.status,
        //---------------- Listener --------------------//
        listener: (context, state) {
          // ⏳ On Loading:
          if (state.status == FormzStatus.submissionInProgress) {
            LoadingHelper.showLoading(context);
          } else {
            LoadingHelper.dismissLoading();
            // ❌ On Failure:
            if (state.status == FormzStatus.submissionFailure) {
              DialogHelper.showCustomAlert(
                context: context,
                title: 'Error',
                content: state.errorMessage ?? 'Something Wrong!',
              );
            }
            // ✅ On Success:
            else if (state.status == FormzStatus.submissionSuccess) {
              bool isDataUpdated = true;
              //! Pop and return true to inform that data is updated.
              Navigator.of(context).pop(isDataUpdated);
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
              //---------------- AppBar --------------------//
              appBar: AppBar(
                title: const Text('Edit Profile'),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 4.w),

                    //---------------- 🔄 Reset --------------------//
                    child: InkWell(
                      onTap: state.status.isPure
                          ? null
                          : () {
                              // Dismiss keyboard
                              FocusScope.of(context).unfocus();
                              // Reset the state
                              context.read<EditUserProfileCubit>().reset();
                              // Reset text editing controllers
                              _initializeFieldsControllers();
                            },
                      child: const Row(
                        children: [
                          Icon(Icons.restore),
                          Text(' Reset'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              //---------------- Body --------------------//
              body: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                ),
                children: [
                  SizedBox(height: 2.h),

                  //---------------- 👤 Avatar --------------------//
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
                            showRemoveAvatarOption: !state.isAvatarEmpty,
                            // Remove Avatar
                            onRemoveAvatarSelected: () {
                              context
                                  .read<EditUserProfileCubit>()
                                  .removeAvatar();
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

                  //---------------- 🔤 Name --------------------//
                  EntryField(
                    label: 'Name',
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    onChanged: (name) =>
                        context.read<EditUserProfileCubit>().nameChanged(name),
                    errorText: state.name.invalid
                        ? Name.showNameErrorMessage(state.name.error)
                        : null,
                  ),

                  SizedBox(height: 2.h),

                  //---------------- 🔤 About --------------------//
                  EntryField(
                    label: 'About',
                    controller: _aboutController,
                    maxLines: 3,
                    maxLength: AppValues.userAboutMaxLength,
                    onChanged: (text) =>
                        context.read<EditUserProfileCubit>().aboutChanged(text),
                  ),

                  SizedBox(height: 2.h),

                  //---------------- 🚀 Submit --------------------//
                  CustomButton(
                    text: 'Submit',
                    enabled: state.status == FormzStatus.valid,
                    onPressed: () {
                      // Dismiss keyboard
                      FocusScope.of(context).unfocus();
                      //! Loading & Navigation are done by listener.
                      context.read<EditUserProfileCubit>().submit();
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
