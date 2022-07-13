import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class ShowCoverOnPlayerBackgroundSelector extends StatelessWidget {
  const ShowCoverOnPlayerBackgroundSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return SwitchListTile(
          title: const Text("Show Blurred Cover as Player Background"),
          subtitle: const Text(
              "Whether or not to use blurred cover art as background on player screen."),
          value: FinampSettingsHelper.finampSettings.showCoverPlayerBackground,
          onChanged: (value) =>
              FinampSettingsHelper.setShowAlbumArtPlayerBackground(value),
        );
      },
    );
  }
}
