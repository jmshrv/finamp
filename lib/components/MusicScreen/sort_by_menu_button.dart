import 'package:finamp/components/global_snackbar.dart';
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
    this.onOverrideChanged,
  });

  final TabContentType tabType;
  final SortBy? sortByOverride;
  final void Function(SortBy newSortBy)? onOverrideChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
    final sortOptions = SortBy.defaultsFor(tabType);
    var selectedSortBy = (sortByOverride ?? ref.watch(finampSettingsProvider.tabSortBy(tabType)));
    // PlayCount and Last Played are not representative in Offline Mode
    // so we disable it and overwrite it with the Sort Name if it was selected
    if (isOffline && (selectedSortBy == SortBy.playCount || selectedSortBy == SortBy.datePlayed)) {
      selectedSortBy = SortBy.sortName;
    }
    return PopupMenuButton<SortBy>(
      icon: const Icon(Icons.sort),
      tooltip: AppLocalizations.of(context)!.sortBy,
      itemBuilder: (context) => [
        for (SortBy sortBy in sortOptions)
          PopupMenuItem(
            value: sortBy,
            child: Opacity(
              opacity: (isOffline && 
              ((sortBy == SortBy.playCount || sortBy == SortBy.datePlayed)))
                ? 0.3 : 1,
              child: Text(
              sortBy.toLocalisedString(context),
              style: TextStyle(
                color: ((selectedSortBy == sortBy)
                  ? Theme.of(context).colorScheme.secondary
                  : null),
              ),
            ),
          ),
        )
      ],
      onSelected: (value) {
        if (isOffline && ((value == SortBy.playCount || value == SortBy.datePlayed))) {
          GlobalSnackbar.message((context) =>
              AppLocalizations.of(context)!
                      .notAvailableInOfflineMode);
        } else {
          if (sortByOverride != null && onOverrideChanged != null) {
            onOverrideChanged!(value);
          } else {
            FinampSetters.setTabSortBy(tabType, value);
          }
        }
      }
    );
  }
}
