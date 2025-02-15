import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';

import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';

class LyricsSettingsScreen extends StatefulWidget {
  const LyricsSettingsScreen({super.key});
  static const routeName = "/settings/lyrics";
  @override
  State<LyricsSettingsScreen> createState() => _LyricsSettingsScreenState();
}

class _LyricsSettingsScreenState extends State<LyricsSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.lyricsScreen),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetLyricsSettings)
        ],
      ),
      body: ListView(
        children: const [
          ShowLyricsTimestampsToggle(),
          ShowLyricsScreenAlbumPreludeToggle(),
          LyricsAlignmentSelector(),
          LyricsFontSizeSelector(),
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

class LyricsAlignmentSelector extends StatelessWidget {
  const LyricsAlignmentSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        final finampSettings = box.get("FinampSettings")!;
        return ListTile(
          title: Text(AppLocalizations.of(context)!.lyricsAlignmentTitle),
          subtitle: Text(AppLocalizations.of(context)!.lyricsAlignmentSubtitle),
          trailing: DropdownButton<LyricsAlignment>(
            value: finampSettings.lyricsAlignment,
            items: LyricsAlignment.values
                .map((e) => DropdownMenuItem<LyricsAlignment>(
                      value: e,
                      child: Text(e.toLocalisedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettings finampSettingsTemp = finampSettings;
                finampSettingsTemp.lyricsAlignment = value;
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

class LyricsFontSizeSelector extends StatelessWidget {
  const LyricsFontSizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        final finampSettings = box.get("FinampSettings")!;
        return ListTile(
          title: Text(AppLocalizations.of(context)!.lyricsFontSizeTitle),
          subtitle: Text(AppLocalizations.of(context)!.lyricsFontSizeSubtitle),
          trailing: DropdownButton<LyricsFontSize>(
            value: finampSettings.lyricsFontSize,
            items: LyricsFontSize.values
                .map((e) => DropdownMenuItem<LyricsFontSize>(
                      value: e,
                      child: Text(e.toLocalisedString(context)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettings finampSettingsTemp = finampSettings;
                finampSettingsTemp.lyricsFontSize = value;
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

class ShowLyricsScreenAlbumPreludeToggle extends StatelessWidget {
  const ShowLyricsScreenAlbumPreludeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? showLyricsScreenAlbumPrelude =
            box.get("FinampSettings")?.showLyricsScreenAlbumPrelude;

        return SwitchListTile.adaptive(
          title: Text(
              AppLocalizations.of(context)!.showLyricsScreenAlbumPreludeTitle),
          subtitle: Text(AppLocalizations.of(context)!
              .showLyricsScreenAlbumPreludeSubtitle),
          value: showLyricsScreenAlbumPrelude ?? false,
          onChanged: showLyricsScreenAlbumPrelude == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.showLyricsScreenAlbumPrelude = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
