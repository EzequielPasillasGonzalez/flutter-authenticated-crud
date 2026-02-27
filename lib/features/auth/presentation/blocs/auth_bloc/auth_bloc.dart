import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infrastructure/repositories/auth_repository_impl.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authRepository = AuthRepositoryImpl();

  AuthBloc() : super(const AuthChecking()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginSuccess>(_onLoginSuccess);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  //* --- Acceso por fuera  --- *//
  void checkAuth() {
    add(AuthCheckRequested());
  }

  void loginSuccess(User user) {
    add(AuthLoginSuccess(user));
  }

  void logoutRequested(String message) {
    add(AuthLogoutRequested(message));
  }

  //* --- Logica de eventos --- *//
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Se revisa en el localStorage si hay un token

    try {
      // authRepository.checkAuthStatus();
      // Si el token es valido traemos los datos del usuario y lo emitimos

      // Si no hay un token valido, lo retornamos al login
      emit(
        const AuthNotAuthenticated(errorMessage: 'No tienes una sesión activa'),
      );
    } catch (e) {
      emit(const AuthNotAuthenticated(errorMessage: 'Sesión caducada'));
    }
  }

  void _onLoginSuccess(AuthLoginSuccess event, Emitter<AuthState> emit) async {
    emit(AuthAuthenticated(user: event.user));
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthNotAuthenticated(errorMessage: event.errorMessage));
  }
}
