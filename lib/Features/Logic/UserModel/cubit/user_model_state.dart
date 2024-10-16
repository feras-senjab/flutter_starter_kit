part of 'user_model_cubit.dart';

class UserModelState extends Equatable {
  const UserModelState({
    this.userModel = FirestoreUserModel.empty,
    this.stateStatus = StateStatus.initial,
  });

  final FirestoreUserModel userModel;
  final StateStatus stateStatus;

  @override
  List<Object> get props => [userModel, stateStatus];

  UserModelState copyWith({
    FirestoreUserModel? userModel,
    StateStatus? stateStatus,
  }) {
    return UserModelState(
      userModel: userModel ?? this.userModel,
      stateStatus: stateStatus ?? this.stateStatus,
    );
  }
}
