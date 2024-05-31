import 'package:finamp/components/scrolling_text.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/finamp_models.dart';
import 'finamp_settings_helper.dart';

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
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool oneLineMarquee = box.get("FinampSettings")?.oneLineMarqueeTextButton ?? false;
        int maxLines = oneLineMarquee ? 1 : 2;

        return LayoutBuilder(
          builder: (context, constraints) {
            final textPainter = TextPainter(
              text: TextSpan(
                text: text,
                style: style,
              ),
              maxLines: maxLines,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);

            final isOverflowing = textPainter.didExceedMaxLines;

            return Container(
              width: constraints.maxWidth,
              child: isOverflowing
                  ? ScrollingText(
                text: text,
                style: style,
                maxLines: maxLines,
              )
                  : Text(
                text,
                style: style,
                overflow: TextOverflow.ellipsis,
                maxLines: maxLines,
                textAlign: alignment,
              ),
            );
          },
        );
      },
    );
  }
}
