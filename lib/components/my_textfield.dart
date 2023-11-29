import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final ValueChanged<String> onChanged;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromRGBO(37, 42, 48, 1)),
            borderRadius: BorderRadius.circular(24),
          ),
          fillColor: const Color.fromRGBO(217, 237, 146, 0.25),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
