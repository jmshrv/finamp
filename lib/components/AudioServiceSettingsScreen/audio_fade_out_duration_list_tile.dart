import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

class AudioFadeOutDurationListTile extends StatefulWidget {
  const AudioFadeOutDurationListTile({super.key});

  @override
  State<AudioFadeOutDurationListTile> createState() =>
      _AudioFadeOutDurationListTileState();
}

class _AudioFadeOutDurationListTileState
    extends State<AudioFadeOutDurationListTile> {
  final _controller = TextEditingController(
      text: FinampSettingsHelper
          .finampSettings.audioFadeOutDuration.inMilliseconds
          .toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          Text(AppLocalizations.of(context)!.audioFadeOutDurationSettingTitle),
      subtitle: Text(
          AppLocalizations.of(context)!.audioFadeOutDurationSettingSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueInt = int.tryParse(value);

            if (valueInt != null && !valueInt.isNegative) {
              FinampSettingsHelper.setAudioFadeOutDuration(
                  Duration(milliseconds: valueInt));
            }
          },
        ),
      ),
    );
  }
}
