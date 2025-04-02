import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final _borderRadius = BorderRadius.circular(4);

class ItemAmountChip extends StatelessWidget {
  const ItemAmountChip({
    this.baseItem,
    this.backgroundColor,
    this.color,
    super.key,
  });

  final BaseItemDto? baseItem;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: "Item count: ${baseItem?.childCount}",
        button: true,
      ),
      excludeSemantics: true,
      container: true,
      child: Material(
        color: backgroundColor ?? Colors.white.withOpacity(0.1),
        borderRadius: _borderRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Text(
            AppLocalizations.of(context)!
                .itemCount("track", baseItem?.childCount ?? 0),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              color: color ??
                  Theme.of(context).textTheme.bodySmall!.color ??
                  Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
