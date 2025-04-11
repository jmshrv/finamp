import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';

class SortOrderButton extends ConsumerWidget {
  const SortOrderButton(this.tabType, {super.key});

  final TabContentType tabType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var order = ref.watch(finampSettingsProvider
        .select((x) => x.requireValue.getSortOrder(tabType)));
    return IconButton(
      tooltip: AppLocalizations.of(context)!.sortOrder,
      icon: order == SortOrder.ascending
          ? const Icon(Icons.arrow_downward)
          : const Icon(Icons.arrow_upward),
      onPressed: () {
        if (order == SortOrder.ascending) {
          FinampSettingsHelper.setSortOrder(tabType, SortOrder.descending);
        } else {
          FinampSettingsHelper.setSortOrder(tabType, SortOrder.ascending);
        }
      },
    );
  }
}
