import 'package:flutter/material.dart';
import 'package:trackerapp/api_connection/api_connection.dart';
import 'package:trackerapp/components/my_button.dart';
import 'package:trackerapp/components/my_textfield.dart';
import 'package:trackerapp/components/squared_tile.dart';
import 'package:trackerapp/constants.dart';
import 'package:trackerapp/pages/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method
  Future<void> signUserIn(
      BuildContext context, username, String password) async {
    var response =
        await ApiService.post(APIConstants.baseURL, APIConstants.loginURL, {
      'user_name': username,
      'password': password,
    });

    if (response.contains('Welcome')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Login failed. Please check your credentials.',
        toastLength: Toast.LENGTH_SHORT,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //logo
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'lib/images/background_primary.png',
                  height: 250,
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
                  const Text('Login',
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
              hintText: 'Username or Email',
              obscureText: false,
            ),

            const SizedBox(
              height: 10,
            ),

            //password
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true, // Use the state variable
            ),

            const SizedBox(
              height: 10,
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

            const SizedBox(
              height: 35,
            ),

            //sign in
            MyButton(
              onTap: () => signUserIn(
                  context, usernameController.text, passwordController.text),
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

            const SizedBox(
              height: 50,
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
                Text(
                  'Create one now!',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 35),
              ],
            )
          ],
        ),
      ),
    );
  }
}
