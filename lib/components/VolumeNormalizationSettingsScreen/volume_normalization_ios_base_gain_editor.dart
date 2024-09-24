import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

class VolumeNormalizationIOSBaseGainEditor extends StatefulWidget {
  const VolumeNormalizationIOSBaseGainEditor({Key? key}) : super(key: key);

  @override
  State<VolumeNormalizationIOSBaseGainEditor> createState() =>
      _VolumeNormalizationIOSBaseGainEditorState();
}

class _VolumeNormalizationIOSBaseGainEditorState
    extends State<VolumeNormalizationIOSBaseGainEditor> {
  final _controller = TextEditingController(
      text: FinampSettingsHelper.finampSettings.volumeNormalizationIOSBaseGain
          .toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!
          .volumeNormalizationIOSBaseGainEditorTitle),
      subtitle: Text(AppLocalizations.of(context)!
          .volumeNormalizationIOSBaseGainEditorSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(
              decimal: true, signed: true),
          onChanged: (value) {
            final valueDouble = double.tryParse(value);

            if (valueDouble != null) {
              FinampSettingsHelper.setVolumeNormalizationIOSBaseGain(
                  valueDouble);
            }
          },
        ),
      ),
    );
  }
}
