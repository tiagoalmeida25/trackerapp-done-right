import 'package:flutter/material.dart';


class CustomBackButton extends StatelessWidget {
  final Function() onTap;
  final dynamic state;
  final dynamic dataBloc;

  const CustomBackButton(
      {Key? key,
      required this.onTap,
      required this.state,
      required this.dataBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 30,
            width: 75,
            color: const Color.fromRGBO(37, 42, 48, 1),
            child: const Center(
                child: Text('Back',
                    style: TextStyle(
                        color: Color.fromRGBO(186, 186, 186, 1),
                        fontSize: 16))),
          ),
        ),
        onTap: () => onTap());
  }
}