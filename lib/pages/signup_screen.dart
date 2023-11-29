import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trackerapp/components/login/signup_image_container.dart';
import 'package:trackerapp/components/my_button.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:trackerapp/components/passwordfield.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackerapp/cubit/signup/signup_cubit.dart';
import 'package:trackerapp/repositories/auth_repository.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  //text editing controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void registerUser(BuildContext context) {
    if (passwordController.text == '') {
      Fluttertoast.showToast(msg: "Password can't be empty");
    } else if (confirmPasswordController.text != passwordController.text) {
      Fluttertoast.showToast(msg: "Passwords do not match");
    } else {
      context.read<SignupCubit>().signupWithCredentials();
    }
  }

  Widget signupForm() {
    return Column(
      children: [
        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (previous, current) => previous.username != current.username,
          builder: (context, state) {
            return MyTextField(
              controller: usernameController,
              hintText: 'Username',
              obscureText: false,
              onChanged: (username) {
                context.read<SignupCubit>().usernameChanged(username);
              },
            );
          },
        ),

        const SizedBox(height: 10),

        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (previous, current) => previous.email != current.email,
          builder: (context, state) {
            return MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
              onChanged: (email) {
                context.read<SignupCubit>().emailChanged(email);
              },
            );
          },
        ),

        const SizedBox(height: 10),

        //password
        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (previous, current) => previous.password != current.password,
          builder: (context, state) {
            return PasswordField(
              controller: passwordController,
              hintText: 'Password',
              onChanged: (email) {
                context.read<SignupCubit>().passwordChanged(email);
              },
            );
          },
        ),
        const SizedBox(height: 10),

        //password
        PasswordField(
          controller: confirmPasswordController,
          hintText: 'Confirm Password',
          onChanged: (_) {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SignupCubit(context.read<AuthRepository>()),
        child: BlocListener<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {}
          },
          child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                  // physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      child: IntrinsicHeight(
                          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                        const Column(children: [
                          SignUpImageContainer(),
                          SizedBox(height: 20),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Text('Sign-up',
                                    style: TextStyle(
                                      color: Color.fromRGBO(37, 42, 48, 1),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ]))
                        ]),
                        Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              signupForm(),

                              //sign in
                              BlocBuilder<SignupCubit, SignupState>(
                                buildWhen: (previous, current) => previous.status != current.status,
                                builder: (context, state) {
                                  return state.status == SignupStatus.submitting
                                      ? const Center(child: CircularProgressIndicator())
                                      : MyButton(
                                          text: 'Sign Up',
                                          onPressed: () => registerUser(context),
                                          color: const Color.fromRGBO(37, 42, 48, 1),
                                        );
                                },
                              ),

                              // back to login
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, '/login');
                                  },
                                  child: Text(
                                    'Already have an account?',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(context, '/login');
                                    },
                                    child: Text(' Login!',
                                        style: TextStyle(
                                          color: Colors.grey[900],
                                          fontWeight: FontWeight.bold,
                                        )))
                              ])
                            ]))
                      ]))))),
        ));
  }
}
