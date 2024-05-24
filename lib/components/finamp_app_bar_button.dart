import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class FinampAppBarButton extends StatelessWidget {
  const FinampAppBarButton({
    super.key,
    this.onPressed,
    this.dismissDirection = AxisDirection.down,
  });

  final VoidCallback? onPressed;

  /// The direction in which the screen will slide when the button is pressed.
  final AxisDirection dismissDirection;

  @override
  Widget build(BuildContext context) {
    IconData getIcon() {
      switch (dismissDirection) {
        case AxisDirection.down:
          return TablerIcons.chevron_down;
        case AxisDirection.left:
          return TablerIcons.chevron_left;
        case AxisDirection.right:
          return TablerIcons.chevron_right;
        case AxisDirection.up:
          return TablerIcons.chevron_up;
        default:
          return TablerIcons.chevron_down;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: IconButton(
        onPressed: onPressed,
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: Icon(
          getIcon(),
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
