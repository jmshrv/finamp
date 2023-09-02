import 'package:flutter/material.dart';

import '../models/jellyfin_models.dart';
import '../models/finamp_models.dart';
import '../components/ArtistScreen/artist_download_button.dart';
import '../components/MusicScreen/music_screen_tab_view.dart';
import '../components/now_playing_bar.dart';
import '../components/favourite_button.dart';
import '../components/ArtistScreen/artist_play_button.dart';

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
          if (artist.type != "MusicGenre") ArtistPlayButton(artist: artist),
          if (artist.type != "MusicGenre") FavoriteButton(item: artist),
          ArtistDownloadButton(artist: artist)
        ],
      ),
      body: MusicScreenTabView(
        tabContentType: TabContentType.albums,
        parentItem: artist,
        isFavourite: false,
        sortBy: SortBy.premiereDate,
        albumArtist: artist.name,
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
