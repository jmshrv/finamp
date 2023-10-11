import 'package:finamp/components/LayoutSettingsScreen/disable_gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/LayoutSettingsScreen/theme_selector.dart';
import 'tabs_settings_screen.dart';
import '../components/LayoutSettingsScreen/content_grid_view_cross_axis_count_list_tile.dart';
import '../components/LayoutSettingsScreen/content_view_type_dropdown_list_tile.dart';
import '../components/LayoutSettingsScreen/show_text_on_grid_view_selector.dart';
import '../components/LayoutSettingsScreen/show_cover_as_player_background_selector.dart';
import '../components/LayoutSettingsScreen/hide_song_artists_if_same_as_album_artists_selector.dart';

class LayoutSettingsScreen extends StatelessWidget {
  const LayoutSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/layout";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.layoutAndTheme),
      ),
      body: ListView(
        children: [
          const ContentViewTypeDropdownListTile(),
          for (final type in ContentGridViewCrossAxisCountType.values)
            ContentGridViewCrossAxisCountListTile(type: type),
          const ShowTextOnGridViewSelector(),
          const ShowCoverAsPlayerBackgroundSelector(),
          const HideSongArtistsIfSameAsAlbumArtistsSelector(),
          const DisableGestureSelector(),
          const ThemeSelector(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.tab),
            title: Text(AppLocalizations.of(context)!.tabs),
            onTap: () =>
                Navigator.of(context).pushNamed(TabsSettingsScreen.routeName),
          ),
        ],
      ),
    );
  }
}
