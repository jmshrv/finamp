import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class OverflowMenuButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const OverflowMenuButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon = TablerIcons.menu_2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: label,
      excludeSemantics: true, // replace child semantics with custom semantics
      container: true,
      child: IconTheme(
        data: IconThemeData(
          color: IconTheme.of(context).color,
          size: 24,
        ),
        child: IconButton(
          icon: Icon(
            icon,
          ),
          visualDensity: VisualDensity.compact,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
