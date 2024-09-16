import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_starter_kit/Components/entry_field.dart';
import 'package:flutter_starter_kit/Components/custom_button.dart';
import 'package:flutter_starter_kit/Components/inkwell_text.dart';
import 'package:flutter_starter_kit/Features/Auth/SignUp/cubit/signup_cubit.dart';
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

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupCubit>(
      create: (context) => SignupCubit(
        authBloc: context.read<AuthBloc>(),
        authRepository: context.read<AuthRepository>(),
        userRepository: context.read<FirestoreUsersRepository>(),
      ),
      child: BlocConsumer<SignupCubit, SignupState>(
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
                    Text('Sign up..',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge),
                    SizedBox(
                      height: 5.h,
                    ),
                    EntryField(
                      label: 'Name',
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      onChanged: (name) =>
                          context.read<SignupCubit>().nameChanged(name),
                      errorText: state.name.invalid
                          ? Name.showNameErrorMessage(state.name.error)
                          : null,
                    ),
                    EntryField(
                      label: 'Email',
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      onChanged: (email) =>
                          context.read<SignupCubit>().emailChanged(email),
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
                          context.read<SignupCubit>().passwordChanged(password),
                      errorText: state.password.invalid
                          ? Password.showPasswordErrorMessage(
                              state.password.error)
                          : null,
                    ),
                    EntryField(
                      label: 'Confirm Password',
                      enabled: state.password.valid,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      onChanged: (confirmedPassword) => context
                          .read<SignupCubit>()
                          .confirmedPasswordChanged(confirmedPassword),
                      errorText: state.confirmedPassword.invalid
                          ? ConfirmedPassword.showConfirmedPasswordErrorMessage(
                              state.confirmedPassword.error,
                            )
                          : null,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Center(
                      child: CustomButton(
                        width: 50.w,
                        text: 'Sign up',
                        onPressed: () {
                          //! Navigation is done by listener..
                          state.status.isValidated
                              ? context
                                  .read<SignupCubit>()
                                  .signUpWithEmailAndPassword()
                              : DialogHelper.showCustomAlert(
                                  context: context,
                                  title: 'Form not completed!',
                                  content:
                                      'Please make sure to fill the form fields correctly.',
                                );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        InkwellText(
                          text: 'Sign in',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
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
