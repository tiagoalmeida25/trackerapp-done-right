part of 'login_bloc.dart';

@immutable
class LoginEvent {}

class AuthStart extends LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});
}

class SignUpPressed extends LoginEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String username;

  SignUpPressed(
      {required this.email,
      required this.password,
      required this.confirmPassword,
      required this.username});
}

class ForgotPasswordPressed extends LoginEvent {
  final String email;

  ForgotPasswordPressed({required this.email});
}

class LogoutPressed extends LoginEvent {}

