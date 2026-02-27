part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Caso en que la app se abre y revisa si hay un token guardado
final class AuthChecking extends AuthState {
  const AuthChecking();
}

// Caso en que la Sesion esta Activa, el usuario existe
final class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

// No hay sesión o la sesión expiro
final class AuthNotAuthenticated extends AuthState {
  final String errorMessage;

  const AuthNotAuthenticated({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
