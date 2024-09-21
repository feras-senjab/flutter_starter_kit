import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Components/custom_button.dart';
import 'package:flutter_starter_kit/Components/custom_image.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_starter_kit/Features/UserProfile/Edit/UI/edit_user_profile_screen.dart';
import 'package:flutter_starter_kit/Global/Models/image_model.dart';
import 'package:flutter_starter_kit/Global/app_assets.dart';
import 'package:flutter_starter_kit/Helpers/nav_helper.dart';
import 'package:sizer/sizer.dart';

class PreviewUserProfileScreen extends StatelessWidget {
  const PreviewUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModelCubit>().state.userModel!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 2.h),
            CustomImage(
              imageModel: userModel.avatarUrl == null
                  ? const ImageModel.asset(AppAssets.userDefaultAvatar)
                  : ImageModel.network(userModel.avatarUrl!),
              size: Size(120.sp, 120.sp),
              boxFit: BoxFit.cover,
              shape: BoxShape.circle,
            ),
            SizedBox(height: 2.h),
            Center(
              child: CustomButton(
                width: 50.w,
                text: 'Edit Profile',
                onPressed: () {
                  NavHelper.push(context, const EditUserProfileScreen());
                },
              ),
            ),
            ListTile(
              leading: const Text('Name'),
              title: Text(
                userModel.name,
              ),
            ),
            ListTile(
              leading: const Text('About'),
              title: Text(
                userModel.about ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
