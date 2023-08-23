import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String user;

  const HomePage({super.key, required this.user});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Text('Logged In as $user'),
      ),
    );
  }
}