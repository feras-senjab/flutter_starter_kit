import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_starter_kit/Features/Auth/bloc/auth_bloc.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_validators/form_validators.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required this.authRepository,
    required this.authBloc,
    required this.userRepository,
  }) : super(const SignupState());

  final AuthRepository authRepository;
  final AuthBloc authBloc;
  final FirestoreUsersRepository userRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);

    emit(state.copyWith(
      email: email,
      status: Formz.validate(
        [
          email,
          state.password,
          state.confirmedPassword,
        ],
      ),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);

    emit(state.copyWith(
      password: password,
      status: Formz.validate(
        [
          state.email,
          password,
          state.confirmedPassword,
        ],
      ),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
        password: state.password.value, confirmedPassword: value);
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      status: Formz.validate(
        [
          state.email,
          state.password,
          confirmedPassword,
        ],
      ),
    ));
  }

  void signUpWithEmailAndPassword() async {
    // Confirm validation
    if (!state.status.isValidated) return;

    // ⏳ Emit Loading..
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      // Sign up..
      await authRepository.signUpWithEmailAndPassword(
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

    // 📤 Notify AuthBloc by dispatching AuthSignUpRequested with the new user
    authBloc.add(AuthSignUpRequested(authRepository.getAuthUser()));
  }
}
