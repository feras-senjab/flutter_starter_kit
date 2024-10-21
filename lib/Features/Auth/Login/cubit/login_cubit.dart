import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_starter_kit/Features/Auth/bloc/auth_bloc.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_validators/form_validators.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.authRepository,
    required this.userRepository,
    required this.authBloc,
  }) : super(const LoginState());

  final AuthRepository authRepository;
  final FirestoreUsersRepository userRepository;
  final AuthBloc authBloc;

  void emailChanged(String value) {
    final email = Email.dirty(value);

    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);

    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  void signInWithEmailAndPassword() async {
    // Confirm validation
    if (!state.status.isValidated) return;

    // ⏳ Emit Loading..
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      // Sign in..
      await authRepository.signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
    } on AuthException catch (e) {
      // ❌ Emit Failure
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.message));

      return; // Terminate the submission process on AuthException
    }

    // ✅ Emit success
    emit(state.copyWith(status: FormzStatus.submissionSuccess));

    // 📤 Notify AuthBloc by dispatching AuthLogInRequested with the user
    authBloc.add(AuthLogInRequested(authRepository.getAuthUser()));
  }
}
