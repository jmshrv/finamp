import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';

class CTALarge extends StatelessWidget {
  final String text;
  final IconData icon;
  final double? minWidth;
  final bool vertical;
  final void Function() onPressed;

  const CTALarge({
    super.key,
    required this.text,
    required this.icon,
    this.minWidth,
    this.vertical = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth ?? 0),
      child: FilledButton(
        onPressed: () {
          FeedbackHelper.feedback(FeedbackType.selection);
          onPressed();
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            Theme.of(context).brightness == Brightness.dark
                ? accentColor.withOpacity(0.15)
                : Color.alphaBlend(accentColor.withOpacity(0.2), Colors.white),
          ),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: vertical ? Axis.vertical : Axis.horizontal,
          alignment: vertical ? WrapAlignment.center : WrapAlignment.start,
          children: [
            Icon(icon, size: 24, color: accentColor, weight: 1.0),
            const SizedBox(width: 16, height: 8),
            Text(
              text,
              style: TextStyle(color: accentColor, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
