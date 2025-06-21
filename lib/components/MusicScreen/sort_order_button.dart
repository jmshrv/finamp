import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';

class SortOrderButton extends ConsumerWidget {
  const SortOrderButton({
    super.key,
    required this.tabType,
    this.sortOrderOverride,
    this.onOverrideChanged,
    this.forPlaylistTracks = false,
  });

  final TabContentType tabType;
  final SortOrder? sortOrderOverride;
  final void Function(SortOrder newOrder)? onOverrideChanged;
  final bool forPlaylistTracks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var order =
        sortOrderOverride ??
        (forPlaylistTracks
            ? ref.watch(finampSettingsProvider.playlistTracksSortOrder)
            : ref.watch(finampSettingsProvider.tabSortOrder(tabType)));
    return IconButton(
      tooltip: AppLocalizations.of(context)!.sortOrder,
      icon: order == SortOrder.ascending ? const Icon(Icons.arrow_downward) : const Icon(Icons.arrow_upward),
      onPressed: () {
        final newOrder = order == SortOrder.ascending ? SortOrder.descending : SortOrder.ascending;
        if (sortOrderOverride != null && onOverrideChanged != null) {
          onOverrideChanged!(newOrder);
        } else if (forPlaylistTracks) {
          FinampSetters.setPlaylistTracksSortOrder(newOrder);
        } else {
          FinampSetters.setTabSortOrder(tabType, newOrder);
        }
      },
    );
  }
}
