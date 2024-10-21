part of 'register_user_data_cubit.dart';

class RegisterUserDataState extends Equatable {
  const RegisterUserDataState({
    this.name = const Name.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Name name;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [name, status, errorMessage];

  RegisterUserDataState copyWith({
    Name? name,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return RegisterUserDataState(
      name: name ?? this.name,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
