import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Components/custom_button.dart';
import 'package:flutter_starter_kit/Components/custom_image.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_starter_kit/Features/UserProfile/Edit/UI/edit_user_profile_screen.dart';
import 'package:flutter_starter_kit/Global/Models/image_model.dart';
import 'package:flutter_starter_kit/Global/app_assets.dart';
import 'package:flutter_starter_kit/Global/enums.dart';
import 'package:flutter_starter_kit/Helpers/dialog_helper.dart';
import 'package:flutter_starter_kit/Helpers/loading_helper.dart';
import 'package:flutter_starter_kit/Helpers/nav_helper.dart';
import 'package:sizer/sizer.dart';

class PreviewUserProfileScreen extends StatelessWidget {
  const PreviewUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //! We need to listen to user's data as it'd be edited when navigate to
    //! edit screen and then pop to this screen.
    //---------------- BlocConsumer --------------------//
    return BlocConsumer<UserModelCubit, UserModelState>(
      listenWhen: (previous, current) =>
          previous.stateStatus != current.stateStatus,
      //---------------- Listener --------------------//
      listener: (context, state) {
        if (state.stateStatus == StateStatus.loading) {
          LoadingHelper.showLoading(context);
        } else {
          LoadingHelper.dismissLoading();
          if (state.stateStatus == StateStatus.failure) {
            DialogHelper.showCustomAlert(
              context: context,
              title: 'Error fetching data!',
              content:
                  'Failed to load data. Please check your connection and try again.',
              dismissible: false,
              btnText: 'Retry',
              onBtnPressed: () {
                // Retry loading data..
                context.read<UserModelCubit>().loadData();
              },
            );
          }
        }
      },
      builder: (context, state) {
        //---------------- UI Layout --------------------//
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: SafeArea(
            child: ListView(
              children: [
                SizedBox(height: 2.h),
                CustomImage(
                  imageModel: state.userModel!.avatarUrl == null
                      ? const ImageModel.asset(AppAssets.userDefaultAvatar)
                      : ImageModel.network(state.userModel!.avatarUrl!),
                  size: Size(120.sp, 120.sp),
                  boxFit: BoxFit.cover,
                  shape: BoxShape.circle,
                ),
                SizedBox(height: 2.h),
                Center(
                  child: CustomButton(
                    width: 50.w,
                    text: 'Edit Profile',
                    onPressed: () async {
                      //! Navigate to edit profile and learn if there are updates.
                      final isDataUpdated = await NavHelper.push(
                        context,
                        const EditUserProfileScreen(),
                      );

                      //! If widget still mounted, and user's data is edited (cloud update exists), reload the user's data.
                      if (context.mounted && isDataUpdated == true) {
                        context.read<UserModelCubit>().loadData();
                      }
                    },
                  ),
                ),
                ListTile(
                  leading: const Text('Name'),
                  title: Text(
                    state.userModel!.name,
                  ),
                ),
                ListTile(
                  leading: const Text('About'),
                  title: Text(
                    state.userModel!.about ?? '',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
