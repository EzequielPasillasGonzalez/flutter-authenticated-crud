import 'package:formz/formz.dart';

enum ConfirmPasswordError { empty, mismatch }

class ConfirmPassword extends FormzInput<String, ConfirmPasswordError> {
  final String originalPassword;

  const ConfirmPassword.pure({this.originalPassword = ''}) : super.pure('');

  const ConfirmPassword.dirty({
    required this.originalPassword,
    String value = '',
  }) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ConfirmPasswordError.empty) {
      return 'El campo es requerido';
    }
    if (displayError == ConfirmPasswordError.mismatch) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  @override
  ConfirmPasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return ConfirmPasswordError.empty;
    }

    if (value != originalPassword) return ConfirmPasswordError.mismatch;

    return null;
  }
}
