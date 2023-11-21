import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackerapp/service/firebase_auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  LoginBloc() : super(LoginInitial()) {
    on<AuthStart>((event, emit) async {
      try {
        emit(SplashScreen());
        final user = _firebaseAuthService.currentUser;

        if (user != null) {
          final username = await _firebaseAuthService.getUsername(user);
          emit(LoginSuccess(user: user, username: username));
        } else {
          emit(LoginInitial());
        }
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    });
    on<Login>(((event, emit) async {
      try {
        emit(LoginLoading());
        final user = await _firebaseAuthService.login(
            event.email.trim(), event.password);
        final username = await _firebaseAuthService.getUsername(user!);

        emit(LoginSuccess(user: user, username: username));
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    }));

    on<SignUp>(((event, emit) async {
      if (event.password != event.confirmPassword) {
        emit(LoginError(message: "Passwords don't match"));
        return;
      }

      try {
        emit(LoginLoading());

        final user = await _firebaseAuthService.signUp(
            event.email.trim(), event.password, event.username);
        emit(LoginSuccess(user: user, username: event.username));
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    }));

    on<ForgotPassword>(((event, emit) {
      try {
        emit(LoginLoading());

        _firebaseAuthService.sendEmail(event.email);
        emit(EmailSent());
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    }));
  }
}
