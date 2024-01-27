import 'package:flutter/material.dart';

class RulerWidget extends StatelessWidget {
  const RulerWidget({super.key, required this.max});

  final int max;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomPaint(
        painter: RulerPainter(max),
        child: SizedBox(
          height: 20,
          width: double.maxFinite,
        ),
      ),
    );
  }
}

class RulerPainter extends CustomPainter {
  final int max;

  RulerPainter(this.max);
  @override
  void paint(Canvas canvas, Size size) {
    int step = 10;
    double totalStep = max / step;

    double spaceStep = size.width / max;

    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i <= max; i++) {
      Offset startingPoint = Offset(i * spaceStep, 0);
      Offset endingPoint = Offset(
        i * spaceStep,
        i % step == 0 ? 7 : 3,
      );

      canvas.drawLine(startingPoint, endingPoint, paint);
      if (i % step == 0) {
        final textSpan = TextSpan(
          text: printDuration(Duration(seconds: i)),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        textPainter.paint(
          canvas,
          Offset(
            i * spaceStep - (textPainter.width / 2),
            14,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

String printDuration(Duration duration) {
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
