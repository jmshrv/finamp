import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class ContentViewTypeDropdownListTile extends ConsumerWidget {
  const ContentViewTypeDropdownListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.viewType),
      subtitle: Text(AppLocalizations.of(context)!.viewTypeSubtitle),
      trailing: DropdownButton<ContentViewType>(
        value: ref.watch(finampSettingsProvider.contentViewType),
        items: ContentViewType.values
            .map((e) => DropdownMenuItem<ContentViewType>(
                  value: e,
                  child: Text(e.toLocalisedString(context)),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            FinampSetters.setContentViewType(value);
          }
        },
      ),
    );
  }
}
