import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import 'finamp_settings_helper.dart';

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
    final oneLineMode =
        FinampSettingsHelper.finampSettings.oneLineMarqueeTextButton;

    final effectiveStyle =
        (style ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(
      height: 1.1,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: text,
          style: effectiveStyle,
        );

        // First check if text fits in one line
        final singleLinePainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: 1,
          textAlign: alignment,
        )..layout(maxWidth: constraints.maxWidth);

        // Then check if it fits in two lines
        final twoLinePainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: 2,
          textAlign: alignment,
        )..layout(maxWidth: constraints.maxWidth);

        final needsMoreThanOneLine = singleLinePainter.didExceedMaxLines;
        final needsMoreThanTwoLines = twoLinePainter.didExceedMaxLines;

        // Use marquee if:
        // 1. oneLineMode is ON, and text needs more than one line
        // 2. oneLineMode is OFF, and text needs more than two lines
        final useMarquee =
            oneLineMode ? needsMoreThanOneLine : needsMoreThanTwoLines;

        // Dynamic height based on actual text height plus minimal padding
        final containerHeight = useMarquee
            ? (oneLineMode ? 24.0 : 36.0) // Keep existing heights for marquee
            : twoLinePainter.height +
                4.0; // Only change: dynamic height for normal text

        if (useMarquee) {
          return SizedBox(
            width: constraints.maxWidth,
            height: containerHeight,
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

        return SizedBox(
          width: constraints.maxWidth,
          height: containerHeight,
          child: Center(
            child: Text(
              text,
              style: effectiveStyle,
              textAlign: alignment,
              maxLines: oneLineMode ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
