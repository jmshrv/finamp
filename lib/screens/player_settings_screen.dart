import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../components/LayoutSettingsScreen/player_screen_minimum_cover_padding_editor.dart';
import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';

class PlayerSettingsScreen extends StatefulWidget {
  const PlayerSettingsScreen({super.key});
  static const routeName = "/settings/player";
  @override
  State<PlayerSettingsScreen> createState() => _PlayerSettingsScreenState();
}

class _PlayerSettingsScreenState extends State<PlayerSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.playerScreen),
          actions: [
            FinampSettingsHelper.makeSettingsResetButtonWithDialog(
                context, FinampSettingsHelper.resetPlayerScreenSettings)
          ]),
      body: ListView(
        children: const [
          const ShowFeatureChipsToggle(),
          PlayerScreenMinimumCoverPaddingEditor(),
          SuppressPlayerPaddingSwitch(),
          PrioritizeCoverSwitch(),
          hidePlayerBottomActionsSwitch(),
        ],
      ),
    );
  }
}

class SuppressPlayerPaddingSwitch extends StatelessWidget {
  const SuppressPlayerPaddingSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? suppressPadding =
            box.get("FinampSettings")?.suppressPlayerPadding;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.suppressPlayerPadding),
          subtitle:
              Text(AppLocalizations.of(context)!.suppressPlayerPaddingSubtitle),
          value: suppressPadding ?? false,
          onChanged: suppressPadding == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.suppressPlayerPadding = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class hidePlayerBottomActionsSwitch extends StatelessWidget {
  const hidePlayerBottomActionsSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? hideQueue = box.get("FinampSettings")?.hidePlayerBottomActions;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.hidePlayerBottomActions),
          subtitle: Text(
              AppLocalizations.of(context)!.hidePlayerBottomActionsSubtitle),
          value: hideQueue ?? false,
          onChanged: hideQueue == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.hidePlayerBottomActions = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class PrioritizeCoverSwitch extends StatelessWidget {
  const PrioritizeCoverSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        double? prioritizeCover =
            box.get("FinampSettings")?.prioritizeCoverFactor;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.prioritizePlayerCover),
          subtitle:
              Text(AppLocalizations.of(context)!.prioritizePlayerCoverSubtitle),
          value: (prioritizeCover ?? 8) < 6,
          onChanged: prioritizeCover == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.prioritizeCoverFactor = value ? 3.0 : 8.0;
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
