import 'package:equatable/equatable.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validators/form_validators.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit({
    required this.userModelCubit,
  }) : super(UserProfileState(
            name: Name.dirty(userModelCubit.state.userModel!.name)));

  final UserModelCubit userModelCubit;

  void editNameRequested() {
    emit(state.copyWith(isNameEditing: true));
  }

  void nameChanged(String value) {}
}
