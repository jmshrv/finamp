import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
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

    final itemCount = switch (BaseItemDtoType.fromItem(baseItem!)) {
      BaseItemDtoType.album => baseItem?.childCount ?? 0,
      BaseItemDtoType.artist => baseItem?.albumCount ??
          0, //FIXME this doesn't necessarily reflect the actual number of albums, for that a separate API request would be needed. But that should be handled by a provider down the road (or, even better, fixed server-side)
      BaseItemDtoType.genre => baseItem?.albumCount ??
          0, //FIXME this is not requested by default, as it takes a lot of time to load
      BaseItemDtoType.playlist => baseItem?.childCount ?? 0,
      _ => baseItem?.childCount ?? 0,
    };

    final childItemType = switch (BaseItemDtoType.fromItem(baseItem!)) {
      BaseItemDtoType.album => BaseItemDtoType.track,
      BaseItemDtoType.artist => BaseItemDtoType.album,
      BaseItemDtoType.genre => BaseItemDtoType.album,
      BaseItemDtoType.playlist => BaseItemDtoType.track,
      _ => BaseItemDtoType.unknown,
    };
    
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: "Item count: ${itemCount}",
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
                .itemCount(childItemType.name, baseItem?.childCount ?? 0),
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
