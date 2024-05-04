import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class CTALarge extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onPressed;

  const CTALarge(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FeedbackHelper.feedback(FeedbackType.selection);
        onPressed();
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).brightness == Brightness.dark
              ? jellyfinBlueColor.withOpacity(0.3)
              : jellyfinBlueColor,
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: Theme.of(context).brightness == Brightness.dark
                ? jellyfinBlueColor
                : Colors.white,
            weight: 1.5,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
