import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackerapp/components/my_button.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:trackerapp/components/passwordfield.dart';
import 'package:trackerapp/components/squared_tile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    if (passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: 'Passwords do not match',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return;
    }

    UserCredential userCredential;
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    try {
      QuerySnapshot usernameSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('username', isEqualTo: usernameController.text.trim())
          .get();

      if (usernameSnapshot.docs.isNotEmpty) {
        Fluttertoast.showToast(
          msg: 'Username already taken',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        return;
      }

      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text);

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user?.uid)
          .set({
        'username': usernameController.text.trim(),
      });

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: 'Email already in use',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(
          msg: 'Invalid email',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: 'Password is too weak',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: e.code,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      Navigator.pop(context);
      return;
    }

    Fluttertoast.showToast(
      msg: "Sign-up successful!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 73, 244, 54),
      textColor: Colors.white,
      fontSize: 16.0,
    );

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
                Column(
                  children: [
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
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Sign-up',
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                          const SizedBox(
                            height: 10,
                          ),

                          MyTextField(
                            controller: emailController,
                            hintText: 'Email',
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          //password
                          PasswordField(
                            controller: passwordController,
                            hintText: 'Password',
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          //password
                          PasswordField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm Password',
                          ),
                        ],
                      ),

                      //sign in
                      MyButton(
                        text: 'Sign-up',
                        onPressed: registerUser,
                        color: const Color.fromRGBO(37, 42, 48, 1),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
