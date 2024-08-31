import 'package:flutter_starter_kit/Features/Auth/bloc/auth_bloc.dart';
import 'package:flutter_starter_kit/Global/enums.dart';
import 'package:firebase_repository/firebase_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;

part 'user_model_state.dart';

class UserModelCubit extends Cubit<UserModelState> {
  UserModelCubit({
    required this.usersRepository,
    required this.authBloc,
  }) : super(const UserModelState());

  final FirebaseUsersRepository usersRepository;
  final AuthBloc authBloc;

  Future loadData() async {
    try {
      if (authBloc.state.status == AuthStatus.authenticated) {
        emit(state.copyWith(stateStatus: StateStatus.loading));
        FirebaseUserModel? userModel =
            await usersRepository.getById(id: authBloc.state.user!.id);

        // Deal with data not found situation..
        if (userModel == null) {
          throw Exception('This user has no registered data!');
        }

        emit(state.copyWith(
            userModel: userModel, stateStatus: StateStatus.success));
      } else {
        throw Exception('No authenticated user!');
      }
    } catch (error) {
      developer.log('Error loading user data: $error');

      emit(state.copyWith(stateStatus: StateStatus.failure));
    }
  }

  // Reset state to initial (remove loaded data)..
  void resetState() {
    emit(const UserModelState());
  }
}
