import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Features/Auth/Login/UI/login_screen.dart';
import 'package:flutter_starter_kit/Features/Auth/Logout/cubit/logout_cubit.dart';
import 'package:flutter_starter_kit/Global/enums.dart';
import 'package:flutter_starter_kit/Helpers/dialog_helper.dart';
import 'package:flutter_starter_kit/Helpers/loading_helper.dart';
import 'package:flutter_starter_kit/Helpers/nav_helper.dart';

/// A custom consumer widget that wraps around the `BlocConsumer` and handles the logout logic.
/// It tracks the logout state changes and implements the appropriate UI:
/// - ⏳ Shows Loading when the logout in progress.
/// - ❌ Shows Custom alert when the logout fails.
/// - ✅ Navigate to Login screen when the logout success.
///
/// In order to take action, the parameter [logoutActionWidget] needs to be a clickable widget,
/// and it needs to call `context.read<LogoutCubit>().logout();` on click.
///
/// No need for any state tracking, alert showing, or navigation, as this widget will do the job 😀
class LogoutConsumer extends StatelessWidget {
  const LogoutConsumer({
    super.key,
    required this.logoutActionWidget,
  });

  /// A clickable widget to logout. In order to take action,
  /// you need to call `context.read<LogoutCubit>().logout();` on its click.
  final Widget logoutActionWidget;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == StateStatus.loading) {
          LoadingHelper.showLoading(context);
        } else {
          LoadingHelper.dismissLoading();
          if (state.status == StateStatus.failure) {
            DialogHelper.showCustomAlert(
              context: context,
              title: 'Error',
              content: 'Logout Failed!',
            );
          } else if (state.status == StateStatus.success) {
            NavHelper.pushAndRemoveUntil(context, const LoginScreen());
          }
        }
      },
      builder: (context, state) {
        return logoutActionWidget;
      },
    );
  }
}
