part of 'login_bloc.dart';

@immutable
class LoginState {
  final User? user ;
  final String? username;
  final bool isLoggedIn;
  final bool? emailSent;

  LoginState(
      {this.user,
      this.username,
      required this.isLoggedIn,
      this.emailSent});
}

class LoginInitial extends LoginState {
  
  LoginInitial() : super(isLoggedIn: false);
}

