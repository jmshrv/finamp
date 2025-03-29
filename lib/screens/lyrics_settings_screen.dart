import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class ShowLyricsTimestampsToggle extends ConsumerWidget {
  const ShowLyricsTimestampsToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.showLyricsTimestampsTitle),
      subtitle:
          Text(AppLocalizations.of(context)!.showLyricsTimestampsSubtitle),
      value: ref.watch(finampSettingsProvider.showLyricsTimestamps),
      onChanged: FinampSetters.setShowLyricsTimestamps,
    );
  }
}

class LyricsAlignmentSelector extends ConsumerWidget {
  const LyricsAlignmentSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.lyricsAlignmentTitle),
      subtitle: Text(AppLocalizations.of(context)!.lyricsAlignmentSubtitle),
      trailing: DropdownButton<LyricsAlignment>(
        value: ref.watch(finampSettingsProvider.lyricsAlignment),
        items: LyricsAlignment.values
            .map((e) => DropdownMenuItem<LyricsAlignment>(
                  value: e,
                  child: Text(e.toLocalisedString(context)),
                ))
            .toList(),
        onChanged: FinampSetters.setLyricsAlignment.ifNonNull,
      ),
    );
  }
}

class LyricsFontSizeSelector extends ConsumerWidget {
  const LyricsFontSizeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.lyricsFontSizeTitle),
      subtitle: Text(AppLocalizations.of(context)!.lyricsFontSizeSubtitle),
      trailing: DropdownButton<LyricsFontSize>(
        value: ref.watch(finampSettingsProvider.lyricsFontSize),
        items: LyricsFontSize.values
            .map((e) => DropdownMenuItem<LyricsFontSize>(
                  value: e,
                  child: Text(e.toLocalisedString(context)),
                ))
            .toList(),
        onChanged: FinampSetters.setLyricsFontSize.ifNonNull,
      ),
    );
  }
}

class ShowLyricsScreenAlbumPreludeToggle extends ConsumerWidget {
  const ShowLyricsScreenAlbumPreludeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title:
          Text(AppLocalizations.of(context)!.showLyricsScreenAlbumPreludeTitle),
      subtitle: Text(
          AppLocalizations.of(context)!.showLyricsScreenAlbumPreludeSubtitle),
      value: ref.watch(finampSettingsProvider.showLyricsScreenAlbumPrelude),
      onChanged: FinampSetters.setShowLyricsScreenAlbumPrelude,
    );
  }
}
