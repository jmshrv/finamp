import 'package:flutter/material.dart';

import '../models/JellyfinModels.dart';
import '../components/MusicScreen/MusicScreenTabView.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BaseItemDto artist = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(artist.name),
      ),
      body: MusicScreenTabView(
        tabContentType: TabContentType.albums,
        parentItem: artist,
      ),
    );
  }
}
