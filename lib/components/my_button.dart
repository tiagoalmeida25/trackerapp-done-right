import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color color;

  const MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: color != Colors.white ? Colors.transparent : Colors.black,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color != Colors.white ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
