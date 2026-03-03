part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
  @override
  List<Object> get props => [];
}

class AuthLoginSuccess extends AuthEvent {
  final User user;
  const AuthLoginSuccess(this.user);
  @override
  List<Object> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {
  final String errorMessage;
  const AuthLogoutRequested([this.errorMessage = '']);
  @override
  List<Object> get props => [errorMessage];
}
