import 'package:formz/formz.dart';

// Define input validation errors
enum TitleProductError { empty }

// Extend FormzInput and provide the input type and error type.
class TitleProduct extends FormzInput<String, TitleProductError> {
  // Call super.pure to represent an unmodified form input.
  const TitleProduct.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const TitleProduct.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == TitleProductError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  TitleProductError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return TitleProductError.empty;

    return null;
  }
}
