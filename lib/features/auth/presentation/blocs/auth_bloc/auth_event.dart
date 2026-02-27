part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginSuccess extends AuthEvent {
  final User user;
  const AuthLoginSuccess(this.user);
}

class AuthLogoutRequested extends AuthEvent {
  final String errorMessage;
  const AuthLogoutRequested({this.errorMessage = ''});
}
