import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

class ReplayGainIOSBaseGainEditor extends StatefulWidget {
  const ReplayGainIOSBaseGainEditor({Key? key}) : super(key: key);

  @override
  State<ReplayGainIOSBaseGainEditor> createState() =>
      _ReplayGainIOSBaseGainEditorState();
}

class _ReplayGainIOSBaseGainEditorState
    extends State<ReplayGainIOSBaseGainEditor> {
  final _controller = TextEditingController(
      text:
          FinampSettingsHelper.finampSettings.replayGainIOSBaseGain.toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Replay Gain Base Gain (iOS only)"),
      subtitle: Text("Currently, Replay Gain on iOS required changing the playback volume to emulate the gain change. Since we can't increase the volume above 100%, we need to decrease the volume by default so that we can boost the volume of quiet songs. The value is in decibels (dB), where -10 dB is 50% volume and -5 dB is 75% volume."),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueDouble = double.tryParse(value);

            if (valueDouble != null) {
              FinampSettingsHelper.setReplayGainIOSBaseGain(valueDouble);
            }
          },
        ),
      ),
    );
  }
}
