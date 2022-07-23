import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class HideSongArtistsIfSameAsAlbumArtistsSelector extends StatelessWidget {
  const HideSongArtistsIfSameAsAlbumArtistsSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile(
          title: const Text("Hide Song Artists if same as Album Artists"),
          subtitle: const Text(
              "Whether or not to hide song artists on album screen if they don't differ from album artists."),
          value: FinampSettingsHelper.finampSettings.hideSongArtistsIfSameAsAlbumArtists,
          onChanged: (value) =>
              FinampSettingsHelper.setHideSongArtistsIfSameAsAlbumArtists(value),
        );
      },
    );
  }
}
