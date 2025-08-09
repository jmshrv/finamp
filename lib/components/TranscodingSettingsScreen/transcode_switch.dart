import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/screens/search_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

class TranscodeSwitch extends ConsumerWidget {
  TranscodeSwitch({super.key});

  String getSearchableText() {
    var context = GlobalSnackbar.materialAppScaffoldKey.currentContext;
    return ([
      AppLocalizations.of(context!)!.enableTranscoding,
      AppLocalizations.of(context!)!.enableTranscodingSubtitle,
    ]).join("");
  }

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
