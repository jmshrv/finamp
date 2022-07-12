import 'package:flutter/material.dart';

import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';

class SortByMenuButton extends StatelessWidget {
  const SortByMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortBy>(
      icon: const Icon(Icons.sort),
      tooltip: "Sort by",
      itemBuilder: (context) => <PopupMenuEntry<SortBy>>[
        PopupMenuItem(
          value: SortBy.sortName,
          child: Text(
            SortBy.sortName.toString(),
            style: TextStyle(
              color:
                  FinampSettingsHelper.finampSettings.sortBy == SortBy.sortName
                      ? Theme.of(context).colorScheme.secondary
                      : null,
            ),
          ),
        ),
        PopupMenuItem(
          value: SortBy.albumArtist,
          child: Text(
            SortBy.albumArtist.toString(),
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy ==
                      SortBy.albumArtist
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
        ),
        PopupMenuItem(
          value: SortBy.communityRating,
          child: Text(
            SortBy.communityRating.toString(),
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy ==
                      SortBy.communityRating
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
        ),
        PopupMenuItem(
          value: SortBy.criticRating,
          child: Text(
            SortBy.criticRating.toString(),
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy ==
                      SortBy.criticRating
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
        ),
        PopupMenuItem(
          value: SortBy.dateCreated,
          child: Text(
            SortBy.dateCreated.toString(),
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy ==
                      SortBy.dateCreated
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
        ),
        PopupMenuItem(
          value: SortBy.premiereDate,
          child: Text(
            SortBy.premiereDate.toString(),
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy ==
                      SortBy.premiereDate
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
        ),
        PopupMenuItem(
          value: SortBy.random,
          child: Text(
            SortBy.random.toString(),
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy == SortBy.random
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
        ),
      ],
      onSelected: (value) => FinampSettingsHelper.setSortBy(value),
    );
  }
}
