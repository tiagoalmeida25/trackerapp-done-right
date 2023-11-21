import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackerapp/bloc/data_bloc.dart';
import 'package:trackerapp/bloc/login_bloc.dart';
import 'package:trackerapp/service/firestore_service.dart';

import 'home_page.dart';
import 'login_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late LoginBloc _loginBloc;
  
  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc.add(AuthStart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginSuccess) {
            return BlocProvider(
              create: (dataContext) => DataBloc(FirestoreService(user: state.user!)),
              child: HomePage(username: state.username!),
            );
          } else if (state is SplashScreen) {
            // return const Center(child: CircularProgressIndicator());
            return const Center(child: AnimatedIcon(icon: AnimatedIcons.ellipsis_search, progress: AlwaysStoppedAnimation(0.5)));
          } else if (state is NoUser) {
            return const LoginPage();
          }
          return Container(
            color: Colors.transparent,
            child: const Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
