import 'package:finamp/components/InteractionSettingsScreen/keep_screen_on_dropdown_list_tile.dart';
import 'package:finamp/components/InteractionSettingsScreen/keep_screen_on_while_charging_selector.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../components/InteractionSettingsScreen/FastScrollSelector.dart';
import '../components/InteractionSettingsScreen/disable_gestures.dart';
import '../components/InteractionSettingsScreen/disable_vibration.dart';
import '../components/InteractionSettingsScreen/swipe_insert_queue_next_selector.dart';

class InteractionSettingsScreen extends StatefulWidget {
  const InteractionSettingsScreen({super.key});
  static const routeName = "/settings/interactions";
  @override
  State<InteractionSettingsScreen> createState() =>
      _InteractionSettingsScreenState();
}

class _InteractionSettingsScreenState extends State<InteractionSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.interactions),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetInteractionsSettings)
        ],
      ),
      body: ListView(
        children: const [
          SwipeInsertQueueNextSelector(),
          StartInstantMixForIndividualTracksSwitch(),
          FastScrollSelector(),
          DisableGestureSelector(),
          DisableVibrationSelector(),
          KeepScreenOnDropdownListTile(),
          KeepScreenOnWhilePluggedInSelector()
        ],
      ),
    );
  }
}

class StartInstantMixForIndividualTracksSwitch extends StatelessWidget {
  const StartInstantMixForIndividualTracksSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        bool? startInstantMixForIndividualTracks =
            box.get("FinampSettings")?.startInstantMixForIndividualTracks;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!
              .startInstantMixForIndividualTracksSwitchTitle),
          subtitle: Text(AppLocalizations.of(context)!
              .startInstantMixForIndividualTracksSwitchSubtitle),
          value: startInstantMixForIndividualTracks ?? false,
          onChanged: startInstantMixForIndividualTracks == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.startInstantMixForIndividualTracks = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
