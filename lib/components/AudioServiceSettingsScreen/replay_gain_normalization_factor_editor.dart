import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

class ReplayGainNormalizationFactorEditor extends StatefulWidget {
  const ReplayGainNormalizationFactorEditor({Key? key}) : super(key: key);

  @override
  State<ReplayGainNormalizationFactorEditor> createState() =>
      _ReplayGainNormalizationFactorEditorState();
}

class _ReplayGainNormalizationFactorEditorState
    extends State<ReplayGainNormalizationFactorEditor> {
  final _controller = TextEditingController(
      text:
          FinampSettingsHelper.finampSettings.replayGainNormalizationFactor.toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Replay Gain Normalization Factor"),
      subtitle: Text("How much to normalize the volume by (between 0 and 1)"),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueDouble = double.tryParse(value);

            if (valueDouble != null) {
              FinampSettingsHelper.setReplayGainNormalizationFactor(valueDouble);
            }
          },
        ),
      ),
    );
  }
}
