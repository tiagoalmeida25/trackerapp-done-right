import 'package:flutter/material.dart';
import 'package:trackerapp/api_connection/api_connection.dart';
import 'package:trackerapp/components/my_button.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:trackerapp/components/passwordfield.dart';
import 'package:trackerapp/components/squared_tile.dart';
import 'package:trackerapp/constants.dart';
import 'package:trackerapp/pages/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  //text editing controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> registerUser(
      BuildContext context, username, email, password, confirmPassword) async {

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (password != confirmPassword) {
      Fluttertoast.showToast(
        msg: 'Passwords do not match.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    var response =
        await ApiService.post(APIConstants.baseURL, APIConstants.signupURL, {
      'user_name': username,
      'email': email,
      'password': password,
    });

    if (response.contains('Successfull')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Fluttertoast.showToast(
        msg: response,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //logo
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Image.asset(
                    'lib/images/background_primary.png',
                    height: 250,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            //welcome back
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Sign-up',
                      style: TextStyle(
                          color: Color.fromRGBO(37, 42, 48, 1),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            //username
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
              obscureText: true,
              hintText: 'Password',
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        passwordVisible = !passwordVisible;
                      },
                    );
                  },
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            //password
            PasswordField(
              controller: confirmPasswordController,
              obscureText: true,
              hintText: 'Confirm Password',
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        passwordVisible = !passwordVisible;
                      },
                    );
                  },
                ),
              ),
            ),

            const SizedBox(
              height: 24,
            ),


            //sign in
            MyButton(
              text: 'Sign-up',
              onTap: () => registerUser(context, usernameController.text,
                  emailController.text, passwordController.text, confirmPasswordController.text),
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
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            //google + apple sign in
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareTile(imagePath: 'lib/images/google.png'),
                const SizedBox(
                  width: 10,
                ),
                SquareTile(imagePath: 'lib/images/apple.png'),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
