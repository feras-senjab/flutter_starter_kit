import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_starter_kit/Components/entry_field.dart';
import 'package:flutter_starter_kit/Components/custom_button.dart';
import 'package:flutter_starter_kit/Components/inkwell_text.dart';
import 'package:flutter_starter_kit/Features/Auth/Login/cubit/login_cubit.dart';
import 'package:flutter_starter_kit/Features/Auth/SignUp/UI/signup_screen.dart';
import 'package:flutter_starter_kit/Features/Auth/bloc/auth_bloc.dart';
import 'package:flutter_starter_kit/Features/AppGate/UI/app_gate.dart';
import 'package:flutter_starter_kit/Helpers/dialog_helper.dart';
import 'package:flutter_starter_kit/Helpers/loading_helper.dart';
import 'package:flutter_starter_kit/Helpers/nav_helper.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validators/form_validators.dart';
import 'package:sizer/sizer.dart';

import '../../ForgotPassword/UI/forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(
        authBloc: context.read<AuthBloc>(),
        authRepository: context.read<AuthRepository>(),
        userRepository: context.read<FirestoreUsersRepository>(),
      ),
      child: BlocConsumer<LoginCubit, LoginState>(
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
              NavHelper.pushAndRemoveUntil(context, const AppGate());
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
                      'FLUTTER STARTER KIT',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    EntryField(
                      label: 'Email',
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      onChanged: (email) =>
                          context.read<LoginCubit>().emailChanged(email),
                      errorText: state.email.invalid
                          ? Email.showEmailErrorMessage(state.email.error)
                          : null,
                    ),
                    EntryField(
                      label: 'Password',
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      onChanged: (password) =>
                          context.read<LoginCubit>().passwordChanged(password),
                      errorText: state.password.invalid
                          ? Password.showPasswordErrorMessage(
                              state.password.error)
                          : null,
                    ),
                    Row(
                      children: [
                        const Text('Forgot your password? '),
                        InkwellText(
                          text: 'Click here',
                          onTap: () => NavHelper.push(
                              context, const ForgotPasswordScreen()),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        const Text('Don\'t have an account? '),
                        InkwellText(
                          text: 'Register Now!',
                          onTap: () =>
                              NavHelper.push(context, const SignupScreen()),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Center(
                      child: CustomButton(
                        width: 50.w,
                        text: 'Sign in',
                        onPressed: () {
                          //! Navigation is done by listener..
                          state.status.isValidated
                              ? context
                                  .read<LoginCubit>()
                                  .signInWithEmailAndPassword()
                              : DialogHelper.showCustomAlert(
                                  context: context,
                                  title: 'Form not completed!',
                                  content:
                                      'Please make sure to fill the form fields correctly.',
                                );
                        },
                      ),
                    ),
                    Center(
                      child: CustomButton(
                        width: 50.w,
                        text: 'Google sign in',
                        onPressed: () {
                          //! Navigation is done by listener..
                          context.read<LoginCubit>().signInWithGoogle();
                        },
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
