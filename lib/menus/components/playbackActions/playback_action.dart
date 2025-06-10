import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaybackAction extends ConsumerWidget {
  const PlaybackAction({
    super.key,
    required this.icon,
    this.value,
    required this.onPressed,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final String? value;
  final void Function() onPressed;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      flex: 1,
      child: IconButton(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 9,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 28,
              weight: 1.0,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        onPressed: () {
          FeedbackHelper.feedback(FeedbackType.selection);
          onPressed();
        },
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.only(
            top: 10.0, left: 8.0, right: 8.0, bottom: 12.0),
      ),
    );
  }
}
