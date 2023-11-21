import 'package:flutter/material.dart';
import 'package:trackerapp/components/login/signup_image_container.dart';
import 'package:trackerapp/components/my_button.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:trackerapp/components/passwordfield.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackerapp/bloc/login_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  //text editing controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void registerUser(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(
      SignUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        username: usernameController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Register Successful!, Welcome, ${state.username}!')));
        }
      },
      builder: (context, state) {
        if (state is LoginLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                // physics: const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: IntrinsicHeight(
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                          const Column(children: [
                            SignUpImageContainer(),
                            SizedBox(height: 20),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Sign-up',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(37, 42, 48, 1),
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ))
                                    ]))
                          ]),
                          Expanded(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                //username
                                Column(
                                  children: [
                                    MyTextField(
                                      controller: usernameController,
                                      hintText: 'Username',
                                      obscureText: false,
                                    ),

                                    const SizedBox(height: 10),

                                    MyTextField(
                                        controller: emailController,
                                        hintText: 'Email',
                                        obscureText: false),

                                    const SizedBox(height: 10),

                                    //password
                                    PasswordField(
                                        controller: passwordController,
                                        hintText: 'Password'),
                                    const SizedBox(height: 10),

                                    //password
                                    PasswordField(
                                        controller: confirmPasswordController,
                                        hintText: 'Confirm Password'),
                                  ],
                                ),

                                //sign in
                                MyButton(
                                  text: 'Sign-up',
                                  onPressed: () => registerUser(context),
                                  color: const Color.fromRGBO(37, 42, 48, 1),
                                ),

                                //or continue with

                                // Padding(
                                //     padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                //     child: Row(children: [
                                //       Expanded(
                                //           child: Divider(
                                //               thickness: 0.5, color: Colors.grey[400])),
                                //       Padding(
                                //         padding:
                                //             const EdgeInsets.symmetric(horizontal: 10.0),
                                //         child: Text('Or continue with',
                                //             style: TextStyle(color: Colors.grey[700])),
                                //       ),
                                //       Expanded(
                                //         child: Divider(
                                //             thickness: 0.5, color: Colors.grey[400]),
                                //       )
                                //     ])),

                                //google + apple sign in
                                // const Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     SquareTile(imagePath: 'lib/images/google.png'),
                                //     SizedBox(width: 10),
                                //     SquareTile(imagePath: 'lib/images/apple.png'),
                                //   ],
                                // ),

                                // back to login
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/login');
                                        },
                                        child: Text(
                                          'Already have an account?',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                                context, '/login');
                                          },
                                          child: Text(' Login!',
                                              style: TextStyle(
                                                color: Colors.grey[900],
                                                fontWeight: FontWeight.bold,
                                              )))
                                    ])
                              ]))
                        ])))));
      },
    );
  }
}
