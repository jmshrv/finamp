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
      title: Text(AppLocalizations.of(context)!.replayGainIOSBaseGainEditorTitle),
      subtitle: Text(AppLocalizations.of(context)!.replayGainIOSBaseGainEditorSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
