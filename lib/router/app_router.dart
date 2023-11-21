import 'package:flutter/material.dart';
import 'package:trackerapp/pages/auth_page.dart';
import 'package:trackerapp/pages/forgot_password.dart';
import 'package:trackerapp/pages/home_page.dart';
import 'package:trackerapp/pages/login_page.dart';
import 'package:trackerapp/pages/signup_page.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case '/auth':
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case '/forgotpassword':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage(username: ''));
      default:
        return null;
    }
  }
}