import 'dart:io';

import 'package:finamp/components/LayoutSettingsScreen/CustomizationSettingsScreen/playback_speed_control_visibility_dropdown_list_tile.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hive_ce/hive.dart';

class CustomizationSettingsScreen extends StatefulWidget {
  const CustomizationSettingsScreen({super.key});

  static const routeName = "/settings/customization";

  @override
  State<CustomizationSettingsScreen> createState() =>
      _CustomizationSettingsScreenState();
}

class _CustomizationSettingsScreenState
    extends State<CustomizationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.customizationSettingsTitle),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetCustomizationSettings)
        ],
      ),
      body: ListView(
        children: [
          const PlaybackSpeedControlVisibilityDropdownListTile(),
          if (!Platform.isIOS) const ShowStopButtonOnMediaNotificationToggle(),
          const ShowSeekControlsOnMediaNotificationToggle(),
          const OneLineMarqueeTextSwitch(),
          const ReleaseDateFormatDropdownListTile(),
          const ShowAlbumReleaseDateOnPlayerScreenToggle(),
        ],
      ),
    );
  }
}

class OneLineMarqueeTextSwitch extends StatelessWidget {
  const OneLineMarqueeTextSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? oneLineMarquee =
            box.get("FinampSettings")?.oneLineMarqueeTextButton;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.oneLineMarqueeTextButton),
          subtitle: Text(
              AppLocalizations.of(context)!.oneLineMarqueeTextButtonSubtitle),
          value: oneLineMarquee ?? false,
          onChanged: oneLineMarquee == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.oneLineMarqueeTextButton = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class ShowStopButtonOnMediaNotificationToggle extends StatelessWidget {
  const ShowStopButtonOnMediaNotificationToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? showStopButtonOnMediaNotification =
            box.get("FinampSettings")?.showStopButtonOnMediaNotification;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!
              .showStopButtonOnMediaNotificationTitle),
          subtitle: Text(AppLocalizations.of(context)!
              .showStopButtonOnMediaNotificationSubtitle),
          value: showStopButtonOnMediaNotification ?? false,
          onChanged: showStopButtonOnMediaNotification == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.showStopButtonOnMediaNotification = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class ShowSeekControlsOnMediaNotificationToggle extends StatelessWidget {
  const ShowSeekControlsOnMediaNotificationToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? showSeekControlsOnMediaNotification =
            box.get("FinampSettings")?.showSeekControlsOnMediaNotification;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!
              .showSeekControlsOnMediaNotificationTitle),
          subtitle: Text(AppLocalizations.of(context)!
              .showSeekControlsOnMediaNotificationSubtitle),
          value: showSeekControlsOnMediaNotification ?? false,
          onChanged: showSeekControlsOnMediaNotification == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.showSeekControlsOnMediaNotification =
                      value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class ShowAlbumReleaseDateOnPlayerScreenToggle extends StatelessWidget {
  const ShowAlbumReleaseDateOnPlayerScreenToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? showAlbumReleaseDateOnPlayerScreen =
            box.get("FinampSettings")?.showAlbumReleaseDateOnPlayerScreen;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!
              .showAlbumReleaseDateOnPlayerScreenTitle),
          subtitle: Text(AppLocalizations.of(context)!
              .showAlbumReleaseDateOnPlayerScreenSubtitle),
          value: showAlbumReleaseDateOnPlayerScreen ?? false,
          onChanged: showAlbumReleaseDateOnPlayerScreen == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.showAlbumReleaseDateOnPlayerScreen = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class ReleaseDateFormatDropdownListTile extends StatelessWidget {
  const ReleaseDateFormatDropdownListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        final finampSettings = box.get("FinampSettings")!;

        return ListTile(
          title: Text(AppLocalizations.of(context)!.releaseDateFormatTitle),
          subtitle:
              Text(AppLocalizations.of(context)!.releaseDateFormatSubtitle),
          trailing: DropdownButton<ReleaseDateFormat>(
            value: finampSettings.releaseDateFormat,
            items: ReleaseDateFormat.values
                .map((e) => DropdownMenuItem<ReleaseDateFormat>(
                      value: e,
                      child: Text(e.toLocalisedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettings finampSettingsTemp = finampSettings;
                finampSettingsTemp.releaseDateFormat = value;
                Hive.box<FinampSettings>("FinampSettings")
                    .put("FinampSettings", finampSettingsTemp);
              }
            },
          ),
        );
      },
    );
  }
}
