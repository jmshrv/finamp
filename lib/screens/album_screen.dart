import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../components/AlbumScreen/album_screen_content.dart';
import '../components/now_playing_bar.dart';
import '../models/jellyfin_models.dart';
import '../services/jellyfin_api_helper.dart';
import '../services/music_player_background_task.dart';

class AlbumScreen extends ConsumerStatefulWidget {
  const AlbumScreen({super.key, this.parent, this.genreFilter});

  static const routeName = "/music/album";

  /// The album to show. Can also be provided as an argument in a named route
  final BaseItemDto? parent;

  // The genreFilter to apply
  final BaseItemDto? genreFilter;

  @override
  ConsumerState<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen> {
  Future<List<List<BaseItemDto>?>>? albumScreenContentFuture;
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  @override
  Widget build(BuildContext context) {
    final BaseItemDto parent = widget.parent ?? ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: AlbumScreenContent(parent: parent, genreFilter: widget.genreFilter),
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
