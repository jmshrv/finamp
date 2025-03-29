import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ScrollingTextHelper extends StatelessWidget {
  const ScrollingTextHelper({
    super.key,
    required this.id,
    required this.text,
    this.style,
    this.alignment = TextAlign.start,
  });

  final Key id;
  final String text;
  final TextStyle? style;
  final TextAlign alignment;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        (style ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(
      height: 1.0, // Force single line height
    );

    return SizedBox(
      height: 20.0, // Fixed height for single line
      child: Marquee(
        key: id,
        text: text,
        style: effectiveStyle,
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        blankSpace: 60.0,
        velocity: 40.0,
        pauseAfterRound: const Duration(seconds: 1),
        startAfter: const Duration(seconds: 1),
      ),
    );
  }
}
