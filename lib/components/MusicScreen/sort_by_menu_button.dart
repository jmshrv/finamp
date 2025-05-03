import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';

class SortByMenuButton extends ConsumerWidget {
  const SortByMenuButton({
    super.key,
    required this.tabType,
    this.sortByOverride,
    this.onOverrideUsed,
  });

  final TabContentType tabType;
  final SortBy? sortByOverride;
  final VoidCallback? onOverrideUsed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOptions = tabType == TabContentType.tracks
        ? SortBy.trackSortOptions
        : SortBy.defaults;

    return PopupMenuButton<SortBy>(
      icon: const Icon(Icons.sort),
      tooltip: AppLocalizations.of(context)!.sortBy,
      itemBuilder: (context) => [
        for (SortBy sortBy in sortOptions)
          PopupMenuItem(
            value: sortBy,
            child: Text(
              sortBy.toLocalisedString(context),
              style: TextStyle(
                color: (sortByOverride ?? 
                      ref.watch(finampSettingsProvider.select(
                        (x) => x.requireValue.getTabSortBy(tabType)
                      ))
                  ) == sortBy
                  ? Theme.of(context).colorScheme.secondary
                  : null,
              ),
            ),
          )
      ],
      onSelected: (value) {
        FinampSettingsHelper.setSortBy(tabType, value);
        if (sortByOverride != null && onOverrideUsed != null) {
          onOverrideUsed!();
        }
      },
    );
  }
}
