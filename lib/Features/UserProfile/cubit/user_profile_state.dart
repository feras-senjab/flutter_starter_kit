part of 'user_profile_cubit.dart';

class UserProfileState extends Equatable {
  const UserProfileState({
    this.isNameEditing = false,
    required this.name,
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final bool isNameEditing;
  final Name name;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [isNameEditing, name, status, errorMessage];

  UserProfileState copyWith({
    bool? isNameEditing,
    Name? name,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return UserProfileState(
      isNameEditing: isNameEditing ?? this.isNameEditing,
      name: name ?? this.name,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
