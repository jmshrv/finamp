import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

class AudioFadeInDurationListTile extends StatefulWidget {
  const AudioFadeInDurationListTile({super.key});

  @override
  State<AudioFadeInDurationListTile> createState() =>
      _AudioFadeInDurationListTileState();
}

class _AudioFadeInDurationListTileState
    extends State<AudioFadeInDurationListTile> {
  final _controller = TextEditingController(
      text: FinampSettingsHelper
          .finampSettings.audioFadeInDuration.inMilliseconds
          .toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          Text(AppLocalizations.of(context)!.audioFadeInDurationSettingTitle),
      subtitle: Text(
          AppLocalizations.of(context)!.audioFadeInDurationSettingSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueInt = int.tryParse(value);

            if (valueInt != null && !valueInt.isNegative) {
              FinampSettingsHelper.setAudioFadeInDuration(
                  Duration(milliseconds: valueInt));
            }
          },
        ),
      ),
    );
  }
}
