part of 'edit_user_profile_cubit.dart';

class EditUserProfileState extends Equatable {
  const EditUserProfileState({
    required this.name,
    required this.about,
    required this.avatar,
    required this.isAvatarEmpty,
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  /// The [name] field.
  final Name name;

  /// The [about] field.
  final String? about;

  /// The [avatar] value of type [ImageModel] which has info about image's type and data.
  final ImageModel avatar;

  /// A value that reflects the situation of having no user avatar.
  /// It'd be empty either when initialized and fetched data of user who has no avatar.
  /// Or if the avatar is removed from the edit screen UI.
  final bool isAvatarEmpty;

  /// The value of [status] shows info about the form which helps to know when to submit, or reset, or track the submission progress.
  /// - 🟡 [FormzStatus.pure] : The form is in initial state and has no changes.
  /// - 🔴 [FormzStatus.invalid] : The form has invalid changes on fields.
  /// - 🟢 [FormzStatus.valid] : The form has valid changes and ready to submit.
  /// - ⏳ [FormzStatus.submissionInProgress] : The form submission is in progress.
  /// - ❌ [FormzStatus.submissionFailure] : The form submission failed due to exception.
  /// - ✅ [FormzStatus.submissionSuccess] : The form is submitted successfully.
  final FormzStatus status;

  /// Carries error message when the submission fails.
  final String? errorMessage;

  @override
  List<Object?> get props {
    return [
      name,
      about,
      avatar,
      isAvatarEmpty,
      status,
      errorMessage,
    ];
  }

  EditUserProfileState copyWith({
    Name? name,
    String? about,
    ImageModel? avatar,
    bool? isAvatarEmpty,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return EditUserProfileState(
      name: name ?? this.name,
      about: about ?? this.about,
      avatar: avatar ?? this.avatar,
      isAvatarEmpty: isAvatarEmpty ?? this.isAvatarEmpty,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
