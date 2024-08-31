part of 'user_model_cubit.dart';

class UserModelState extends Equatable {
  const UserModelState({
    this.userModel,
    this.stateStatus = StateStatus.initial,
  });

  final FirebaseUserModel? userModel;
  final StateStatus stateStatus;

  @override
  List<Object?> get props => [userModel, stateStatus];

  UserModelState copyWith({
    FirebaseUserModel? userModel,
    StateStatus? stateStatus,
  }) {
    return UserModelState(
      userModel: userModel ?? this.userModel,
      stateStatus: stateStatus ?? this.stateStatus,
    );
  }
}
