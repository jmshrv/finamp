import 'package:finamp/components/InteractionSettingsScreen/keep_screen_on_dropdown_list_tile.dart';
import 'package:finamp/components/InteractionSettingsScreen/keep_screen_on_while_charging_selector.dart';
import 'package:finamp/components/InteractionSettingsScreen/item_swipe_action_dropdown_list_tile.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/InteractionSettingsScreen/FastScrollSelector.dart';
import '../components/InteractionSettingsScreen/disable_gestures.dart';
import '../components/InteractionSettingsScreen/disable_vibration.dart';


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
          ItemSwipeActionDropdownListTile(DismissDirection.startToEnd),
          ItemSwipeActionDropdownListTile(DismissDirection.endToStart),
          StartInstantMixForIndividualTracksSwitch(),
          FastScrollSelector(),
          ShowDeleteFromServerOptionToggle(),
          DisableGestureSelector(),
          DisableVibrationSelector(),
          KeepScreenOnDropdownListTile(),
          KeepScreenOnWhilePluggedInSelector(),
        ],
      ),
    );
  }
}

class StartInstantMixForIndividualTracksSwitch extends ConsumerWidget {
  const StartInstantMixForIndividualTracksSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!
          .startInstantMixForIndividualTracksSwitchTitle),
      subtitle: Text(AppLocalizations.of(context)!
          .startInstantMixForIndividualTracksSwitchSubtitle),
      value:
          ref.watch(finampSettingsProvider.startInstantMixForIndividualTracks),
      onChanged: FinampSetters.setStartInstantMixForIndividualTracks,
    );
  }
}

class ShowDeleteFromServerOptionToggle extends ConsumerWidget {
  const ShowDeleteFromServerOptionToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.allowDeleteFromServerTitle),
      subtitle:
          Text(AppLocalizations.of(context)!.allowDeleteFromServerSubtitle),
      value: ref.watch(finampSettingsProvider.allowDeleteFromServer),
      onChanged: FinampSetters.setAllowDeleteFromServer,
    );
  }
}
