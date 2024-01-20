import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

extension LocalizedName on ReplayGainMode {
  String toLocalizedString(BuildContext context) =>
      _humanReadableLocalizedName(this, context);

  String _humanReadableLocalizedName(
      ReplayGainMode themeMode, BuildContext context) {
    switch (themeMode) {
      case ReplayGainMode.hybrid:
        return AppLocalizations.of(context)!.replayGainModeHybrid;
      case ReplayGainMode.trackOnly:
        return AppLocalizations.of(context)!.replayGainModeTrackOnly;
      case ReplayGainMode.albumOnly:
        return AppLocalizations.of(context)!.replayGainModeAlbumOnly;
    }
  }
}

class ReplayGainModeSelector extends StatelessWidget {
  const ReplayGainModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        ReplayGainMode? replayGainMode = box.get("FinampSettings")?.replayGainMode;
        return ListTile(
          title: Text(AppLocalizations.of(context)!.replayGainModeSelectorTitle),
          subtitle: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)!.replayGainModeSelectorSubtitle,
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
                      showGeneralDialog(context: context, pageBuilder: (context, anim1, anim2) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.replayGainModeSelectorTitle),
                          content: Text(AppLocalizations.of(context)!.replayGainModeSelectorDescription),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(AppLocalizations.of(context)!.close),
                            ),
                          ],
                        );
                      });
                    },
                ),
              ],
            ),
          ),
          trailing: DropdownButton<ReplayGainMode>(
            value: replayGainMode,
            items: ReplayGainMode.values
                .map((e) => DropdownMenuItem<ReplayGainMode>(
                      value: e,
                      child: Text(e.toLocalizedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.replayGainMode = value;
                  box.put("FinampSettings", finampSettingsTemp);
              }
            },
          ),
        );
      },
    );
  }
}
