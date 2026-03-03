part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterNameChange extends RegisterEvent {
  final String value;

  const RegisterNameChange(this.value);
}

class RegisterPasswordChange extends RegisterEvent {
  final String value;

  const RegisterPasswordChange(this.value);
}

class RegisterConfirmPasswordChange extends RegisterEvent {
  final String value;

  const RegisterConfirmPasswordChange(this.value);
}

class RegisterEmailChange extends RegisterEvent {
  final String value;

  const RegisterEmailChange(this.value);
}

class RegisterFormSubmit extends RegisterEvent {
  const RegisterFormSubmit();
}
