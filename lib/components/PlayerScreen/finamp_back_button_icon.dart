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
      painter: RPSCustomPainter(context),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  BuildContext context;
  RPSCustomPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.6250000, size.height * 0.2600000);
    path_0.lineTo(size.width * 0.3750000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.6250000, size.height * 0.7400000);

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08333333;
    paint0Stroke.color = Theme.of(context).iconTheme.color ?? Colors.white;
    paint0Stroke.strokeCap = StrokeCap.round;
    paint0Stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_0, paint0Stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
