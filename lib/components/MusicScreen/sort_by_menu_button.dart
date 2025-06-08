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
    this.forPlaylistTracks = false,
  });

  final TabContentType tabType;
  final SortBy? sortByOverride;
  final void Function(SortBy newSortBy)? onOverrideChanged;
  final bool forPlaylistTracks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
    final rawSortOptions = SortBy.defaultsFor(
        type: tabType, includeDefaultOrder: forPlaylistTracks);
    final sortOptions = isOffline
      ? [
          ...rawSortOptions.where((s) => s != SortBy.playCount && s != SortBy.datePlayed),
          ...rawSortOptions.where((s) => s == SortBy.playCount || s == SortBy.datePlayed),
        ]
      : rawSortOptions;
    var selectedSortBy = (sortByOverride ?? (forPlaylistTracks
          ? ref.watch(finampSettingsProvider.playlistTracksSortBy)
          : ref.watch(finampSettingsProvider.tabSortBy(tabType))));
    // PlayCount and Last Played are not representative in Offline Mode
    // so we disable it and overwrite it with the Sort Name if it was selected
    if (isOffline && (selectedSortBy == SortBy.playCount || selectedSortBy == SortBy.datePlayed)) {
      selectedSortBy =
          forPlaylistTracks ? SortBy.defaultOrder : SortBy.sortName;
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        sortBy.getIcon(),
                        size: 18,
                        color: ((selectedSortBy == sortBy)
                            ? Theme.of(context).colorScheme.secondary
                            : null),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        sortBy.toLocalisedString(context),
                        style: TextStyle(
                          color: ((selectedSortBy == sortBy)
                            ? Theme.of(context).colorScheme.secondary
                            : null
                          ),
                        ),
                    ),
                  ),
                ]
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
          } else if (forPlaylistTracks) {
            FinampSetters.setPlaylistTracksSortBy(value);
          } else {
            FinampSetters.setTabSortBy(tabType, value);
          }
        }
      }
    );
  }
}
