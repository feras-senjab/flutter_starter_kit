import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Components/entry_field.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_starter_kit/Features/UserProfile/cubit/user_profile_cubit.dart';
import 'package:form_validators/form_validators.dart';
import 'package:sizer/sizer.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserProfileCubit>(
      create: (context) => UserProfileCubit(
        userModelCubit: context.read<UserModelCubit>(),
      ),
      child: Builder(
        builder: (context) {
          final profileState = context.watch<UserProfileCubit>().state;
          //---------------- UI Layout --------------------//
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  SizedBox(
                    width: 70.w,
                    child: EntryField(
                      initialValue: profileState.name.value,
                      fillColor: profileState.isNameEditing ||
                              profileState.status ==
                                  FormzStatus.submissionInProgress
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2)
                          : null,
                      enabled: profileState.isNameEditing &&
                          profileState.status !=
                              FormzStatus.submissionInProgress,
                    ),
                  ),
                  profileState.status == FormzStatus.submissionInProgress
                      ? Padding(
                          padding: EdgeInsets.all(9.sp),
                          child: const CircularProgressIndicator(),
                        )
                      : IconButton(
                          onPressed: () {
                            if (!profileState.isNameEditing) {
                              context
                                  .read<UserProfileCubit>()
                                  .editNameRequested();
                            } else {}
                          },
                          icon: profileState.isNameEditing
                              ? const Icon(Icons.send)
                              : const Icon(Icons.edit),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
