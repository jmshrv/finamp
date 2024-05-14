import 'package:Finamp/components/LayoutSettingsScreen/CustomizationSettingsScreen/playback_speed_control_visibility_dropdown_list_tile.dart';
import 'package:Finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        children: const [
          PlaybackSpeedControlVisibilityDropdownListTile(),
        ],
      ),
    );
  }
}
