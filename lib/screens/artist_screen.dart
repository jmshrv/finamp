import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../components/AlbumScreen/album_screen_content.dart';
import '../components/AlbumScreen/song_list_tile.dart';
import '../components/ArtistScreen/artist_download_button.dart';
import '../components/MusicScreen/music_screen_tab_view.dart';
import '../components/favourite_button.dart';
import '../components/now_playing_bar.dart';
import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import '../services/finamp_settings_helper.dart';
import '../services/jellyfin_api_helper.dart';

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
      appBar: AppBar(
        title: Text(artist.name ?? "Unknown Name"),
        actions: [
          // this screen is also used for genres, which can't be favorited
          if (artist.type != "MusicGenre") FavoriteButton(item: artist),
          ArtistDownloadButton(artist: artist)
        ],
      ),
      body: ArtistScreenContent(
        parent: artist,
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
