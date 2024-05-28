import 'package:finamp/components/scrolling_text.dart';
import 'package:flutter/material.dart';

class ScrollingTextHelper extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign alignment;

  const ScrollingTextHelper({
    Key? key,
    required this.text,
    this.style,
    this.alignment = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: style,
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return Container(
          width: constraints.maxWidth,
          child: isOverflowing
              ? ScrollingText(
                  text: text,
                  style: style,
                )
              : Text(
                  text,
                  style: style,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: alignment,
                ),
        );
      },
    );
  }
}
