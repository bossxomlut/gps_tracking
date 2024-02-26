import 'package:flutter/material.dart';

class CyclingBackground extends StatelessWidget {
  const CyclingBackground({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(),
      child: child,
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double ratio = 222 / 375;
    const double ratio2 = 296 / 375;
    const double ratio3 = 382 / 375;
    const double ratio4 = 470 / 375;

    var paint = Paint()
      ..color = const Color(0xFFF3F3F3).withOpacity(0.1)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), (size.width * ratio) / 2, paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), (size.width * ratio2) / 2, paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), (size.width * ratio3) / 2, paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), (size.width * ratio4) / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
