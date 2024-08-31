part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLogInRequested extends AuthEvent {
  const AuthLogInRequested(this.user);

  final AuthUser? user;

  @override
  List<Object?> get props => [user];
}

class AuthSignUpRequested extends AuthEvent {
  const AuthSignUpRequested(this.user);

  final AuthUser? user;

  @override
  List<Object?> get props => [user];
}

class AppStarted extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}
