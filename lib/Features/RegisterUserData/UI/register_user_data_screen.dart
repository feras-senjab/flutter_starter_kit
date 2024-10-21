import 'package:auth_repository/auth_repository.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Components/custom_button.dart';
import 'package:flutter_starter_kit/Components/entry_field.dart';
import 'package:flutter_starter_kit/Features/AppGate/UI/app_gate.dart';
import 'package:flutter_starter_kit/Features/Auth/Logout/cubit/logout_cubit.dart';
import 'package:flutter_starter_kit/Features/Auth/Logout/widgets/logout_consumer.dart';
import 'package:flutter_starter_kit/Features/RegisterUserData/cubit/register_user_data_cubit.dart';
import 'package:flutter_starter_kit/Helpers/dialog_helper.dart';
import 'package:flutter_starter_kit/Helpers/loading_helper.dart';
import 'package:flutter_starter_kit/Helpers/nav_helper.dart';
import 'package:form_validators/form_validators.dart';
import 'package:sizer/sizer.dart';

class RegisterUserDataScreen extends StatelessWidget {
  const RegisterUserDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //---------------- BlocProvider --------------------//
    return BlocProvider<RegisterUserDataCubit>(
      create: (context) => RegisterUserDataCubit(
        authRepository: context.read<AuthRepository>(),
        userRepository: context.read<FirestoreUsersRepository>(),
      ),
      //---------------- BlocConsumer --------------------//
      child: BlocConsumer<RegisterUserDataCubit, RegisterUserDataState>(
        listenWhen: (previous, current) => previous.status != current.status,
        //---------------- Listener --------------------//
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
              //---------------- AppBar --------------------//
              appBar: AppBar(
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    //---------------- 🚶‍♂️ Logout --------------------//
                    child: LogoutConsumer(
                      logoutActionWidget: InkWell(
                        child: const Row(
                          children: [
                            Text(
                              'Logout ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.logout),
                          ],
                        ),
                        onTap: () {
                          context.read<LogoutCubit>().logout();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              //---------------- Body --------------------//
              body: SafeArea(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                  ),
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text('One last step, tell us about you please.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(
                      height: 5.h,
                    ),
                    //---------------- 🔤 Name --------------------//
                    EntryField(
                      label: 'Name',
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.none,
                      onChanged: (name) => context
                          .read<RegisterUserDataCubit>()
                          .nameChanged(name),
                      errorText: state.name.invalid
                          ? Name.showNameErrorMessage(state.name.error)
                          : null,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    //---------------- 🚀 Submit --------------------//
                    Center(
                      child: CustomButton(
                        text: 'Submit',
                        width: 50.w,
                        enabled: state.status.isValidated,
                        onPressed: () {
                          // Dismiss keyboard
                          FocusScope.of(context).unfocus();
                          //! Loading & Navigation are done by listener..
                          context
                              .read<RegisterUserDataCubit>()
                              .insertUserData();
                        },
                      ),
                    )
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
