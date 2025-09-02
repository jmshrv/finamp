import 'package:finamp/menus/components/icon_button_with_semantics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class OverflowMenuButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? color;
  final String label;

  const OverflowMenuButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon = TablerIcons.dots,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButtonWithSemantics(onPressed: onPressed, label: label, icon: icon, color: color);
  }
}
