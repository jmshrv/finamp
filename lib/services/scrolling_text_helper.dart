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
              maxLines: useMarqueeCondition ? 2 : 1,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);

            final isOverflowing = textPainter.didExceedMaxLines;

            if (oneLineMarquee || isOverflowing) {
              return Container(
                alignment: Alignment.centerLeft,
                height:
                    (style?.fontSize ?? 16.0) * (useMarqueeCondition ? 2 : 1),
                width: constraints.maxWidth,
                child: Marquee(
                  key: id,
                  text: text,
                  style: style,
                  scrollAxis: Axis.horizontal,
                  blankSpace: 20.0,
                  velocity: 50.0,
                  pauseAfterRound: Duration(seconds: 1),
                  accelerationDuration: Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                  textDirection: TextDirection.ltr,
                ),
              );
            } else {
              return Container(
                width: constraints.maxWidth,
                child: Text(
                  text,
                  style: style,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
