import 'package:flutter/material.dart';

class ForgotPasswordImageContainer extends StatelessWidget {
  final Alignment align;
  final double rotation;
  final bool invert;
  const ForgotPasswordImageContainer({
    Key? key,
    required this.align,
    required this.rotation,
    this.invert = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Transform(
        alignment: Alignment.center,
        transform:invert ?  Matrix4.rotationX(rotation) :  Matrix4.rotationY(rotation),
        child: Image.asset(
          'lib/images/background_primary.png',
          height: 230,
        ),
      ),
    );
  }
}
