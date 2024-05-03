import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class ShowArtistsTopSongsSelector extends StatelessWidget {
  const ShowArtistsTopSongsSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.showArtistsTopSongs),
          subtitle:
              Text(AppLocalizations.of(context)!.showArtistsTopSongsSubtitle),
          value: FinampSettingsHelper.finampSettings.showArtistsTopSongs,
          onChanged: (value) =>
              FinampSettingsHelper.setShowArtistsTopSongs(value),
        );
      },
    );
  }
}
