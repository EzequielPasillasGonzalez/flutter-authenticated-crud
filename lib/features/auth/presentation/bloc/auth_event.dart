part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class EmailChange extends AuthEvent {
  final String value;
  const EmailChange(this.value);
}

class PasswordChange extends AuthEvent {
  final String value;
  const PasswordChange(this.value);
}

class FormSubmit extends AuthEvent {
  const FormSubmit();
}
