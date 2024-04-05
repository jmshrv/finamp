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
      title: Text(AppLocalizations.of(context)!.replayGainNormalizationFactorEditorTitle),
      subtitle: Text(AppLocalizations.of(context)!.replayGainNormalizationFactorEditorSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
