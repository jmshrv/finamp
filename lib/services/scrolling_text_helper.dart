import 'package:balanced_text/balanced_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:hive/hive.dart';

import '../models/finamp_models.dart';
import 'finamp_settings_helper.dart';

class ScrollingTextHelper extends StatelessWidget {
  final Key id;
  final String text;
  final TextStyle? style;
  final TextAlign? alignment;
  final bool useMarqueeCondition;

  const ScrollingTextHelper({
    Key? key,
    required this.id,
    required this.text,
    this.style,
    required this.alignment,
    this.useMarqueeCondition = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool oneLineMarquee =
            box.get("FinampSettings")?.oneLineMarqueeTextButton ?? false;

        return LayoutBuilder(
          builder: (context, constraints) {
            final textPainter = TextPainter(
              text: TextSpan(
                text: text,
                style: style,
              ),
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);

            final lineHeight = textPainter.preferredLineHeight;
            final textHeight = textPainter.size.height;
            final lineCount = (textHeight / lineHeight).ceil();

            if (oneLineMarquee && lineCount > 1 || lineCount > 2) {
              return Container(
                alignment: Alignment.centerLeft,
                height: lineHeight,
                width: constraints.maxWidth,
                child: Marquee(
                  key: id,
                  text: text,
                  style: style,
                  scrollAxis: Axis.horizontal,
                  blankSpace: 20.0,
                  velocity: 50.0,
                  pauseAfterRound: const Duration(seconds: 3),
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                  textDirection: TextDirection.ltr,
                ),
              );
            } else {
              return Container(
                width: constraints.maxWidth,
                child: BalancedText(
                  text,
                  style: style,
                  overflow: TextOverflow.ellipsis,
                  maxLines: oneLineMarquee ? 1 : 2,
                  textAlign: alignment,
                ),
              );
            }
          },
        );
      },
    );
  }
}
