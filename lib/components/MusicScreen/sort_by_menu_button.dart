import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';

import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';

class SortByMenuButton extends StatelessWidget {
  const SortByMenuButton(this.tabType, {super.key});

  final TabContentType tabType;

  @override
  Widget build(BuildContext context) {

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
                color:
                    FinampSettingsHelper.finampSettings.getTabSortBy(tabType) ==
                            sortBy
                        ? Theme.of(context).colorScheme.secondary
                        : null,
              ),
            ),
          )
      ],
      onSelected: (value) => FinampSettingsHelper.setSortBy(tabType, value),
    );
  }
}
