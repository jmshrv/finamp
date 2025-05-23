import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/l10n/app_localizations.dart';
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

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({
    super.key,
    this.parent,
  });

  static const routeName = "/music/album";

  /// The album to show. Can also be provided as an argument in a named route
  final BaseItemDto? parent;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  Future<List<List<BaseItemDto>?>>? albumScreenContentFuture;
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  SortBy? playlistSortBy;
  SortBy? currentPlaylistSortBy;
  SortOrder? currentPlaylistSortOrder;
  List<BaseItemDto>? sortedItems;
  List<BaseItemDto>? sortedPlayableItems;
  List<BaseItemDto>? playlistOriginalOrderItems;
  List<BaseItemDto>? playlistOriginalOrderPlayableItems;

  @override
  Widget build(BuildContext context) {
    final BaseItemDto parent = widget.parent ??
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Consumer(builder: (context, ref, _) {
          bool isOffline = ref.watch(finampSettingsProvider.isOffline);

          if (isOffline) {
            final downloadsService = GetIt.instance<DownloadsService>();
            // This is a pretty messy way to do this, but we already need both a
            // display list and a queue-able list inside AlbumScreenContent to deal
            // with multi-disc albums, so creating that distinction here seems fine.
            albumScreenContentFuture ??= Future.wait([
              downloadsService.getCollectionTracks(parent, playable: false),
              downloadsService.getCollectionTracks(parent, playable: true)
            ]);
          } else {
            if (albumScreenContentFuture == null) {
              var future = jellyfinApiHelper.getItems(
                parentItem: parent,
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
              );
              albumScreenContentFuture = Future.wait([future, future]);
            }
          }

          return FutureBuilder<List<List<BaseItemDto>?>>(
            future: albumScreenContentFuture,
            builder: (context, snapshot) {
              if (snapshot.data
                  case [
                    List<BaseItemDto> items,
                    List<BaseItemDto> playableItems
                  ]) {
                // Custom Playlist Sorting
                if (parent.type == "Playlist") {
                  // We cache the original order, so that we can restore it 
                  // without having to re-fetch the items
                  playlistOriginalOrderItems ??= List.from(items);
                  playlistOriginalOrderPlayableItems ??= List.from(playableItems);
                  // Get the currently active playlist sorting
                  SortBy playlistSortBySetting = ref.watch(finampSettingsProvider.playlistTracksSortBy);
                  SortOrder playlistSortOrder = ref.watch(finampSettingsProvider.playlistTracksSortOrder);
                  playlistSortBy = (isOffline && 
                      (playlistSortBySetting == SortBy.datePlayed || playlistSortBySetting == SortBy.playCount))
                    ? playlistSortBy = SortBy.serverOrder
                    : playlistSortBySetting;
                  // We only sort items at the beginning or when the setting has changed
                  if (playlistSortBy != currentPlaylistSortBy || 
                      playlistSortOrder != currentPlaylistSortOrder) {
                    currentPlaylistSortBy = playlistSortBy;
                    currentPlaylistSortOrder = playlistSortOrder;
                    if (playlistSortBy == SortBy.serverOrder) {
                      // Restore original server order
                      items = playlistOriginalOrderItems ?? items;
                      playableItems = playlistOriginalOrderPlayableItems ?? playableItems;
                      if (playlistSortOrder == SortOrder.descending) {
                        items = items.reversed.toList();
                        playableItems = playableItems.reversed.toList();
                      }
                    } else {
                      // Unfortunately, the Jellyfin API does not support "sortBy"
                      // for the "/Playlists/{playlistId}/Items" endpoint, so we 
                      // use our own sortItems function for both online and offline
                      items = sortItems(items, playlistSortBy, playlistSortOrder);
                      // We now have to re-create playableItems from the new items order, because
                      // if we would sort both separately, they would diverge for SortBy.random
                      final originalPlayableItems = List<BaseItemDto>.from(playableItems);
                      playableItems = [];
                      for (final item in items) {
                        final index = originalPlayableItems.indexWhere((p) => p.id == item.id);
                        if (index != -1) {
                          playableItems.add(item);
                          originalPlayableItems.removeAt(index);
                        }
                      }
                    }
                    // We cache the new order so that we can use it on rebuild
                    sortedItems = items;
                    sortedPlayableItems = playableItems;
                  } else {
                    // Use cached order
                    items = sortedItems ?? items;
                    playableItems = sortedPlayableItems ?? playableItems;
                  }
                }
                return AlbumScreenContent(
                    parent: parent,
                    displayChildren: items,
                    queueChildren: playableItems,
                    playlistSortBy: playlistSortBy);
              } else if (snapshot.hasError) {
                return PaddedCustomScrollview(
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      title: Text(AppLocalizations.of(context)!.error),
                    ),
                    SliverFillRemaining(
                      child: Center(child: Text(snapshot.error.toString())),
                    )
                  ],
                );
              } else {
                // We return all of this so that we can have an app bar while loading.
                // This is especially important for iOS, where there isn't a hardware back button.
                return PaddedCustomScrollview(
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
                );
              }
            },
          );
        }),
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
