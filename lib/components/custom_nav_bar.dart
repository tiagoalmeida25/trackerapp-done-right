import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final BuildContext context;
  final Color buttonColor;
  final Function() onPressed;
  final Function() homeFunction;
  final Function() historyFunction;
  final Function() chartFunction;
  final Function() profileFunction;

  const CustomNavBar(
      {Key? key,
      required this.context,
      required this.buttonColor,
      required this.onPressed,
      required this.homeFunction,
      required this.historyFunction,
      required this.chartFunction,
      required this.profileFunction})
      : super(key: key);

  @override
  Widget build(context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: SizedBox(
            width: size.width,
            height: 90,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(size.width, 90),
                  painter: BNBCustomPainter(),
                ),
                Center(
                  heightFactor: 1.1,
                  child: FloatingActionButton(
                    backgroundColor: buttonColor,
                    elevation: 0.1,
                    onPressed: onPressed,
                    child: const Icon(
                      Icons.add,
                      color: Color.fromRGBO(37, 42, 48, 1),
                    ),
                  ),
                ),
                Container(
                    width: size.width,
                    height: 90,
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: homeFunction,
                            icon: const Icon(Icons.home_filled,
                                color: Color.fromRGBO(186, 186, 186, 1),
                                size: 40)),
                        IconButton(
                            onPressed: historyFunction,
                            icon: const Icon(Icons.history,
                                color: Color.fromRGBO(186, 186, 186, 1),
                                size: 40)),
                        Container(width: size.width * 0.20),
                        IconButton(
                            onPressed: chartFunction,
                            icon: const Icon(Icons.bar_chart,
                                color: Color.fromRGBO(186, 186, 186, 1),
                                size: 40)),
                        IconButton(
                            onPressed: profileFunction,
                            icon: const Icon(Icons.person,
                                color: Color.fromRGBO(186, 186, 186, 1),
                                size: 40))
                      ],
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromRGBO(37, 42, 48, 1)
      ..style = PaintingStyle.fill;

    Path path = Path()..moveTo(42, 16);

    path.lineTo(size.width * 0.40, 16);
    path.arcToPoint(Offset(size.width * 0.60, 16),
        radius: const Radius.circular(45.0), clockwise: true);
    path.lineTo(size.width - 42, 16);
    path.quadraticBezierTo(size.width - 16, 16, size.width - 16, 42);
    path.lineTo(size.width - 16, size.height - 42);
    path.quadraticBezierTo(
        size.width - 16, size.height - 16, size.width - 42, size.height - 16);
    path.lineTo(42, size.height - 16);
    path.quadraticBezierTo(16, size.height - 16, 16, size.height - 42);
    path.lineTo(16, 42);
    path.quadraticBezierTo(16, 16, 42, 16);
    path.close();
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
