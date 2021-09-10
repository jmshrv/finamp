import 'package:flutter/material.dart';

import '../../models/JellyfinModels.dart';
import '../../services/FinampSettingsHelper.dart';

class SortByMenuButton extends StatelessWidget {
  const SortByMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortBy>(
      icon: const Icon(Icons.sort),
      tooltip: "Sort by",
      itemBuilder: (context) => <PopupMenuEntry<SortBy>>[
        PopupMenuItem(
          child: Text(
            SortBy.sortName.humanReadableName,
            style: TextStyle(
              color:
                  FinampSettingsHelper.finampSettings.sortBy == SortBy.sortName
                      ? Theme.of(context).colorScheme.secondary
                      : null,
            ),
          ),
          value: SortBy.sortName,
        ),
        PopupMenuItem(
          child: Text(
            SortBy.albumArtist.humanReadableName,
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy ==
                      SortBy.albumArtist
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
          value: SortBy.albumArtist,
        ),
        PopupMenuItem(
          child: Text(
            SortBy.communityRating.humanReadableName,
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy ==
                      SortBy.communityRating
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
          value: SortBy.communityRating,
        ),
        PopupMenuItem(
          child: Text(
            SortBy.criticRating.humanReadableName,
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy ==
                      SortBy.criticRating
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
          value: SortBy.criticRating,
        ),
        PopupMenuItem(
          child: Text(
            SortBy.dateCreated.humanReadableName,
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy ==
                      SortBy.dateCreated
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
          value: SortBy.dateCreated,
        ),
        PopupMenuItem(
          child: Text(
            SortBy.premiereDate.humanReadableName,
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy ==
                      SortBy.premiereDate
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
          value: SortBy.premiereDate,
        ),
        PopupMenuItem(
          child: Text(
            SortBy.random.humanReadableName,
            style: TextStyle(
              color: FinampSettingsHelper.finampSettings.sortBy == SortBy.random
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ),
          value: SortBy.random,
        ),
      ],
      onSelected: (value) => FinampSettingsHelper.setSortBy(value),
    );
  }
}
