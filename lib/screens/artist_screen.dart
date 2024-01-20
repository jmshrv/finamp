import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/ArtistScreen/artist_download_button.dart';
import '../components/ArtistScreen/artist_screen_content.dart';
import '../components/favourite_button.dart';
import '../components/now_playing_bar.dart';
import '../models/jellyfin_models.dart';
import '../components/ArtistScreen/artist_play_button.dart';
import '../components/ArtistScreen/artist_shuffle_button.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({
    Key? key,
    this.widgetArtist,
  }) : super(key: key);

  static const routeName = "/music/artist";

  /// The artist to show. Can also be provided as an argument in a named route
  final BaseItemDto? widgetArtist;

  @override
  Widget build(BuildContext context) {
    final BaseItemDto artist = widgetArtist ??
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      body: ArtistScreenContent(
        parent: artist,
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
