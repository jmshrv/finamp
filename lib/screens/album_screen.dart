import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/album_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../components/AlbumScreen/album_screen_content.dart';
import '../components/now_playing_bar.dart';
import '../components/padded_custom_scrollview.dart';
import '../models/jellyfin_models.dart';
import '../services/downloads_service.dart';
import '../services/finamp_settings_helper.dart';
import '../services/jellyfin_api_helper.dart';
import '../services/music_player_background_task.dart';

class AlbumScreen extends ConsumerStatefulWidget {
  const AlbumScreen({
    super.key,
    this.parent,
  });

  static const routeName = "/music/album";

  /// The album to show. Can also be provided as an argument in a named route
  final BaseItemDto? parent;

  @override
  ConsumerState<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen> {
  Future<List<List<BaseItemDto>?>>? albumScreenContentFuture;
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  @override
  Widget build(BuildContext context) {
    final BaseItemDto parent = widget.parent ??
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;
    
    final tracksAsync = (parent.type == "Playlist")
      ? ref.watch(getSortedPlaylistTracksProvider(parent))
      : ref.watch(getAlbumOrPlaylistTracksProvider(parent));
    final (allTracks, playableTracks) = tracksAsync.valueOrNull ?? (null, null);
    final isLoading = allTracks == null;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: !isLoading 
          ? AlbumScreenContent(
              parent: parent,
              displayChildren: allTracks,
              queueChildren: playableTracks ?? []
            )
          : PaddedCustomScrollview(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  titleSpacing: 0,
                  title: Text(parent.name ??
                      AppLocalizations.of(context)!.unknownName),
                ),
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              ],
            ),
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
