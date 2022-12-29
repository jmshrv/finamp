import 'package:flutter/material.dart';

import 'PlayerScreen/finamp_back_button_icon.dart';

class FinampAppBarButton extends StatelessWidget {
  const FinampAppBarButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: kMinInteractiveDimension - 12,
        height: kMinInteractiveDimension - 12,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onPressed,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const FinampBackButtonIcon(),
        ),
      ),
    );
  }
}
