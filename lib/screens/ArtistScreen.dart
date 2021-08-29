import 'package:flutter/material.dart';

import '../models/JellyfinModels.dart';
import '../models/FinampModels.dart';
import '../components/ArtistScreen/ArtistDownloadButton.dart';
import '../components/MusicScreen/MusicScreenTabView.dart';
import '../components/NowPlayingBar.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({
    Key? key,
    this.widgetArtist,
  }) : super(key: key);

  /// The artist to show. Can also be provided as an argument in a named route
  final BaseItemDto? widgetArtist;

  @override
  Widget build(BuildContext context) {
    final BaseItemDto artist = widgetArtist ??
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      appBar: AppBar(
        title: Text(artist.name ?? "Unknown Name"),
        actions: [ArtistDownloadButton(artist: artist)],
      ),
      body: MusicScreenTabView(
        tabContentType: TabContentType.albums,
        parentItem: artist,
        isFavourite: false,
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
