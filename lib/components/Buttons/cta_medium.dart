import 'package:finamp/color_schemes.g.dart';
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
      this.minWidth = 80.0});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Vibrate.feedback(FeedbackType.selection);
        onPressed();
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.only(left: 18, right: 8, top: 14, bottom: 14),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).brightness == Brightness.dark
              ? jellyfinBlueColor.withOpacity(0.3)
              : jellyfinBlueColor,
        ),
      ),
      child: Container(
        constraints: BoxConstraints(minWidth: (minWidth ?? 0.0) + 10),
        padding: const EdgeInsets.only(
            right: 10), // this is to center the content when a minWidth is set
        alignment: Alignment.center,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: Theme.of(context).brightness == Brightness.dark
                  ? jellyfinBlueColor
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
