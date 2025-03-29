import 'package:finamp/components/LayoutSettingsScreen/show_artists_top_tracks.dart';
import 'package:finamp/screens/album_settings_screen.dart';
import 'package:finamp/screens/customization_settings_screen.dart';
import 'package:finamp/screens/lyrics_settings_screen.dart';
import 'package:finamp/screens/player_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hive_ce/hive.dart';

import '../components/LayoutSettingsScreen/content_grid_view_cross_axis_count_list_tile.dart';
import '../components/LayoutSettingsScreen/content_view_type_dropdown_list_tile.dart';
import '../components/LayoutSettingsScreen/show_artist_chip_image_toggle.dart';
import '../components/LayoutSettingsScreen/show_text_on_grid_view_selector.dart';
import '../components/LayoutSettingsScreen/theme_selector.dart';
import '../components/LayoutSettingsScreen/use_cover_as_background_toggle.dart';
import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';
import 'tabs_settings_screen.dart';

class LayoutSettingsScreen extends StatefulWidget {
  const LayoutSettingsScreen({super.key});
  static const routeName = "/settings/layout";
  @override
  State<LayoutSettingsScreen> createState() => _LayoutSettingsScreenState();
}

class _LayoutSettingsScreenState extends State<LayoutSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
        valueListenable: FinampSettingsHelper.finampSettingsListener,
        builder: (context, box, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.layoutAndTheme),
              actions: [
                FinampSettingsHelper.makeSettingsResetButtonWithDialog(
                    context, FinampSettingsHelper.resetLayoutSettings)
              ],
            ),
            body: ListView(
              children: [
                ListTile(
                  leading: const Icon(TablerIcons.sparkles),
                  title: Text(
                      AppLocalizations.of(context)!.customizationSettingsTitle),
                  onTap: () => Navigator.of(context)
                      .pushNamed(CustomizationSettingsScreen.routeName),
                ),
                ListTile(
                  leading: const Icon(Icons.play_circle_outline),
                  title: Text(AppLocalizations.of(context)!.playerScreen),
                  onTap: () => Navigator.of(context)
                      .pushNamed(PlayerSettingsScreen.routeName),
                ),
                ListTile(
                  leading: const Icon(TablerIcons.microphone_2),
                  title: Text(AppLocalizations.of(context)!.lyricsScreen),
                  onTap: () => Navigator.of(context)
                      .pushNamed(LyricsSettingsScreen.routeName),
                ),
                ListTile(
                  leading: const Icon(TablerIcons.disc),
                  title: Text(AppLocalizations.of(context)!.albumScreen),
                  onTap: () => Navigator.of(context)
                      .pushNamed(AlbumSettingsScreen.routeName),
                ),
                ListTile(
                  leading: const Icon(Icons.tab),
                  title: Text(AppLocalizations.of(context)!.tabs),
                  onTap: () => Navigator.of(context)
                      .pushNamed(TabsSettingsScreen.routeName),
                ),
                const Divider(),
                const ThemeSelector(),
                const ContentViewTypeDropdownListTile(),
                const FixedSizeGridSwitch(),
                if (!FinampSettingsHelper.finampSettings.useFixedSizeGridTiles)
                  for (final type in ContentGridViewCrossAxisCountType.values)
                    ContentGridViewCrossAxisCountListTile(type: type),
                if (FinampSettingsHelper.finampSettings.useFixedSizeGridTiles)
                  const FixedGridTileSizeDropdownListTile(),
                const ShowTextOnGridViewSelector(),
                const UseCoverAsBackgroundToggle(),
                const ShowArtistChipImageToggle(),
                const ShowArtistsTopTracksSelector(),
                const AllowSplitScreenSwitch(),
                const ShowProgressOnNowPlayingBarToggle(),
              ],
            ),
          );
        });
  }
}

class FixedSizeGridSwitch extends ConsumerWidget {
  const FixedSizeGridSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.fixedGridSizeSwitchTitle),
      subtitle: Text(AppLocalizations.of(context)!.fixedGridSizeSwitchSubtitle),
      value: ref.watch(finampSettingsProvider.useFixedSizeGridTiles),
      onChanged: FinampSetters.setUseFixedSizeGridTiles,
    );
  }
}

class AllowSplitScreenSwitch extends ConsumerWidget {
  const AllowSplitScreenSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.allowSplitScreenTitle),
      subtitle: Text(AppLocalizations.of(context)!.allowSplitScreenSubtitle),
      value: ref.watch(finampSettingsProvider.allowSplitScreen),
      onChanged: FinampSetters.setAllowSplitScreen,
    );
  }
}

class FixedGridTileSizeDropdownListTile extends ConsumerWidget {
  const FixedGridTileSizeDropdownListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.fixedGridSizeTitle),
      trailing: DropdownButton<FixedGridTileSize>(
          value: FixedGridTileSize.fromInt(
              FinampSettingsHelper.finampSettings.fixedGridTileSize),
          items: FixedGridTileSize.values
              .map((e) => DropdownMenuItem<FixedGridTileSize>(
                    value: e,
                    child: Text(AppLocalizations.of(context)!
                        .fixedGridTileSizeEnum(e.name)),
                  ))
              .toList(),
          onChanged: (value) =>
              FinampSetters.setFixedGridTileSize.ifNonNull(value?.toInt)),
    );
  }
}

class ShowProgressOnNowPlayingBarToggle extends ConsumerWidget {
  const ShowProgressOnNowPlayingBarToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title:
          Text(AppLocalizations.of(context)!.showProgressOnNowPlayingBarTitle),
      subtitle: Text(
          AppLocalizations.of(context)!.showProgressOnNowPlayingBarSubtitle),
      value: ref.watch(finampSettingsProvider.showProgressOnNowPlayingBar),
      onChanged: FinampSetters.setShowProgressOnNowPlayingBar,
    );
  }
}

enum FixedGridTileSize {
  small,
  medium,
  large,
  veryLarge;

  static FixedGridTileSize fromInt(int size) => switch (size) {
        100 => small,
        150 => medium,
        230 => large,
        360 => veryLarge,
        _ => medium
      };

  int get toInt => switch (this) {
        small => 100,
        medium => 150,
        large => 230,
        veryLarge => 360
      };
}
