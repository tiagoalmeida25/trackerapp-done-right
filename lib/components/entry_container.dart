import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class EntryContainer extends StatelessWidget {
  final Function() onTap;
  final String word;
  final int index;
  final DateTime? date;
  final MaterialColor theme;

  const EntryContainer({
    Key? key,
    required this.theme,
    required this.onTap,
    required this.word,
    required this.index,
    this.date,
  }) : super(key: key);

  String getMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      default:
        return 'Dec';
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = 20.0;
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: word, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    double wordWidth = textPainter.width;
    double wordHeight = textPainter.height;

    String dateStr = '';
    if (date != null) {
      int minute = date!.minute;
      String minStr = '';
      if (minute < 10) {
        minStr = '0$minute';
      } else {
        minStr = minute.toString();
      }

      String year = date!.year.toString();
      year = year.substring(2, 4);

      dateStr = '${date!.day} ${getMonth(date!.month)} $year ${date!.hour}:$minStr';
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              height: wordHeight + 36,
              decoration: BoxDecoration(
                color: theme[index + 1],
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
            padding: const EdgeInsets.only(bottom: 8, left: 24, right: 8, top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: wordWidth + 24,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: Colors.black.withOpacity(0.3),
                child: Text(
                  word,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ),
          if (date != null)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 24, right: 14, top: 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: Colors.black.withOpacity(0.3),
                    child: Text(
                      dateStr,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
