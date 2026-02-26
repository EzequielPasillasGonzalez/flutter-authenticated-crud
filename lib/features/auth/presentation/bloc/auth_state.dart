part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final bool isPosting;
  final bool isFormPosting;
  final bool isValidForm;
  final Email email;
  final Password password;

  const AuthState({
    this.isPosting = false,
    this.isFormPosting = false,
    this.isValidForm = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  @override
  List<Object?> get props => [
    isPosting,
    isFormPosting,
    isValidForm,
    email,
    password,
  ];

  AuthState copyWith({
    bool? isPosting,
    bool? isFormPosting,
    bool? isValidForm,
    Email? email,
    Password? password,
  }) => AuthState(
    email: email ?? this.email,
    password: password ?? this.password,
    isFormPosting: isFormPosting ?? this.isFormPosting,
    isPosting: isPosting ?? this.isPosting,
    isValidForm: isValidForm ?? this.isValidForm,
  );

  @override
  String toString() {
    return ''' 
  LoginFormState:
    isPosting: $isPosting
    isFormPosting: $isFormPosting
    isValidForm: $isValidForm
    email: $email
    password: $password
    ''';
  }
}
