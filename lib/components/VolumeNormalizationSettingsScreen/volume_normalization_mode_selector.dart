import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

extension LocalizedName on VolumeNormalizationMode {
  String toLocalizedString(BuildContext context) =>
      _humanReadableLocalizedName(this, context);

  String _humanReadableLocalizedName(
      VolumeNormalizationMode themeMode, BuildContext context) {
    switch (themeMode) {
      case VolumeNormalizationMode.hybrid:
        return AppLocalizations.of(context)!.volumeNormalizationModeHybrid;
      case VolumeNormalizationMode.trackBased:
        return AppLocalizations.of(context)!.volumeNormalizationModeTrackBased;
      // case VolumeNormalizationMode.albumBased:
      //   return AppLocalizations.of(context)!.volumeNormalizationModeAlbumBased;
      case VolumeNormalizationMode.albumOnly:
        return AppLocalizations.of(context)!.volumeNormalizationModeAlbumOnly;
    }
  }
}

class VolumeNormalizationModeSelector extends StatelessWidget {
  const VolumeNormalizationModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        VolumeNormalizationMode? volumeNormalizationMode =
            box.get("FinampSettings")?.volumeNormalizationMode;
        return ListTile(
          title: Text(AppLocalizations.of(context)!
              .volumeNormalizationModeSelectorTitle),
          subtitle: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)!
                      .volumeNormalizationModeSelectorSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const TextSpan(text: "\n"),
                // tappable "more info" text
                TextSpan(
                  text: AppLocalizations.of(context)!.moreInfo,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showGeneralDialog(
                          context: context,
                          pageBuilder: (context, anim1, anim2) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)!
                                  .volumeNormalizationModeSelectorTitle),
                              content: Text(AppLocalizations.of(context)!
                                  .volumeNormalizationModeSelectorDescription),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child:
                                      Text(AppLocalizations.of(context)!.close),
                                ),
                              ],
                            );
                          });
                    },
                ),
              ],
            ),
          ),
          trailing: DropdownButton<VolumeNormalizationMode>(
            value: volumeNormalizationMode,
            items: VolumeNormalizationMode.values
                .map((e) => DropdownMenuItem<VolumeNormalizationMode>(
                      value: e,
                      child: Text(e.toLocalizedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettings finampSettingsTemp = box.get("FinampSettings")!;
                finampSettingsTemp.volumeNormalizationMode = value;
                box.put("FinampSettings", finampSettingsTemp);
              }
            },
          ),
        );
      },
    );
  }
}
