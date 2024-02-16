import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

class ReplayGainTargetLufsEditor extends StatefulWidget {
  const ReplayGainTargetLufsEditor({Key? key}) : super(key: key);

  @override
  State<ReplayGainTargetLufsEditor> createState() =>
      _ReplayGainTargetLufsEditorState();
}

class _ReplayGainTargetLufsEditorState
    extends State<ReplayGainTargetLufsEditor> {
  final _controller = TextEditingController(
      text:
          FinampSettingsHelper.finampSettings.replayGainTargetLufs.toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.replayGainTargetLufsEditorTitle),
      subtitle: Text(AppLocalizations.of(context)!.replayGainTargetLufsEditorSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueDouble = double.tryParse(value);

            if (valueDouble != null) {
              FinampSettingsHelper.setReplayGainTargetLufs(valueDouble);
            }
          },
        ),
      ),
    );
  }
}
