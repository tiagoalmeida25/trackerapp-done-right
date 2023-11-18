import 'package:flutter/material.dart';

class LoginImageContainer extends StatelessWidget {
  const LoginImageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              'lib/images/background_primary.png',
              height: 230,
            ),
          ),
        ],
      ),
    );
  }
}