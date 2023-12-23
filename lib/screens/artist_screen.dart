import 'package:flutter/material.dart';
import '../components/ArtistScreen/artist_screen_content.dart';
import '../models/jellyfin_models.dart';
import '../components/now_playing_bar.dart';

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
