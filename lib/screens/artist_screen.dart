import 'package:flutter/material.dart';

import '../components/ArtistScreen/artist_screen_content.dart';
import '../components/now_playing_bar.dart';
import '../models/jellyfin_models.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({
    super.key,
    this.widgetArtist,
    this.genreFilter,
  });

  static const routeName = "/music/artist";

  /// The artist to show. Can also be provided as an argument in a named route
  final BaseItemDto? widgetArtist;

  // The genreFilter to apply
  final BaseItemDto? genreFilter;

  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  BaseItemDto? currentGenreFilter;

  @override
  void initState() {
    super.initState();
    // Initialize with the provided genre filter or default to null
    currentGenreFilter = widget.genreFilter;
  }

  // Function to reset the genre filter and refresh the screen
  void resetGenreFilter() {
    setState(() {
      currentGenreFilter = null;  // Reset the genre filter
    });
  }

  @override
  Widget build(BuildContext context) {
    final BaseItemDto artist = widget.widgetArtist ??
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: ArtistScreenContent(
          parent: artist,
          genreFilter: currentGenreFilter,
          resetGenreFilter: resetGenreFilter,
        ),
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
