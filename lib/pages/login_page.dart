import 'package:flutter/material.dart';

import 'package:trackerapp/components/my_button.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:trackerapp/components/passwordfield.dart';
import 'package:trackerapp/components/squared_tile.dart';
import 'package:trackerapp/components/login/login_image_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackerapp/bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
    BlocProvider.of<LoginBloc>(context).add(
      Login(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      } else if (state is LoginSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Login Successful!, Welcome back, ${state.username}!')));
      }
    }, builder: (context, state) {
      if (state is LoginLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      else if(state is SplashScreen){
        return const Center(child: CircularProgressIndicator());
        // return const Center(child: AnimatedIcon(icon: AnimatedIcons.ellipsis_search, ));
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
                        const Column(
                          children: [
                            LoginImageContainer(),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Color.fromRGBO(37, 42, 48, 1),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Column(
                                children: [
                                  MyTextField(
                                    controller: emailController,
                                    hintText: 'Email',
                                    obscureText: false,
                                  ),

                                  const SizedBox(height: 10),

                                  //password
                                  PasswordField(
                                    controller: passwordController,
                                    hintText: 'Password',
                                  ),
                                ],
                              ),

                              //forgot password
                              GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/forgotpassword');
                                  }),

                              //sign in
                              MyButton(
                                text: 'Login',
                                onPressed: () => signUserIn(context),
                                color: const Color.fromRGBO(37, 42, 48, 1),
                              ),

                              const SizedBox(height: 25),

                              //or continue with

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                          thickness: 0.5,
                                          color: Colors.grey[400]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text('Or continue with',
                                          style: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                    Expanded(
                                      child: Divider(
                                          thickness: 0.5,
                                          color: Colors.grey[400]),
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(height: 25),

                              //google + apple sign in
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SquareTile(
                                      imagePath: 'lib/images/google.png'),
                                  SizedBox(width: 10),
                                  SquareTile(imagePath: 'lib/images/apple.png'),
                                ],
                              ),

                              //not a member? register now
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No account?',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/signup');
                                        },
                                        child: Text('Create one now!',
                                            style: TextStyle(
                                              color: Colors.grey[900],
                                              fontWeight: FontWeight.bold,
                                            )))
                                  ])
                            ]))
                      ])))));
    });
  }
}
