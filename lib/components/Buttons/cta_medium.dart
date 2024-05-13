import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class CTAMedium extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onPressed;
  final double? minWidth;

  const CTAMedium(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed,
      this.minWidth});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final minWidth = this.minWidth ?? screenSize.width * 0.25;
    final paddingHorizontal = screenSize.width * 0.015;
    final paddingVertical = screenSize.height * 0.015;
    final accentColor = Theme.of(context).colorScheme.primary;

    return ElevatedButton(
      onPressed: () {
        FeedbackHelper.feedback(FeedbackType.selection);
        onPressed();
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.only(
              left: 8 + paddingHorizontal,
              right: 8,
              top: paddingVertical,
              bottom: paddingVertical),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).brightness == Brightness.dark
              ? accentColor.withOpacity(0.3)
              : accentColor,
        ),
      ),
      child: Container(
        constraints: BoxConstraints(minWidth: minWidth + paddingHorizontal),
        padding: EdgeInsets.only(
            right:
                paddingHorizontal), // this is to center the content when a minWidth is set
        alignment: Alignment.center,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: Theme.of(context).brightness == Brightness.dark
                  ? accentColor
                  : Colors.white,
              weight: 1.5,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
