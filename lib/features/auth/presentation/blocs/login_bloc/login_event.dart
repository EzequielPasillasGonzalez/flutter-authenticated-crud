part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class EmailChange extends LoginEvent {
  final String value;
  const EmailChange(this.value);
}

class PasswordChange extends LoginEvent {
  final String value;
  const PasswordChange(this.value);
}

class FormSubmit extends LoginEvent {
  const FormSubmit();
}
