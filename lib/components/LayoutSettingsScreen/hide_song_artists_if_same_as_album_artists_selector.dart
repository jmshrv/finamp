import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class HideSongArtistsIfSameAsAlbumArtistsSelector extends StatelessWidget {
  const HideSongArtistsIfSameAsAlbumArtistsSelector({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile(
          title: Text(AppLocalizations.of(context)!
              .hideSongArtistsIfSameAsAlbumArtists),
          subtitle: Text(AppLocalizations.of(context)!
              .hideSongArtistsIfSameAsAlbumArtistsSubtitle),
          value: FinampSettingsHelper
              .finampSettings.hideSongArtistsIfSameAsAlbumArtists,
          onChanged: (value) =>
              FinampSettingsHelper.setHideSongArtistsIfSameAsAlbumArtists(
                  value),
        );
      },
    );
  }
}
