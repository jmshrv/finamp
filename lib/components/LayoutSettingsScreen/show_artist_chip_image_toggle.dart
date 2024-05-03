import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';

class ShowArtistChipImageToggle extends StatelessWidget {
  const ShowArtistChipImageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        bool? showImage = box.get("FinampSettings")?.showArtistChipImage;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.showArtistChipImage),
          subtitle:
              Text(AppLocalizations.of(context)!.showArtistChipImageSubtitle),
          value: showImage ?? false,
          onChanged: showImage == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.showArtistChipImage = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
