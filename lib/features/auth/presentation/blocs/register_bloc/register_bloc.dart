import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final authRepository = AuthRepositoryImpl();

  final AuthBloc authBloc;

  RegisterBloc({required this.authBloc}) : super(RegisterState()) {
    on<RegisterNameChange>(_onNameChange);
    on<RegisterEmailChange>(_onEmailChange);
    on<RegisterPasswordChange>(_onPasswordChange);
    on<RegisterConfirmPasswordChange>(_onConfirmPasswordChange);
    on<RegisterFormSubmit>(_onFormSubmit);
  }

  //* --- Acceso por fuera  --- *//
  void nameChange(String value) {
    add(RegisterNameChange(value));
  }

  void emailChange(String value) {
    add(RegisterEmailChange(value));
  }

  void passwordChange(String value) {
    add(RegisterPasswordChange(value));
  }

  void confirmPasswordChange(String value) {
    add(RegisterConfirmPasswordChange(value));
  }

  void formSubmit() {
    add(RegisterFormSubmit());
  }

  //* --- Logica de eventos --- *//

  void _onNameChange(RegisterNameChange event, Emitter<RegisterState> emit) {
    final newName = Name.dirty(event.value);
    emit(
      state.copyWith(
        name: newName,
        isValidForm: Formz.validate([
          newName,
          state.email,
          state.password,
          state.confirmPassword,
        ]),
      ),
    );
  }

  void _onEmailChange(RegisterEmailChange event, Emitter<RegisterState> emit) {
    final newEmail = Email.dirty(event.value);
    emit(
      state.copyWith(
        email: newEmail,
        isValidForm: Formz.validate([
          newEmail,
          state.name,
          state.password,
          state.confirmPassword,
        ]),
      ),
    );
  }

  void _onPasswordChange(
    RegisterPasswordChange event,
    Emitter<RegisterState> emit,
  ) {
    final newPassword = Password.dirty(event.value);
    final updatedConfirmPassword = ConfirmPassword.dirty(
      originalPassword: newPassword.value,
      value: state.confirmPassword.value,
    );
    emit(
      state.copyWith(
        password: newPassword,
        confirmPassword: updatedConfirmPassword,
        isValidForm: Formz.validate([
          state.name,
          state.email,
          newPassword,
          updatedConfirmPassword,
        ]),
      ),
    );
  }

  void _onConfirmPasswordChange(
    RegisterConfirmPasswordChange event,
    Emitter<RegisterState> emit,
  ) {
    final newConfirmPassword = ConfirmPassword.dirty(
      originalPassword: state.password.value,
      value: event.value,
    );
    emit(
      state.copyWith(
        confirmPassword: newConfirmPassword,
        isValidForm: Formz.validate([
          newConfirmPassword,
          state.name,

          state.email,
          state.password,
        ]),
      ),
    );
  }

  Future<void> _onFormSubmit(
    RegisterFormSubmit event,
    Emitter<RegisterState> emit,
  ) async {
    emit(_touchedEveryField());

    if (!state.isValidForm) return;

    emit(state.copyWith(isPosting: true));

    try {
      final User user = await authRepository.register(
        state.email.value,
        state.password.value,
        state.name.value,
      );

      authBloc.loginSuccess(user);
    } on CustomError catch (e) {
      authBloc.logoutRequested(e.message);
    } catch (e) {
      authBloc.logoutRequested('Error no controlado: Ocurrió un problema');
    } finally {
      emit(state.copyWith(isPosting: false));
    }
  }

  RegisterState _touchedEveryField() {
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = ConfirmPassword.dirty(
      originalPassword: password.value,
      value: state.confirmPassword.value,
    );

    return state.copyWith(
      email: email,
      confirmPassword: confirmPassword,
      name: name,
      password: password,
      isValidForm: Formz.validate([name, email, password, confirmPassword]),
    );
  }
}
