import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: !_passwordVisible,
        enableSuggestions: false,
        autocorrect: false,
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
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            child: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
