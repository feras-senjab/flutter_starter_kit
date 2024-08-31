import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_starter_kit/Components/entry_field.dart';
import 'package:flutter_starter_kit/Components/custom_button.dart';
import 'package:flutter_starter_kit/Components/inkwell_text.dart';
import 'package:flutter_starter_kit/Features/Auth/ForgotPassword/cubit/forgot_password_cubit.dart';
import 'package:flutter_starter_kit/Helpers/dialog_helper.dart';
import 'package:flutter_starter_kit/Helpers/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validators/form_validators.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordCubit>(
      create: (context) =>
          ForgotPasswordCubit(authRepository: context.read<AuthRepository>()),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
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
              DialogHelper.showCustomAlert(
                context: context,
                title: 'Reset Link Sent',
                content: 'Please check your email to reset password.',
                dismissible: false,
                popDialogOnBtn1Pressed: true,
                onBtnPressed: () {
                  Navigator.of(context).pop();
                },
              );
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
              body: SafeArea(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                  ),
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Enter your email to send reset link..',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    EntryField(
                      label: 'Email',
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      onChanged: (email) => context
                          .read<ForgotPasswordCubit>()
                          .emailChanged(email),
                      errorText: state.email.invalid
                          ? Email.showEmailErrorMessage(state.email.error)
                          : null,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Center(
                      child: CustomButton(
                        width: 50.w,
                        text: 'Send Reset Link',
                        onPressed: () {
                          //! Navigation is done by status listener..
                          state.status.isValidated
                              ? context
                                  .read<ForgotPasswordCubit>()
                                  .forgotPassword()
                              : DialogHelper.showCustomAlert(
                                  context: context,
                                  title: 'Email not set',
                                  content:
                                      'Please make sure to set the email correctly.',
                                );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Center(
                      child: InkwellText(
                        text: '<< Back to sign in',
                        textAlign: TextAlign.center,
                        onTap: () => Navigator.of(context).pop(),
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
