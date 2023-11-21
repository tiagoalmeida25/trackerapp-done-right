part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class NoUser extends LoginState {}

class SplashScreen extends LoginState {}

class LoginLoading extends LoginState {}

class RegisterLoading extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError({required this.message});
}

class RegisterError extends LoginState {
  final String message;

  RegisterError({required this.message});
}

class LoginSuccess extends LoginState {
  final User? user;
  final String? username;

  LoginSuccess({required this.user, required this.username});
}

class EmailSent extends LoginState {}

class LogoutSuccess extends LoginState {}

class LogoutError extends LoginState {
  final String message;

  LogoutError({required this.message});
}
