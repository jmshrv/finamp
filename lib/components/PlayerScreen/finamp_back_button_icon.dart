import 'package:flutter/material.dart';

class FinampBackButtonIcon extends StatelessWidget {
  const FinampBackButtonIcon({
    Key? key,
    this.size = 32,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: RPSCustomPainter(),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.6250000, size.height * 0.2600000);
    path_0.lineTo(size.width * 0.3750000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.6250000, size.height * 0.7400000);

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08333333;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    paint_0_stroke.strokeCap = StrokeCap.round;
    paint_0_stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_0, paint_0_stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
