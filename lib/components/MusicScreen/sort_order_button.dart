import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class SortOrderButton extends StatelessWidget {
  const SortOrderButton(this.tabType, {Key? key}) : super(key: key);

  final TabContentType tabType;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, _) {
        final finampSettings = box.get("FinampSettings");

        return IconButton(
          tooltip: AppLocalizations.of(context)!.sortOrder,
          icon: finampSettings!.getSortOrder(tabType) == SortOrder.ascending
              ? const Icon(Icons.arrow_downward)
              : const Icon(Icons.arrow_upward),
          onPressed: () {
            if (finampSettings.getSortOrder(tabType) == SortOrder.ascending) {
              FinampSettingsHelper.setSortOrder(tabType, SortOrder.descending);
            } else {
              FinampSettingsHelper.setSortOrder(tabType, SortOrder.ascending);
            }
          },
        );
      },
    );
  }
}
