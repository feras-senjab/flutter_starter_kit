import 'dart:developer' as developer;

import 'package:cloud_storage_repository/cloud_storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter_kit/Global/Models/image_model.dart';
import 'package:flutter_starter_kit/Helpers/strings_helper.dart';
import 'package:form_validators/form_validators.dart';

part 'edit_user_profile_state.dart';

/// Enum to determine what type of change happens to avatar.
enum _AvatarChangeType {
  /// 🟢 New avatar is set.
  avatarSet,

  /// 🔴 The original avatar is removed.
  avatarRemoved,

  /// 🟡 There is NO change happened on avatar.
  noAvatarChange,
}

class EditUserProfileCubit extends Cubit<EditUserProfileState> {
  EditUserProfileCubit({
    required this.userModel,
    required this.usersRepository,
    required this.usersStorageRepository,
    required this.emptyAvatarImageModel,
  }) : super(
          _initialState(userModel, emptyAvatarImageModel),
        );

  final FirestoreUserModel userModel;
  final FirestoreUsersRepository usersRepository;
  final CloudStorageUsersRepository usersStorageRepository;

  /// Image model for empty avatar situation.
  final ImageModel emptyAvatarImageModel;

  //-------------------- 🛠️ Helpers  🛠️ --------------------//

  /// 🚧 Helper method to create initial state.
  static EditUserProfileState _initialState(
      FirestoreUserModel userModel, ImageModel emptyAvatarImageModel) {
    return EditUserProfileState(
      name: Name.dirty(userModel.name),
      about: userModel.about,
      avatar: [null, ''].contains(userModel.avatarUrl)
          ? emptyAvatarImageModel
          : ImageModel.network(userModel.avatarUrl!),
      isAvatarEmpty: [null, ''].contains(userModel.avatarUrl),
    );
  }

  /// 👤 Helper method to present the type of change that an avatar image model would reflect.
  _AvatarChangeType _getAvatarChangeType({required ImageModel avatar}) {
    // Check if it reflects that new avatar is set
    if (avatar.imageType == ImageType.file && avatar.file != null) {
      return _AvatarChangeType.avatarSet;
    }
    // Check if it reflects that the original avatar is removed
    else if (![null, ''].contains(userModel.avatarUrl) &&
        avatar == emptyAvatarImageModel) {
      return _AvatarChangeType.avatarRemoved;
    }
    // Check if it reflects that no change happened on avatar
    else {
      return _AvatarChangeType.noAvatarChange;
    }
  }

  /// 🚦 Helper method to present the change in status that happens due to fields values.
  /// It returns:
  /// - [FormzStatus.invalid] if a field is not valid.
  /// - [FormzStatus.valid] if the fields are valid and has changes (ready to submit).
  /// - [FormzStatus.pure] if the fields are valid but has NO changes.
  FormzStatus _getFormStatus({
    required Name name,
    required String? about,
    required ImageModel avatar,
  }) {
    // Check fields validation.
    if (Formz.validate([name]) == FormzStatus.invalid) {
      return FormzStatus.invalid;
    }

    final isNameChanged = name.value != userModel.name;
    final isAboutChanged = about != userModel.about;
    final isAvatarChanged = _getAvatarChangeType(avatar: avatar) !=
        _AvatarChangeType.noAvatarChange;

    // Check fields changes.
    if (isNameChanged || isAboutChanged || isAvatarChanged) {
      return FormzStatus.valid;
    }

    // Pure state if the form is valid and has no changes.
    return FormzStatus.pure;
  }

  //-------------------- ✨ Actions ✨ --------------------//

  /// 🔄 Emits the initial state
  void reset() {
    if (!state.status.isPure) {
      emit(_initialState(userModel, emptyAvatarImageModel));
    }
  }

  // # 👤 Avatar actions:

  void removeAvatar() {
    emit(
      state.copyWith(
        avatar: emptyAvatarImageModel,
        isAvatarEmpty: true,
        status: _getFormStatus(
          name: state.name,
          about: state.about,
          avatar: emptyAvatarImageModel,
        ),
      ),
    );
  }

  void avatarChanged(ImageModel imageModel) {
    emit(
      state.copyWith(
        avatar: imageModel,
        isAvatarEmpty: false,
        status: _getFormStatus(
          name: state.name,
          about: state.about,
          avatar: imageModel,
        ),
      ),
    );
  }

  // # 🔤 Fields Actions:

  void nameChanged(String value) {
    // Normalize `name` string
    final normalized = StringsHelper.removeExtraSpaces(input: value);

    final name = Name.dirty(normalized);

    emit(
      state.copyWith(
        name: name,
        status: _getFormStatus(
          name: name,
          about: state.about,
          avatar: state.avatar,
        ),
      ),
    );
  }

  void aboutChanged(String value) {
    // Normalize `about` string
    String about = value.trim();

    if (about.isNotEmpty) {
      emit(
        state.copyWith(
            about: about,
            status: _getFormStatus(
              name: state.name,
              about: about,
              avatar: state.avatar,
            )),
      );
    }
  }

  /// 🚀 Submit the form.
  void submit() async {
    // Confirm that form is ready to submit
    //! Note: `isValid` is implemented to reflect that form is valid and has changes.
    if (!state.status.isValid) return;

    // ⏳ Emit Loading..
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    //---------------- Avatar Cloud Storage Operations --------------------//
    String? cloudAvatarPath;
    final avatarChangeLog = _getAvatarChangeType(avatar: state.avatar);
    try {
      // If new avatar is set, upload it to cloud storage and get Url.
      if (avatarChangeLog == _AvatarChangeType.avatarSet) {
        cloudAvatarPath = await usersStorageRepository.uploadUserAvatar(
          userId: userModel.id,
          file: state.avatar.file!,
        );
      }
      // If the original avatar is removed (without setting new avatar), remove it from cloud.
      else if (avatarChangeLog == _AvatarChangeType.avatarRemoved) {
        await usersStorageRepository.deleteUserAvatar(userId: userModel.id);
      }
    } catch (error) {
      developer.log('$error');

      if (error is CloudStorageFileException) {
        // ❌ 📁 Emit Failure (Cloud Storage File exception)
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            errorMessage: error.message,
          ),
        );
      } else {
        // ❌ 🌩️ Emit Failure (Cloud Storage Platform Exception)
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            errorMessage:
                'Submission failed due to issue with uploading avatar!',
          ),
        );
      }

      return; // Break the submission on failed cloud operation.
    }

    //---------------- Update Firestore Operations --------------------//
    try {
      // updates only the changed fields with the appropriate values
      await usersRepository.updateFieldsFromMap(
        id: userModel.id,
        updateMap: userModel.toUpdateMap(
          name: state.name.value == userModel.name
              ? null
              : FirestoreFieldUpdater.setField(state.name.value),
          about: state.about == userModel.about
              ? null
              : FirestoreFieldUpdater.setField(state.about),
          avatarUrl: avatarChangeLog == _AvatarChangeType.noAvatarChange
              ? null
              : (avatarChangeLog == _AvatarChangeType.avatarRemoved
                  ? FirestoreFieldUpdater.setField(null)
                  : FirestoreFieldUpdater.setField(cloudAvatarPath)),
        ),
      );
    } catch (error) {
      developer.log('$error');
      // ❌ 🗄️ Emit Failure (Firestore Repository Exception)
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'Submission failed due to issue with updating data!',
        ),
      );

      return; // Break the submission on failed firestore update.
    }

    // ✅ Emit success.
    emit(state.copyWith(status: FormzStatus.submissionSuccess));
  }
}
