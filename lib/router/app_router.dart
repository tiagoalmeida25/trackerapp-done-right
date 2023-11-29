import 'package:flutter/material.dart';
import 'package:trackerapp/bloc/app/app_bloc.dart';
import 'package:trackerapp/pages/home_screen.dart';
import 'package:trackerapp/pages/login_screen.dart';
// import 'package:trackerapp/pages/auth_page.dart';
// import 'package:trackerapp/pages/forgot_password.dart';
// import 'package:trackerapp/pages/signup_screen.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomeScreen.page()];
    case AppStatus.unauthenticated:
      return [LoginScreen.page()];
  }
}

// class AppRouter {
//   Route? onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/auth':
//         return MaterialPageRoute(builder: (_) => const AuthPage());
//       case '/login':
//         return MaterialPageRoute(builder: (_) => const LoginScreen());
//       case '/signup':
//         return MaterialPageRoute(builder: (_) => const SignupScreen());
//       case '/forgotpassword':
//         return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
//       case '/home':
//         return MaterialPageRoute(builder: (_) => const HomeScreen(username: ''));
//       default:
//         return null;
//     }
//   }
// }
