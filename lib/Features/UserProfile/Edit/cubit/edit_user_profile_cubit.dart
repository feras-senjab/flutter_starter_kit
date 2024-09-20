import 'package:equatable/equatable.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Global/Models/image_source.dart';
import 'package:flutter_starter_kit/Global/app_assets.dart';
import 'package:form_validators/form_validators.dart';

part 'edit_user_profile_state.dart';

class EditUserProfileCubit extends Cubit<EditUserProfileState> {
  EditUserProfileCubit({
    required this.userModelCubit,
  }) : super(
          EditUserProfileState(
              name: Name.dirty(userModelCubit.state.userModel!.name),
              about: userModelCubit.state.userModel!.about,
              avatar: userModelCubit.state.userModel!.avatarUrl == null
                  ? const ImageModel.asset(AppAssets.userDefaultAvatar)
                  : ImageModel.network(
                      userModelCubit.state.userModel!.avatarUrl!)),
        );

  final UserModelCubit userModelCubit;

  void avatarChanged(ImageModel imageModel) {
    emit(
      state.copyWith(
        avatar: imageModel,
      ),
    );
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);

    emit(
      state.copyWith(
        name: name,
        status: Formz.validate([name]),
      ),
    );
  }

  void aboutChanged(String value) {
    // TODO.. decision (make formz!!)
    emit(
      state.copyWith(
        about: value,
      ),
    );
  }
}
