import 'package:flutter_starter_kit/Features/Auth/bloc/auth_bloc.dart';
import 'package:flutter_starter_kit/Global/enums.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;

part 'user_model_state.dart';

extension EmptyUser on FirestoreUserModel {
  bool get isEmpty => this == FirestoreUserModel.empty;
}

class UserModelCubit extends Cubit<UserModelState> {
  UserModelCubit({
    required this.usersRepository,
    required this.authBloc,
  }) : super(const UserModelState());

  final FirestoreUsersRepository usersRepository;
  final AuthBloc authBloc;

  /// Load user data from firestore and store it in `state.userModel`.
  /// If the user has no data in firestore (new user), the `state.userModel` remains empty.
  ///
  /// The state's status will be:
  /// * ⏳ Loading:
  ///   - 🔜 When fetching user data is in progress.
  /// * ✅ Success:
  ///   - 👍 When the user data is loaded successfully (userModel carries the data).
  ///   - 👎 When the user has no data in firestore (userModel remains empty).
  /// * ❌ Failure:
  ///   - 🔒 When the user is NOT authenticated.
  ///   - ❗ When a platform exception happens.
  Future loadData() async {
    try {
      if (authBloc.state.status == AuthStatus.authenticated) {
        // ⏳ Emit Loading
        emit(state.copyWith(stateStatus: StateStatus.loading));

        // Fetch user data..
        FirestoreUserModel? userModel =
            await usersRepository.getById(id: authBloc.state.user!.id);

        // Deal with data not found situation..
        if (userModel == null) {
          // ✅ 👎 Emit success with empty user data
          emit(
            state.copyWith(
                userModel: FirestoreUserModel.empty,
                stateStatus: StateStatus.success),
          );
        }

        // ✅ 👍 Emit success with existed registered user data
        emit(state.copyWith(
            userModel: userModel, stateStatus: StateStatus.success));
      } else {
        throw Exception('No authenticated user!');
      }
    } catch (error) {
      developer.log('Error loading user data: $error');
      // ❌ Emit Failure
      emit(state.copyWith(stateStatus: StateStatus.failure));
    }
  }

  /// 🔄 Reset state to initial (remove loaded data)..
  void resetState() {
    emit(const UserModelState());
  }
}
