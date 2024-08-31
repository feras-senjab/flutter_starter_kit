import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_starter_kit/Features/Auth/bloc/auth_bloc.dart';
import 'package:firebase_repository/firebase_repository.dart';
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
  final FirebaseUsersRepository userRepository;

  void nameChanged(String value) {
    final name = Name.dirty(value);

    emit(state.copyWith(
      name: name,
      status: Formz.validate(
        [
          name,
          state.email,
          state.password,
          state.confirmedPassword,
        ],
      ),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);

    emit(state.copyWith(
      email: email,
      status: Formz.validate(
        [
          state.name,
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
          state.name,
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
          state.name,
          state.email,
          state.password,
          confirmedPassword,
        ],
      ),
    ));
  }

  void signUpWithEmailAndPassword() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      // Sign up..
      await authRepository.signUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      // user id:
      String userId = authRepository.getAuthUser().id;
      // Register user's data..
      await userRepository
          .create(
        id: userId,
        model: FirebaseUserModel(
          id: userId,
          name: state.name.value,
          email: state.email.value,
        ),
      )
          .onError(
        (error, stackTrace) {
          // ! if regestering data fails, delete the user in authRepo..
          authRepository.deleteCurrentUser();
          throw Exception(error);
        },
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      authBloc.add(AuthSignUpRequested(authRepository.getAuthUser()));
    } on AuthException catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.message));
    }
  }
}
