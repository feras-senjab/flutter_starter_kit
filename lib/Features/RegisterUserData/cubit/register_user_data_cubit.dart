import 'package:auth_repository/auth_repository.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_validators/form_validators.dart';

part 'register_user_data_state.dart';

class RegisterUserDataCubit extends Cubit<RegisterUserDataState> {
  RegisterUserDataCubit({
    required this.authRepository,
    required this.userRepository,
  }) : super(const RegisterUserDataState());

  final AuthRepository authRepository;
  final FirestoreUsersRepository userRepository;

  void nameChanged(String value) {
    final name = Name.dirty(value);

    emit(state.copyWith(
      name: name,
      status: Formz.validate(
        [name],
      ),
    ));
  }

  /// Create user doc in Firestore with the inserted data
  void insertUserData() async {
    // Confirm validation
    if (!state.status.isValidated) return;

    // ⏳ Emit Loading..
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    AuthUser authUser = authRepository.getAuthUser();
    try {
      // Create user document in firestore..
      await userRepository.create(
        id: authUser.id,
        model: FirestoreUserModel(
          id: authUser.id,
          name: state.name.value,
          email: authUser.email!,
        ),
      );
    } on FirestoreException {
      // ❌ Emit Failure
      emit(
        state.copyWith(
            status: FormzStatus.submissionFailure,
            errorMessage:
                'Failed to insert user data, please check your connection and try again!'),
      );

      return; // Terminate the submission process on FirestoreException
    }

    // ✅ Emit success
    emit(state.copyWith(status: FormzStatus.submissionSuccess));
  }
}
