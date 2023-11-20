import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:trackerapp/app_colors.dart';

class EntryContainer extends StatelessWidget {
  final Function() onTap;
  final String word;
  final int index;

  const EntryContainer({
    Key? key,
    required this.onTap,
    required this.word,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = 20.0;
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: word,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    double wordWidth = textPainter.width;
    double wordHeight = textPainter.height;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              height: wordHeight + 36,
              decoration: BoxDecoration(
                color: primary[index + 1],
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(-1, 0),
                    inset: true,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 8, left: 24, right: 8, top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: wordWidth + 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: Colors.black.withOpacity(0.3),
                child: Text(
                  word,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
