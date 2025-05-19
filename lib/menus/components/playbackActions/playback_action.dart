import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaybackAction extends ConsumerWidget {
  const PlaybackAction({
    super.key,
    required this.icon,
    this.value,
    required this.onPressed,
    required this.tooltip,
    required this.iconColor,
  });

  final IconData icon;
  final String? value;
  final void Function(WidgetRef ref) onPressed;
  final String tooltip;
  final Color iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      flex: 1,
      child: IconButton(
        icon: Column(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 35,
              weight: 1.0,
            ),
            const SizedBox(height: 9),
            SizedBox(
              height: 2 * 12 * 1.4 + 6,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  tooltip,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
        onPressed: () {
          FeedbackHelper.feedback(FeedbackType.selection);
          onPressed(ref);
        },
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.only(
            top: 10.0, left: 8.0, right: 8.0, bottom: 12.0),
        tooltip: tooltip,
      ),
    );
  }
}
