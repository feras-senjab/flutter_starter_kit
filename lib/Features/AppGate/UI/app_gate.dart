import 'package:flutter_starter_kit/Components/custom_loading.dart';
import 'package:flutter_starter_kit/Features/Auth/Login/UI/login_screen.dart';
import 'package:flutter_starter_kit/Features/Auth/Logout/cubit/logout_cubit.dart';
import 'package:flutter_starter_kit/Features/Home/UI/home_screen.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_starter_kit/Global/enums.dart';
import 'package:flutter_starter_kit/Helpers/dialog_helper.dart';
import 'package:flutter_starter_kit/Helpers/nav_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// AppGate is the initial screen that loads necessary data before
/// navigating to the target screen of the app. It listens for data load
/// success to proceed, or deal with error.
class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<UserModelCubit>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserModelCubit, UserModelState>(
      listener: (context, state) {
        if (state.stateStatus == StateStatus.success) {
          // Navigate to HomeScreen when data is loaded successfully
          NavHelper.pushAndRemoveUntil(context, const HomeScreen());
        } else if (state.stateStatus == StateStatus.failure) {
          // Handle fail loading data..
          // ! You can add here contact us option and/or send crush analytics.
          DialogHelper.showCustomAlert(
            context: context,
            title: 'Error fetching data!',
            content:
                'Failed to load and fetch data for your account. If the issue still remaining feel free to contact us',
            dismissible: false,
            btnText: 'Retry',
            onBtnPressed: () {
              // Retry loading data..
              _loadData();
            },
            btn2TextNullIfOneBtn: 'Logout',
            onBtn2PressedNullIfOneBtn: () {
              context.read<LogoutCubit>().logout();
              NavHelper.pushAndRemoveUntil(context, const LoginScreen());
            },
          );
        }
      },
      child: const Scaffold(
        body: Center(
          child: CustomLoading(),
        ),
      ),
    );
  }
}
