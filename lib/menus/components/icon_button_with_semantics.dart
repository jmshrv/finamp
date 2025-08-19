import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconButtonWithSemantics extends ConsumerWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const IconButtonWithSemantics({super.key, required this.onPressed, required this.label, required this.icon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: label,
      excludeSemantics: true, // replace child semantics with custom semantics
      container: true,
      child: IconTheme(
        data: IconThemeData(color: IconTheme.of(context).color, size: 24),
        child: IconButton(
          icon: Icon(icon),
          visualDensity: VisualDensity.compact,
          onPressed: () {
            onPressed();
            FeedbackHelper.feedback(FeedbackType.selection);
          },
        ),
      ),
    );
  }
}
