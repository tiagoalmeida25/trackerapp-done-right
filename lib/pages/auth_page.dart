import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackerapp/bloc/data_bloc.dart';
import 'package:trackerapp/bloc/login_bloc.dart';
import 'package:trackerapp/service/firestore_service.dart';

import 'home_page.dart';
import 'login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            BlocProvider.of<LoginBloc>(context).add(AuthStart());

            if (state.isLoggedIn) {
              return BlocProvider(
                create: (dataContext) =>
                    DataBloc(FirestoreService(user: state.user!)),
                child: const HomePage(),
              );
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
