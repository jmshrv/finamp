import 'dart:io';

import 'package:finamp/components/LayoutSettingsScreen/CustomizationSettingsScreen/playback_speed_control_visibility_dropdown_list_tile.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

class CustomizationSettingsScreen extends StatefulWidget {
  const CustomizationSettingsScreen({Key? key}) : super(key: key);

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
          IconButton(
            onPressed: () {
              setState(() {
                FinampSettingsHelper.resetCustomizationSettings();
              });
            },
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.resetToDefaults,
          )
        ],
      ),
      body: ListView(
        children: [
          const PlaybackSpeedControlVisibilityDropdownListTile(),
          if (!Platform.isIOS) const ShowStopButtonOnMediaNotificationToggle(),
          const ShowSeekControlsOnMediaNotificationToggle(),
          const ShowFeatureChipsToggle(),
        ],
      ),
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

class ShowFeatureChipsToggle extends StatelessWidget {
  const ShowFeatureChipsToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? featureChipsEnabled =
            box.get("FinampSettings")?.featureChipsConfiguration.enabled;

        return SwitchListTile.adaptive(
          title:
              Text(AppLocalizations.of(context)!.showFeatureChipsToggleTitle),
          subtitle: Text(
              AppLocalizations.of(context)!.showFeatureChipsToggleSubtitle),
          value: featureChipsEnabled ?? false,
          onChanged: featureChipsEnabled == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.featureChipsConfiguration =
                      finampSettingsTemp.featureChipsConfiguration
                          .copyWith(enabled: value);
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
