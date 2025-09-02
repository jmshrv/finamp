import 'package:flutter/material.dart';
import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class ShowAllButton extends StatelessWidget {
  const ShowAllButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleButton(
      onPressed: onPressed,
      icon: TablerIcons.chevron_right,
      text: "Show All*",
    );
  }
}
