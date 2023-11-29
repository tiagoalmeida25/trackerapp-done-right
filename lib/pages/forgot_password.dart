import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackerapp/components/login/forgotpassword_image_container.dart';
import 'package:trackerapp/components/my_button.dart';
import 'package:trackerapp/components/my_textfield.dart';

import 'dart:math' as math;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();

  static Page page() => const MaterialPage<void>(child: ForgotPasswordScreen());
  
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //text editing controllers
  final emailController = TextEditingController();

  void sendEmail(BuildContext context) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email sent'),
        duration: Duration(seconds: 2),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        duration: const Duration(seconds: 2),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  const Column(children: [
                    ForgotPasswordImageContainer(
                      align: Alignment.topRight,
                      rotation: math.pi,
                    ),
                    SizedBox(height: 20),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          Text('Reset Password',
                              style: TextStyle(
                                color: Color.fromRGBO(37, 42, 48, 1),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ))
                        ]))
                  ]),
                  Expanded(
                      child: Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      const SizedBox(width: 5),
                      MyButton(
                        text: 'Back',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      MyButton(
                        text: 'Reset Password',
                        onPressed: () => sendEmail(context),
                        color: const Color.fromRGBO(37, 42, 48, 1),
                      ),
                      const SizedBox(width: 5),
                    ])
                  ])),
                  const ForgotPasswordImageContainer(
                      align: Alignment.bottomLeft, rotation: math.pi, invert: true),
                ])))));
  }
}
