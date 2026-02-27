import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/bloc.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final authRepository = AuthRepositoryImpl();

  // Inyectamos el provider de Auth
  final AuthBloc authBloc;

  LoginBloc({required this.authBloc}) : super(LoginState()) {
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

  void _onEmailChange(EmailChange event, Emitter<LoginState> emit) {
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

  void _onPasswordChange(PasswordChange event, Emitter<LoginState> emit) {
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

  Future<void> _onFormSubmit(FormSubmit event, Emitter<LoginState> emit) async {
    // validacion de campos
    emit(_touchedEveryField());

    // Si el formulario NO es válido, cancela la petición
    if (!state.isValidForm) return;

    // Bloquea el boton y mostramos el spinner
    emit(state.copyWith(isPosting: true));

    try {
      final User user = await authRepository.login(
        state.email.value,
        state.password.value,
      );

      // Dejamos que AuthBloc se encargue de manejar el usuario
      authBloc.loginSuccess(user);
    } on WrongCredentials {
      authBloc.logoutRequested('Correo o contraseña incorrectos');
    } catch (e) {
      authBloc.logoutRequested('Error no controlado: Ocurrió un problema');
    } finally {
      emit(state.copyWith(isPosting: false));
    }
  }

  // La función devuelve un LoginState
  LoginState _touchedEveryField() {
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
