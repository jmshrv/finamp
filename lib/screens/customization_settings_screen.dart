import 'package:finamp/components/LayoutSettingsScreen/CustomizationSettingsScreen/playback_speed_control_visibility_dropdown_list_tile.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
          OneLineMarqueeTextSwitch(),
          MarqueeOrTruncate(),
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

class MarqueeOrTruncate extends StatelessWidget {
  const MarqueeOrTruncate({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? oneLineMarquee =
            box.get("FinampSettings")?.marqueeOrTruncateButton;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.marqueeOrTruncateButton),
          subtitle: Text(
              AppLocalizations.of(context)!.marqueeOrTruncateButtonSubtitle),
          value: oneLineMarquee ?? false,
          onChanged: oneLineMarquee == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.marqueeOrTruncateButton = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
