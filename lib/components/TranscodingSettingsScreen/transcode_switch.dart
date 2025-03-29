import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class TranscodeSwitch extends ConsumerWidget {
  const TranscodeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.enableTranscoding),
      subtitle: Text(AppLocalizations.of(context)!.enableTranscodingSubtitle),
      value: ref.watch(finampSettingsProvider.shouldTranscode),
      onChanged: FinampSetters.setShouldTranscode,
    );
  }
}
