import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Components/custom_button.dart';
import 'package:flutter_starter_kit/Components/custom_image.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_starter_kit/Global/enums.dart';
import 'package:sizer/sizer.dart';

class UserProfilePreviewScreen extends StatelessWidget {
  const UserProfilePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 2.h),
            CircularImage(
              imageType: ImageType.networkImage,
              path: 'path',
              radius: 60.sp,
            ),
            SizedBox(height: 2.h),
            Center(
              child: CustomButton(
                width: 50.w,
                text: 'Edit Profile',
                onPressed: () {},
              ),
            ),
            ListTile(
              leading: const Text('Name'),
              title: Text(
                context.read<UserModelCubit>().state.userModel!.name,
              ),
            ),
            const ListTile(
              leading: Text('About'),
              title: Text(
                'I\'m a man who loves life or hates life Im not sure but Im sure I\'m a man!',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
