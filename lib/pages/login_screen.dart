import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trackerapp/components/my_button.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:trackerapp/components/passwordfield.dart';
import 'package:trackerapp/components/squared_tile.dart';
import 'package:trackerapp/components/login/login_image_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackerapp/cubit/login/login_cubit.dart';
import 'package:trackerapp/pages/forgot_password.dart';
import 'package:trackerapp/pages/signup_screen.dart';
import 'package:trackerapp/repositories/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();

  static Page page() => const MaterialPage<void>(child: LoginScreen());
}

class LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => LoginCubit(context.read<AuthRepository>()),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {}
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
                                      Text('Login',
                                          style: TextStyle(
                                              color: Color.fromRGBO(37, 42, 48, 1),
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ))
                            ],
                          ),
                          Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                Column(children: [
                                  BlocBuilder<LoginCubit, LoginState>(
                                    buildWhen: (previous, current) => previous.email != current.email,
                                    builder: (context, state) {
                                      return MyTextField(
                                        controller: emailController,
                                        hintText: 'Email',
                                        obscureText: false,
                                        onChanged: (email) {
                                          context.read<LoginCubit>().emailChanged(email);
                                        },
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 10),

                                  //password
                                  BlocBuilder<LoginCubit, LoginState>(
                                    buildWhen: (previous, current) => previous.password != current.password,
                                    builder: (context, state) {
                                      return PasswordField(
                                        controller: passwordController,
                                        hintText: 'Password',
                                        onChanged: (password) {
                                          context.read<LoginCubit>().passwordChanged(password);
                                        },
                                      );
                                    },
                                  )
                                ]),

                                //forgot password
                                GestureDetector(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text('Forgot Password?',
                                                style: TextStyle(color: Colors.grey[600]))
                                          ],
                                        )),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const ForgotPasswordScreen()));
                                    }),

                                //sign in
                                BlocBuilder<LoginCubit, LoginState>(
                                  buildWhen: (previous, current) => previous.status != current.status,
                                  builder: (context, state) {
                                    return state.status == LoginStatus.submitting
                                        ? const Center(child: CircularProgressIndicator())
                                        : MyButton(
                                            text: 'Login',
                                            onPressed: () {
                                              if (emailController.text == '') {
                                                Fluttertoast.showToast(msg: 'Please insert an email');
                                              } else if (passwordController.text == '') {
                                                Fluttertoast.showToast(msg: "Password can't be empty");
                                              } else {
                                                context.read<LoginCubit>().loginWithCredentials();
                                              }
                                            },
                                            color: const Color.fromRGBO(37, 42, 48, 1),
                                          );
                                  },
                                ),

                                const SizedBox(height: 25),

                                //or continue with

                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Divider(thickness: 0.5, color: Colors.grey[400]),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Text('Or continue with',
                                              style: TextStyle(color: Colors.grey[700])),
                                        ),
                                        Expanded(
                                          child: Divider(thickness: 0.5, color: Colors.grey[400]),
                                        )
                                      ],
                                    )),

                                const SizedBox(height: 25),

                                //google + apple sign in
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SquareTile(imagePath: 'lib/images/google.png'),
                                    SizedBox(width: 10),
                                    SquareTile(imagePath: 'lib/images/apple.png'),
                                  ],
                                ),

                                //not a member? register now
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('No account?', style: TextStyle(color: Colors.grey[700])),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => const SignupScreen()));
                                        },
                                        child: Text('Create one now!',
                                            style: TextStyle(
                                                color: Colors.grey[900], fontWeight: FontWeight.bold)))
                                  ],
                                )
                              ]))
                        ],
                      ))))),
        ));
  }
}
