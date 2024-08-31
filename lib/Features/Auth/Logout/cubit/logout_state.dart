part of 'logout_cubit.dart';

class LogoutState extends Equatable {
  const LogoutState({
    this.status = StateStatus.initial,
  });

  final StateStatus status;

  @override
  List<Object> get props => [status];

  LogoutState copyWith({
    StateStatus? status,
  }) {
    return LogoutState(
      status: status ?? this.status,
    );
  }
}
