part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [email, status, errorMessage];

  ForgotPasswordState copyWith({
    Email? email,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
