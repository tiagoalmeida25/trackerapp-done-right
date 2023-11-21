part of 'login_bloc.dart';

@immutable
class LoginEvent {}

class AuthStart extends LoginEvent {}

class Login extends LoginEvent {
  final String email;
  final String password;

  Login({required this.email, required this.password});
}

class SignUp extends LoginEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String username;

  SignUp(
      {required this.email,
      required this.password,
      required this.confirmPassword,
      required this.username});
}

class ForgotPassword extends LoginEvent {
  final String email;

  ForgotPassword({required this.email});
}

class Logout extends LoginEvent {}

