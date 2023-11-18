import 'package:flutter/material.dart';
import 'dart:math' as math;


class SignUpImageContainer extends StatelessWidget {
  const SignUpImageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: Image.asset(
          'lib/images/background_primary.png',
          height: 230,
        ),
      ),
    );
  }
}