import 'package:flutter_starter_kit/Components/custom_button.dart';
import 'package:flutter_starter_kit/Features/Auth/Logout/cubit/logout_cubit.dart';
import 'package:flutter_starter_kit/Features/Auth/Logout/widgets/logout_consumer.dart';
import 'package:flutter_starter_kit/Features/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_starter_kit/Features/UserProfile/Preview/UI/preview_user_profile_screen.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/app_theme.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/cubit/theme_cubit.dart';
import 'package:flutter_starter_kit/Helpers/nav_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //---------------- UI Layout --------------------//
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 5.h),
            Text(
              'Welcome ${context.watch<UserModelCubit>().state.userModel.name}',
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Theme: ',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Switch(
                  value: context.watch<ThemeCubit>().state.appTheme ==
                      AppTheme.dark,
                  onChanged: (bool value) {
                    final newTheme = value ? AppTheme.dark : AppTheme.light;
                    context.read<ThemeCubit>().setTheme(newTheme);
                  },
                ),
                CustomButton(
                  text: 'Reset Theme',
                  buttonType: ButtonType.textButton,
                  enabled:
                      !context.watch<ThemeCubit>().state.isUsingSystemTheme,
                  onPressed: () {
                    context.read<ThemeCubit>().setDefaultTheme();
                  },
                )
              ],
            ),
            SizedBox(height: 5.h),
            Center(
              child: CustomButton(
                text: 'Profile',
                onPressed: () =>
                    NavHelper.push(context, const PreviewUserProfileScreen()),
              ),
            ),
            Center(
              child: LogoutConsumer(
                logoutActionWidget: CustomButton(
                  text: 'Logout',
                  onPressed: () {
                    context.read<LogoutCubit>().logout();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
