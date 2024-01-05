import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/TranscodingSettingsScreen/bitrate_selector.dart';
import '../components/TranscodingSettingsScreen/transcode_switch.dart';

class TranscodingSettingsScreen extends StatelessWidget {
  const TranscodingSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/transcoding";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transcoding),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            const TranscodeSwitch(),
            const BitrateSelector(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.jellyfinUsesAACForTranscoding,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
