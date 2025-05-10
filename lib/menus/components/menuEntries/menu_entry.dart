import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuEntry extends ConsumerWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MenuEntry({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var iconColor = Theme.of(context).colorScheme.primary;

    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}
