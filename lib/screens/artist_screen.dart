import 'package:flutter/material.dart';

import '../components/ArtistScreen/artist_screen_content.dart';
import '../components/now_playing_bar.dart';
import '../models/jellyfin_models.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({
    super.key,
    this.widgetArtist,
  });

  static const routeName = "/music/artist";

  /// The artist to show. Can also be provided as an argument in a named route
  final BaseItemDto? widgetArtist;

  @override
  Widget build(BuildContext context) {
    final BaseItemDto artist = widgetArtist ??
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: ArtistScreenContent(
         parent: artist,
        ),
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
