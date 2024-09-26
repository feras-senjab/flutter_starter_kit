import 'package:cloud_storage_repository/cloud_storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Global/Models/image_model.dart';
import 'package:flutter_starter_kit/Global/app_assets.dart';
import 'package:form_validators/form_validators.dart';

part 'edit_user_profile_state.dart';

class EditUserProfileCubit extends Cubit<EditUserProfileState> {
  EditUserProfileCubit({
    required this.userModelCubit,
    required this.usersRepository,
    required this.usersStorageRepository,
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
  final FirestoreUsersRepository usersRepository;
  final CloudStorageUsersRepository usersStorageRepository;

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
    emit(
      state.copyWith(
        about: value,
      ),
    );
  }

  void submit() async {
    if (!state.status.isValidated) return;
    //TODO handle empty about

    //
    //final String userId = userModelCubit.state.userModel!.id;
    final FirestoreUserModel currentUserModel = userModelCubit.state.userModel!;
    final String cloudAvatarPath;
    try {
      if (state.avatar.imageType == ImageType.file &&
          state.avatar.file != null) {
        cloudAvatarPath = await usersStorageRepository.uploadUserAvatar(
          userId: currentUserModel.id,
          file: state.avatar.file!,
        );
      }
    } catch (error) {
      if (error is CloudStorageFileException) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            errorMessage: error.message,
          ),
        );
      } else {
        state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'Submission failed due to issue with uploading avatar!',
        );
      }

      return;
    }

    //! del me

    //!

    // usersRepository.update(
    //   id: currentUserModel.id,
    //   oldModel: currentUserModel,
    //   newModel: currentUserModel.copyWith(
    //     name: state.name.value,
    //   ),
    // );
  }
}
