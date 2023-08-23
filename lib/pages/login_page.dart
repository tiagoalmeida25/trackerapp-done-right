import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:trackerapp/components/my_button.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:trackerapp/components/passwordfield.dart';
import 'package:trackerapp/components/squared_tile.dart';
import 'package:trackerapp/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  //sign user in method
  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: 'No user found for that email',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: 'Wrong password provided for that user',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }

    Navigator.pop(context);
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
                Container(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          'lib/images/background_primary.png',
                          height: 230,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text('Login',
                                style: TextStyle(
                                    color: Color.fromRGBO(37, 42, 48, 1),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                      //username
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

                      //forgot password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),

                      //sign in
                      MyButton(
                        text: 'Login',
                        onPressed: signUserIn,
                      ),

                      const SizedBox(
                        height: 25,
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

                      const SizedBox(
                        height: 25,
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
                            child: Text(
                              'Create one now!',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
