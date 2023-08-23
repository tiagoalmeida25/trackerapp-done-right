import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackerapp/api_connection/api_connection.dart';
import 'package:trackerapp/components/my_button.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:trackerapp/components/passwordfield.dart';
import 'package:trackerapp/components/squared_tile.dart';
import 'package:trackerapp/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;

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

  void registerUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text);
      } else {
        Fluttertoast.showToast(
          msg: 'Passwords do not match',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if(e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: 'Email already in use',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      else if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: 'Password is too weak',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Image.asset(
                          'lib/images/background_primary.png',
                          height: 230,
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //welcome back
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text('Sign-up',
                                style: TextStyle(
                                    color: Color.fromRGBO(37, 42, 48, 1),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                      //username
                      MyTextField(
                        controller: usernameController,
                        hintText: 'Username',
                        obscureText: false,
                      ),

                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),

                      //password
                      PasswordField(
                        controller: passwordController,
                        hintText: 'Password',
                      ),

                      //password
                      PasswordField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                      ),

                      //sign in
                      MyButton(
                        text: 'Sign-up',
                        onPressed: registerUser,
                      ),

                      //or continue with

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                  thickness: 0.5, color: Colors.grey[400]),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text('Or continue with',
                                  style: TextStyle(color: Colors.grey[700])),
                            ),
                            Expanded(
                              child: Divider(
                                  thickness: 0.5, color: Colors.grey[400]),
                            )
                          ],
                        ),
                      ),

                      //google + apple sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SquareTile(imagePath: 'lib/images/google.png'),
                          SizedBox(
                            width: 10,
                          ),
                          SquareTile(imagePath: 'lib/images/apple.png'),
                        ],
                      ),

                      // back to login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            child: Text(
                              ' Login!',
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
