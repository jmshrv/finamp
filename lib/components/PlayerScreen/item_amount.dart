import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/item_amount_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemAmount extends ConsumerWidget {
  const ItemAmount({required this.baseItem, this.color, super.key});

  final BaseItemDto baseItem;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(itemAmountProvider(baseItem: baseItem));

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: itemCount.hasValue
            ? AppLocalizations.of(context)!.itemCount(itemCount.value!.$2.name, itemCount.value!.$1)
            : AppLocalizations.of(context)!.itemCountCalculating,
        button: true,
      ),
      excludeSemantics: true,
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4.0,
          children: [
            if (itemCount.isLoading)
              CircularProgressIndicator(
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16, maxWidth: 16, maxHeight: 16),
                padding: const EdgeInsets.all(2.0),
                color: color ?? Theme.of(context).textTheme.bodySmall!.color ?? Colors.white,
                strokeWidth: 2.0,
              ),
            Text(
              itemCount.hasValue
                  ? AppLocalizations.of(context)!.itemCount(itemCount.value!.$2.name, itemCount.value!.$1)
                  : AppLocalizations.of(context)!.itemCountLoading(ref.watch(childItemTypeProvider(baseItem)).name),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(color: color ?? Theme.of(context).textTheme.bodySmall!.color ?? Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
