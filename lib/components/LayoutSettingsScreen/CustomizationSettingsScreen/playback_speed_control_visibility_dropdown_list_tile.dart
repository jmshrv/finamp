import 'package:finamp/services/metadata_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../../../models/finamp_models.dart';
import '../../../services/finamp_settings_helper.dart';

class PlaybackSpeedControlVisibilityDropdownListTile extends StatelessWidget {
  const PlaybackSpeedControlVisibilityDropdownListTile({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return ListTile(
          title:
              Text(AppLocalizations.of(context)!.playbackSpeedControlSetting),
          subtitle: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)!
                      .playbackSpeedControlSettingSubtitle,
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
                                  .playbackSpeedControlSetting),
                              content: Text(AppLocalizations.of(context)!
                                  .playbackSpeedControlSettingDescription(
                                      MetadataProvider
                                          .speedControlLongTrackDuration
                                          .inMinutes,
                                      MetadataProvider
                                          .speedControlLongAlbumDuration
                                          .inHours,
                                      MetadataProvider.speedControlGenres
                                          .join(", "))),
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
          trailing: DropdownButton<PlaybackSpeedVisibility>(
            value: box.get("FinampSettings")?.playbackSpeedVisibility,
            items: PlaybackSpeedVisibility.values
                .map((e) => DropdownMenuItem<PlaybackSpeedVisibility>(
                      value: e,
                      child: Text(e.toLocalisedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettingsHelper.setPlaybackSpeedVisibility(value);
              }
            },
          ),
        );
      },
    );
  }
}
