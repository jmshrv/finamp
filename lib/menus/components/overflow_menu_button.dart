import 'package:finamp/menus/components/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class OverflowMenuButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const OverflowMenuButton({super.key, required this.onPressed, required this.label, this.icon = TablerIcons.dots});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuButton(onPressed: onPressed, label: label, icon: icon);
  }
}
