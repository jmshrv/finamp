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

  get math => null;

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
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: oneLineMode ? 1 : 2,
          textAlign: alignment,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);
        final doesTextFit = !textPainter.didExceedMaxLines;
        final actualTextHeight = textPainter.height;

        final containerHeight = oneLineMode
            ? (actualTextHeight > 24.0 ? actualTextHeight : 24.0)
            : actualTextHeight + 4.0;

        if (!doesTextFit) {
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
