import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<EmailChange>(_onEmailChange);
    on<PasswordChange>(_onPasswordChange);
    on<FormSubmit>(_onFormSubmit);
  }

  //* --- Acceso por fuera  --- *//
  void emailChange(String value) {
    add(EmailChange(value));
  }

  void passwordChange(String value) {
    add(PasswordChange(value));
  }

  void formSubmit() {
    add(FormSubmit());
  }

  //* --- Logica de los eventos --- *//

  void _onEmailChange(EmailChange event, Emitter<AuthState> emit) {
    // Una nueva instancia del input Email como "dirty" (modificado)
    final newEmail = Email.dirty(event.value);
    emit(
      state.copyWith(
        email: newEmail,
        // FORMZ: Validamos el NUEVO email junto con el password ACTUAL
        isValidForm: Formz.validate([newEmail, state.password]),
      ),
    );
  }

  void _onPasswordChange(PasswordChange event, Emitter<AuthState> emit) {
    // Una nueva instancia del input Password como "dirty" (modificado)
    final newPassword = Password.dirty(event.value);
    emit(
      state.copyWith(
        password: newPassword,
        // FORMZ: Validamos el NUEVO password junto con el email ACTUAL
        isValidForm: Formz.validate([newPassword, state.email]),
      ),
    );
  }

  void _onFormSubmit(FormSubmit event, Emitter<AuthState> emit) async {
    // validacion de campos
    emit(_touchedEveryField());

    // Si después de "ensuciarlos" el formulario NO es válido, cancelamos la petición.
    // La UI automáticamente mostrará los textos rojos de error.
    if (!state.isValidForm) return;

    // si esta correctamente validado el formulario, bloqueamos el boton, hacemos la peticion y mostramos el spinner
    emit(state.copyWith(isPosting: true));

    try {
      await Future.delayed(const Duration(seconds: 2));
      print(state);
    } catch (e) {
      print('Error en el login: $e');
    } finally {
      emit(state.copyWith(isPosting: false));
    }
  }

  // La función devuelve un AuthState
  AuthState _touchedEveryField() {
    // "Tocamos" todos los campos con su valor actual para forzar la validación
    // Al pasarlos a .dirty(), si están vacíos, Formz los marcará con error
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    // Retornamos el nuevo estado, avisamos que se intentó postear
    // y recalculamos si el formulario es válido en su totalidad.
    return state.copyWith(
      isFormPosting: true,
      email: email,
      password: password,
      isValidForm: Formz.validate([email, password]),
    );
  }
}
