import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is AuthStart) {
        late User? userId;
        late String? username;
        bool isLoggedIn = false;

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final docs = await FirebaseFirestore.instance
              .collection('user')
              .doc(user.uid)
              .get();

          userId = user;
          username = docs.data()?['username'];
          isLoggedIn = true;
        }

        if (!isLoggedIn) {
          emit(LoginState(isLoggedIn: false));
        } else {
          emit(LoginState(user: userId, username: username, isLoggedIn: true));
        }
      }
      if (event is LoginButtonPressed) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: event.email, password: event.password);
          User? user = userCredential.user;

          if (user != null) {
            final docs = await FirebaseFirestore.instance
                .collection('user')
                .doc(user.uid)
                .get();
            final username = docs.data()?['username'];
            emit(LoginState(user: user, username: username, isLoggedIn: true));
          } else {
            Fluttertoast.showToast(msg: "Something went wrong!");
            emit(LoginState(isLoggedIn: false));
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            Fluttertoast.showToast(msg: 'Email not found');
          } else if (e.code == 'wrong-password') {
            Fluttertoast.showToast(msg: 'Wrong password');
          } else if (e.code == 'invalid-email') {
            Fluttertoast.showToast(msg: 'Invalid email');
          } else {
            Fluttertoast.showToast(msg: 'Something went wrong: ${e.code}');
          }

          emit(LoginState(isLoggedIn: false));
        }
      } else if (event is SignUpPressed) {
        if (event.password != event.confirmPassword) {
          Fluttertoast.showToast(msg: 'Passwords do not match');

          emit(LoginState(isLoggedIn: false));
        }

        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: event.email, password: event.password);

          await FirebaseFirestore.instance
              .collection('user')
              .doc(userCredential.user?.uid)
              .set({'username': event.username});

          Fluttertoast.showToast(msg: "Sign-up successful!");

          emit(LoginState(
              user: userCredential.user!,
              username: event.username,
              isLoggedIn: true));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'invalid-email') {
            Fluttertoast.showToast(msg: 'Invalid email');
          } else if (e.code == 'weak-password') {
            Fluttertoast.showToast(msg: 'Password is too weak');
          } else if (e.code == 'email-already-in-use') {
            Fluttertoast.showToast(msg: 'Email already in use');
          } else {
            Fluttertoast.showToast(msg: 'Something went wrong');
          }
          emit(LoginState(isLoggedIn: false));
        }
      } else if (event is ForgotPasswordPressed) {
        try {
          await FirebaseAuth.instance
              .sendPasswordResetEmail(email: event.email);

          Fluttertoast.showToast(msg: 'Email sent');

          emit(LoginState(isLoggedIn: false, emailSent: true));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            Fluttertoast.showToast(msg: 'No user found for that email');
          } else if (e.code == 'invalid-email') {
            Fluttertoast.showToast(msg: 'Invalid email');
          } else {
            Fluttertoast.showToast(msg: 'Something went wrong');
          }
          emit(LoginState(isLoggedIn: false, emailSent: false));
        }
      } else if (event is LogoutPressed) {
        FirebaseAuth.instance.signOut();
        emit(LoginState(isLoggedIn: false));
      }
    });
  }
}
