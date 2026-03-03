import 'package:formz/formz.dart';

enum NameError { empty, tooShort }

class Name extends FormzInput<String, NameError> {
  const Name.pure() : super.pure('');
  const Name.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == NameError.tooShort) {
      return 'El nombre debe tener al menos 3 caracteres';
    }

    if (displayError == NameError.empty) {
      return 'El campo es requerido';
    }

    return null;
  }

  @override
  NameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return NameError.empty;
    if (value.trim().length < 3) return NameError.tooShort;

    return null;
  }
}
