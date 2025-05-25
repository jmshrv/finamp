import 'dart:async';

import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/MusicScreen/sort_by_menu_button.dart';
import 'package:finamp/components/MusicScreen/sort_order_button.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/album_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../Buttons/cta_medium.dart';
import '../favorite_button.dart';
import '../padded_custom_scrollview.dart';
import 'album_screen_content_flexible_space_bar.dart';
import 'download_button.dart';
import 'playlist_edit_button.dart';
import 'track_list_tile.dart';

typedef BaseItemDtoCallback = void Function(BaseItemDto item);

class AlbumScreenContent extends ConsumerStatefulWidget {
  const AlbumScreenContent({super.key, required this.parent, this.genreFilter});

  final BaseItemDto parent;
  final BaseItemDto? genreFilter;

  @override
  ConsumerState<AlbumScreenContent> createState() => _AlbumScreenContentState();
}

StreamSubscription<void>? _listener;

class _AlbumScreenContentState extends ConsumerState<AlbumScreenContent> {
  BaseItemDto? currentGenreFilter;

  @override
  void initState() {
    currentGenreFilter = widget.genreFilter;
    super.initState();
  }

  // Function to update the genre filter
  // Pass null in order to reset the filter
  void updateGenreFilter(BaseItemDto? genre) {
    setState(() {
      currentGenreFilter = genre;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listener?.cancel();
    _listener = null;
  }

  @override
  Widget build(BuildContext context) {
    final downloadStub = DownloadStub.fromItem(
        type: DownloadItemType.collection, item: widget.parent);
    final bool isOffline = ref.watch(finampSettingsProvider.isOffline);
    SortBy playlistSortBySetting =
        ref.watch(finampSettingsProvider.playlistTracksSortBy);
    final playlistSortBy = (isOffline &&
            (playlistSortBySetting == SortBy.datePlayed ||
                playlistSortBySetting == SortBy.playCount))
        ? SortBy.serverOrder
        : playlistSortBySetting;

    final tracksAsync = (widget.parent.type == "Playlist")
        ? ref.watch(getSortedPlaylistTracksProvider(widget.parent,
            genreFilter: currentGenreFilter))
        : ref.watch(getAlbumOrPlaylistTracksProvider(widget.parent));
    final (allTracks, playableTracks) = tracksAsync.valueOrNull ?? (null, null);
    final isLoading = allTracks == null;

    final displayChildren = allTracks ?? [];
    final queueChildren = playableTracks ?? [];

    void onDelete(BaseItemDto item) {
      // This is pretty inefficient (has to search through whole list) but
      // TracksSliverList gets passed some weird split version of children to
      // handle multi-disc albums and it's 00:35 so I can't be bothered to get
      // it to return an index
      setState(() {
        queueChildren.removeWhere((element) => element.id == item.id);
        displayChildren.removeWhere((element) => element.id == item.id);
      });
    }

    _listener?.cancel();
    _listener = musicScreenRefreshStream.stream.listen((_) {
      setState(() {});
    });

    List<List<BaseItemDto>> childrenPerDisc = [];
    // if not in playlist, try splitting up tracks by disc numbers
    // if first track has a disc number, let's assume the rest has it too
    if (widget.parent.type != "Playlist" &&
        displayChildren.isNotEmpty &&
        displayChildren[0].parentIndexNumber != null) {
      int? lastDiscNumber;
      for (var child in displayChildren) {
        if (child.parentIndexNumber != null &&
            child.parentIndexNumber != lastDiscNumber) {
          lastDiscNumber = child.parentIndexNumber;
          childrenPerDisc.add([]);
        }
        childrenPerDisc.last.add(child);
      }
    }

    return PaddedCustomScrollview(
      slivers: [
        SliverLayoutBuilder(builder: (context, constraints) {
          final actions = [
            if (widget.parent.type == "Playlist" &&
                !ref.watch(finampSettingsProvider.isOffline))
              PlaylistNameEditButton(playlist: widget.parent),
            if (widget.parent.type == "Playlist")
              SortOrderButton(
                tabType: TabContentType.tracks,
                forPlaylistTracks: true,
              ),
            if (widget.parent.type == "Playlist")
              SortByMenuButton(
                tabType: TabContentType.tracks,
                forPlaylistTracks: true,
              ),
            FavoriteButton(
              item: widget.parent,
            ),
            if (!isLoading)
              DownloadButton(
                item: downloadStub,
                children: displayChildren,
                downloadDisabled: (currentGenreFilter != null),
                customTooltip: (currentGenreFilter != null)
                    ? AppLocalizations.of(context)!
                        .downloadButtonDisabledGenreFilterTooltip
                    : null,
              ),
          ];

          return SliverAppBar(
            title: (widget.parent.type != "Playlist")
                ? Text(
                    widget.parent.name ??
                        AppLocalizations.of(context)!.unknownName,
                  )
                : null,
            expandedHeight:
                kToolbarHeight + 125 + 18 + CTAMedium.predictedHeight(context),
            // collapsedHeight: kToolbarHeight + 125 + 80,
            pinned: true,
            centerTitle: false,
            titleSpacing: 0,
            flexibleSpace: AlbumScreenContentFlexibleSpaceBar(
              parentItem: widget.parent,
              isPlaylist: widget.parent.type == "Playlist",
              items: queueChildren,
              genreFilter: currentGenreFilter,
              updateGenreFilter: updateGenreFilter,
            ),
            actions: actions,
          );
        }),
        if (!isLoading &&
            displayChildren.length > 1 &&
            childrenPerDisc.length >
                1) // show headers only for multi disc albums
          for (var childrenOfThisDisc in childrenPerDisc)
            SliverStickyHeader(
              header: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Text(
                  AppLocalizations.of(context)!
                      .discNumber(childrenOfThisDisc[0].parentIndexNumber!),
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              sliver: TracksSliverList(
                childrenForList: childrenOfThisDisc,
                childrenForQueue: Future.value(queueChildren),
                parent: widget.parent,
                onRemoveFromList: onDelete,
                showDateAdded: (widget.parent.type == "Playlist" &&
                    playlistSortBy == SortBy.dateCreated),
                showPlayCount: (widget.parent.type == "Playlist" &&
                    playlistSortBy == SortBy.playCount),
                showDateLastPlayed: (widget.parent.type == "Playlist" &&
                    playlistSortBy == SortBy.datePlayed),
                showReleaseDate: (widget.parent.type == "Playlist" &&
                    playlistSortBy == SortBy.premiereDate),
                forceAlbumArtists: (widget.parent.type == "Playlist" &&
                    playlistSortBy == SortBy.albumArtist),
              ),
            )
        else if (!isLoading && displayChildren.isNotEmpty)
          TracksSliverList(
            childrenForList: displayChildren,
            childrenForQueue: Future.value(queueChildren),
            parent: widget.parent,
            onRemoveFromList: onDelete,
            showDateAdded: (widget.parent.type == "Playlist" &&
                playlistSortBy == SortBy.dateCreated),
            showPlayCount: (widget.parent.type == "Playlist" &&
                playlistSortBy == SortBy.playCount),
            showDateLastPlayed: (widget.parent.type == "Playlist" &&
                playlistSortBy == SortBy.datePlayed),
            showReleaseDate: (widget.parent.type == "Playlist" &&
                playlistSortBy == SortBy.premiereDate),
            forceAlbumArtists: (widget.parent.type == "Playlist" &&
                playlistSortBy == SortBy.albumArtist),
          )
        else
          SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
      ],
    );
  }
}

class TracksSliverList extends ConsumerStatefulWidget {
  const TracksSliverList({
    super.key,
    required this.childrenForList,
    required this.childrenForQueue,
    required this.parent,
    this.onRemoveFromList,
    this.forceAlbumArtists = false,
    this.showPlayCount = false,
    this.showDateAdded = false,
    this.showDateLastPlayed = false,
    this.showReleaseDate = false,
    this.isOnArtistScreen = false,
    this.isOnGenreScreen = false,
  });

  final List<BaseItemDto> childrenForList;
  final Future<List<BaseItemDto>> childrenForQueue;
  final BaseItemDto parent;
  final BaseItemDtoCallback? onRemoveFromList;
  final bool forceAlbumArtists;
  final bool showPlayCount;
  final bool showDateAdded;
  final bool showDateLastPlayed;
  final bool showReleaseDate;
  final bool isOnArtistScreen;
  final bool isOnGenreScreen;

  @override
  ConsumerState<TracksSliverList> createState() => _TracksSliverListState();
}

class _TracksSliverListState extends ConsumerState<TracksSliverList> {
  final GlobalKey<SliverAnimatedListState> sliverListKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.childrenForList.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: Text(
            AppLocalizations.of(context)!.emptyTopTracksList,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return SliverFixedExtentList(
      itemExtent: TrackListItemTile.defaultTileHeight +
          TrackListItemTile.defaultTitleGap,
      // return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // When user selects track from disc other than first, index number is
          // incorrect and track with the same index on first disc is played instead.
          // Adding this offset ensures playback starts for nth track on correct disc.
          final indexOffset = widget.childrenForQueue.then((childrenForQueue) =>
              childrenForQueue.indexWhere(
                  (element) => element.id == widget.childrenForList[index].id));

          final BaseItemDto item = widget.childrenForList[index];

          BaseItemDto removeItem() {
            late BaseItemDto item;

            setState(() {
              item = widget.childrenForList.removeAt(index);
            });

            return item;
          }

          return TrackListTile(
            item: item,
            children: widget.childrenForQueue,
            index: indexOffset,
            showIndex: item.albumId == widget.parent.id,
            showCover: item.albumId != widget.parent.id ||
                ref.watch(finampSettingsProvider.showCoversOnAlbumScreen),
            parentItem: widget.parent,
            onRemoveFromList: () {
              final item = removeItem();
              if (widget.onRemoveFromList != null) {
                widget.onRemoveFromList!(item);
              }
            },
            isInPlaylist: widget.parent.type == "Playlist",
            isOnArtistScreen: widget.isOnArtistScreen,
            isOnGenreScreen: widget.isOnGenreScreen,
            forceAlbumArtists: widget.forceAlbumArtists,
            showPlayCount: widget.showPlayCount,
            showDateAdded: widget.showDateAdded,
            showDateLastPlayed: widget.showDateLastPlayed,
            showReleaseDate: widget.showReleaseDate,
          );
        },
        childCount: widget.childrenForList.length,
      ),
    );
  }
}
