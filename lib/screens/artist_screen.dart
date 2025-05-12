import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../components/ArtistScreen/artist_screen_content.dart';
import '../components/now_playing_bar.dart';
import '../models/jellyfin_models.dart';

class ArtistScreen extends ConsumerStatefulWidget {
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

class _ArtistScreenState extends ConsumerState<ArtistScreen> {
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  BaseItemDto? currentGenreFilter;
  Key _contentKey = UniqueKey();

  Future<void> _refresh() async {
    ref.invalidate(getArtistTopTracksProvider);
    ref.invalidate(getArtistAlbumsProvider);
    ref.invalidate(getPerformingArtistAlbumsProvider);
    ref.invalidate(getPerformingArtistTracksProvider);
    ref.invalidate(getAllTracksProvider);
    setState(() {
      _contentKey = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize with the provided genre filter or default to null
    currentGenreFilter = widget.genreFilter;
  }

  // Function to update the genre filter and refresh the screen
  // Pass null in order to reset the filter
  void updateGenreFilter(BaseItemDto? genre) {
    setState(() {
      currentGenreFilter = genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BaseItemDto artist = widget.widgetArtist ??
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ArtistScreenContent(
            key: _contentKey,
            parent: artist,
            library: _finampUserHelper.currentUser?.currentView,
            genreFilter: currentGenreFilter,
            updateGenreFilter: updateGenreFilter,
          ),
        ),
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
