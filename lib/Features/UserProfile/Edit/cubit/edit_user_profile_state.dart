part of 'edit_user_profile_cubit.dart';

class EditUserProfileState extends Equatable {
  const EditUserProfileState({
    required this.name,
    this.about,
    required this.avatar,
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Name name;
  final String? about;
  final ImageModel avatar;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props {
    return [
      name,
      about,
      avatar,
      status,
      errorMessage,
    ];
  }

  EditUserProfileState copyWith({
    Name? name,
    String? about,
    ImageModel? avatar,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return EditUserProfileState(
      name: name ?? this.name,
      about: about ?? this.about,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
