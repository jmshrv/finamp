import 'package:flutter/material.dart';

import '../models/JellyfinModels.dart';
import '../components/AlbumScreen/AlbumScreenContent.dart';
import '../components/NowPlayingBar.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BaseItemDto album = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: AlbumScreenContent(album: album),
      persistentFooterButtons: [NowPlayingBar()],
    );
  }
}
