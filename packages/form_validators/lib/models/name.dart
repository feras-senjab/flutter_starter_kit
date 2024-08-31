import 'package:formz/formz.dart';

enum NameValidationError { empty, invalid }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');

  const Name.dirty([String value = '']) : super.dirty(value);

  static final RegExp _nameRegExp = RegExp(
    r'^[\p{Ll}\p{Lu} ]{3,16}$',
    unicode: true,
  );

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) {
      return NameValidationError.empty;
    }
    return _nameRegExp.hasMatch(value) ? null : NameValidationError.invalid;
  }

  static String? showNameErrorMessage(NameValidationError? error) {
    if (error == NameValidationError.empty) {
      return 'Empty name';
    } else if (error == NameValidationError.invalid) {
      return 'Invalid name';
    } else {
      return null;
    }
  }
}
