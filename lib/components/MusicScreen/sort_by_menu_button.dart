import 'package:Finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';

class SortByMenuButton extends StatelessWidget {
  const SortByMenuButton(this.tabType, {Key? key}) : super(key: key);

  final TabContentType tabType;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortBy>(
      icon: const Icon(Icons.sort),
      tooltip: AppLocalizations.of(context)!.sortBy,
      itemBuilder: (context) => [
        for (SortBy sortBy in SortBy.defaults)
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
