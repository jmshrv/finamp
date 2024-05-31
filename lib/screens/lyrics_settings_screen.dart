import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../components/LayoutSettingsScreen/player_screen_minimum_cover_padding_editor.dart';
import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';

class LyricsSettingsScreen extends StatelessWidget {
  const LyricsSettingsScreen({super.key});

  static const routeName = "/settings/lyrics";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.lyricsScreen),
      ),
      body: ListView(
        children: const [
          ShowLyricsTimestampsToggle(),
        ],
      ),
    );
  }
}

class ShowLyricsTimestampsToggle extends StatelessWidget {
  const ShowLyricsTimestampsToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? showLyricsTimestamps =
            box.get("FinampSettings")?.showLyricsTimestamps;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.showLyricsTimestampsTitle),
          subtitle:
              Text(AppLocalizations.of(context)!.showLyricsTimestampsSubtitle),
          value: showLyricsTimestamps ?? false,
          onChanged: showLyricsTimestamps == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.showLyricsTimestamps = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
