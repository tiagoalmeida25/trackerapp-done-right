import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackerapp/bloc/login_bloc.dart';
import 'package:trackerapp/components/login/forgotpassword_image_container.dart';
import 'package:trackerapp/components/my_button.dart';
import 'package:trackerapp/components/my_textfield.dart';

import 'dart:math' as math;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  //text editing controllers
  final emailController = TextEditingController();

  void sendEmail(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(
      ForgotPassword(
        email: emailController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      }
      if (state is EmailSent) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Email sent')));
      }
    }, builder: ((context, state) {
      if (state is LoginLoading) {
        return const Center(child: CircularProgressIndicator());
      } else {
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
                            ForgotPasswordImageContainer(
                              align: Alignment.topRight,
                              rotation: math.pi,
                            ),
                            SizedBox(height: 20),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Reset Password',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(37, 42, 48, 1),
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ))
                                    ]))
                          ]),
                          Expanded(
                              child: Column(children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1),
                            MyTextField(
                                controller: emailController,
                                hintText: 'Email',
                                obscureText: false),
                            const SizedBox(height: 20),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(width: 5),
                                  MyButton(
                                    text: 'Back',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
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
                              align: Alignment.bottomLeft,
                              rotation: math.pi,
                              invert: true),
                        ])))));
      }
    }));
  }
}
