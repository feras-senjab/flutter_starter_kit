import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Components/custom_button.dart';
import 'package:flutter_starter_kit/Components/custom_image.dart';
import 'package:flutter_starter_kit/Components/entry_field.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_starter_kit/Features/UserProfile/Edit/cubit/edit_user_profile_cubit.dart';
import 'package:flutter_starter_kit/Helpers/dialog_helper.dart';
import 'package:flutter_starter_kit/Helpers/loading_helper.dart';
import 'package:form_validators/form_validators.dart';
import 'package:sizer/sizer.dart';

class EditUserProfileScreen extends StatelessWidget {
  const EditUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditUserProfileCubit(
        userModelCubit: context.read<UserModelCubit>(),
      ),
      child: BlocConsumer<EditUserProfileCubit, EditUserProfileState>(
        listenWhen: (previous, current) => previous.status != current.status,
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
                  // Avatar
                  Align(
                    child: Stack(
                      children: [
                        CustomImage(
                          imageSource: state.avatar,
                          size: Size(120.sp, 120.sp),
                          shape: BoxShape.circle,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
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
                                            onTap: () {},
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
                                            onTap: () {},
                                            child: const ListTile(
                                              title: Text(
                                                'Choose from gallery',
                                                textAlign: TextAlign.center,
                                              ),
                                              trailing: Icon(
                                                  Icons.file_upload_outlined),
                                            ),
                                          ),
                                          // Take a picture
                                          InkWell(
                                            onTap: () {},
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Name
                  EntryField(
                    label: 'Name',
                    initialValue: state.name.value,
                  ),
                  SizedBox(height: 2.h),
                  // About
                  EntryField(
                    label: 'About',
                    initialValue: state.about,
                    maxLines: 3,
                  ),
                  // Submit
                  SizedBox(height: 2.h),
                  CustomButton(
                    text: 'Submit',
                    onPressed: () {},
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
