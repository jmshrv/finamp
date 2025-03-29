import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class VolumeNormalizationSwitch extends ConsumerWidget {
  const VolumeNormalizationSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.volumeNormalizationSwitchTitle),
      subtitle:
          Text(AppLocalizations.of(context)!.volumeNormalizationSwitchSubtitle),
      value: ref.watch(finampSettingsProvider.volumeNormalizationActive),
      onChanged: FinampSetters.setVolumeNormalizationActive,
    );
  }
}
