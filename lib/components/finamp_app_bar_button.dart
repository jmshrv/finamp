import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class FinampAppBarButton extends StatelessWidget {
  const FinampAppBarButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: IconButton(
        onPressed: onPressed,
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: Icon(
          TablerIcons.chevron_down,
          color: Theme.of(context).iconTheme.color ?? Colors.white,
          weight: 2.0,
        ),
        // Needed because otherwise the splash goes over the container
      
        // It may be like a pixel over now but I've spent way too long on this
        // button by now.
        splashRadius: Material.defaultSplashRadius - 8,
      ),
    );
  }
}
