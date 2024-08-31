import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { invalid }

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmedPassword.dirty(
      {required String this.password, required String confirmedPassword})
      : super.dirty(confirmedPassword);

  final String? password;

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    return (password == value && value.isNotEmpty)
        ? null
        : ConfirmedPasswordValidationError.invalid;
  }

  static String? showConfirmedPasswordErrorMessage(
      ConfirmedPasswordValidationError? error) {
    if (error == ConfirmedPasswordValidationError.invalid) {
      return 'Password not match!';
    } else {
      return null;
    }
  }
}
