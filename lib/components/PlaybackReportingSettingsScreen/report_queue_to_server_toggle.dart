import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class ReportQueueToServerToggle extends ConsumerWidget {
  const ReportQueueToServerToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.reportQueueToServer),
      subtitle: Text(AppLocalizations.of(context)!.reportQueueToServerSubtitle),
      value: ref.watch(finampSettingsProvider.reportQueueToServer) || ref.watch(finampSettingsProvider.enablePlayon),
      onChanged: ref.watch(finampSettingsProvider.enablePlayon)
          ? null // disable switch tile, since queue is always reported if play on is active
          : FinampSetters.setReportQueueToServer,
    );
  }
}
