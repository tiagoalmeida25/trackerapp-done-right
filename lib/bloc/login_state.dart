part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class SplashScreen extends LoginState{}

class LoginLoading extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError({required this.message});
}

class LoginSuccess extends LoginState {
  final User? user;
  final String? username;

  LoginSuccess({required this.user, required this.username});
}

class EmailSent extends LoginState {}
