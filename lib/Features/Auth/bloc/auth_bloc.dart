import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auth_repository/auth_repository.dart';
import 'dart:developer' as developer;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.authRepository,
  }) : super(const AuthState.unknown()) {
    on<AppStarted>(_onAppStarted);
    on<AuthLogInRequested>(_onAuthLogInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthLogoutRequested>(_onAuthLogOutRequested);
  }

  final AuthRepository authRepository;

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      final isSignedIn = authRepository.isUserSignedIn();
      if (isSignedIn) {
        final authUser = authRepository.getAuthUser();
        emit(AuthState.authenticated(authUser));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (error) {
      developer.log('ERROR IN _onAppStarted: $error');
      emit(const AuthState.unauthenticated());
    }
  }

  void _onAuthLogInRequested(
    AuthLogInRequested event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null && event.user != AuthUser.empty) {
      emit(AuthState.authenticated(event.user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  void _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null && event.user != AuthUser.empty) {
      emit(AuthState.authenticated(event.user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  void _onAuthLogOutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.unauthenticated());
  }
}
