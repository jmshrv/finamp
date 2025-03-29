import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class CTASmall extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool vertical;
  final void Function() onPressed;

  const CTASmall(
      {super.key,
      required this.text,
      required this.icon,
      this.vertical = false,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;
    return ElevatedButton(
      onPressed: () {
        FeedbackHelper.feedback(FeedbackType.selection);
        onPressed();
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
            Theme.of(context).brightness == Brightness.dark
                ? accentColor.withOpacity(0.3)
                : Color.alphaBlend(accentColor.withOpacity(0.8), Colors.white)),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: vertical ? Axis.vertical : Axis.horizontal,
        alignment: vertical ? WrapAlignment.center : WrapAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).brightness == Brightness.dark
                ? accentColor
                : Colors.white,
            weight: 1.0,
          ),
          const SizedBox(
            width: 6,
            height: 4,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
