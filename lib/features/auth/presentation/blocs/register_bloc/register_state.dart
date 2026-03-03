part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final bool isPosting;
  final bool isFormPosting;
  final bool isValidForm;
  final Name name;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;

  const RegisterState({
    this.isPosting = false,
    this.isFormPosting = false,
    this.isValidForm = false,
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
  });

  @override
  List<Object> get props => [
    name,
    email,
    password,
    confirmPassword,
    isPosting,
    isFormPosting,
    isValidForm,
  ];

  RegisterState copyWith({
    Name? name,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    bool? isPosting,
    bool? isFormPosting,
    bool? isValidForm,
  }) => RegisterState(
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    confirmPassword: confirmPassword ?? this.confirmPassword,
    isFormPosting: isFormPosting ?? this.isFormPosting,
    isPosting: isPosting ?? this.isPosting,
    isValidForm: isValidForm ?? this.isValidForm,
  );
}
