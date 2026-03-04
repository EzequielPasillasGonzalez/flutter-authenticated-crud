import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:teslo_shop/features/shared/shared.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

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

  void logoutRequested([String message = '']) {
    add(AuthLogoutRequested(message));
  }

  //* --- Logica de eventos --- *//
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Se revisa en el localStorage si hay un token
      final token = await keyValueStorageService.getValue<String>('token');
      if (token == null) {
        return emit(const AuthNotAuthenticated(errorMessage: ''));
      }
      // Si el token es valido traemos los datos del usuario y lo emitimos
      final user = await authRepository.checkAuthStatus(token);

      emit(AuthAuthenticated(user: user));
    } catch (e) {
      await keyValueStorageService.removeKey('token');
      emit(const AuthNotAuthenticated(errorMessage: 'Sesión caducada'));
    }
  }

  void _onLoginSuccess(AuthLoginSuccess event, Emitter<AuthState> emit) async {
    emit(AuthAuthenticated(user: event.user));
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await keyValueStorageService.removeKey('token');

    // Limpiar el error
    emit(const AuthNotAuthenticated(errorMessage: ''));

    // emitir el error real.
    if (event.errorMessage.isNotEmpty) {
      emit(AuthNotAuthenticated(errorMessage: event.errorMessage));
    }
  }
}
