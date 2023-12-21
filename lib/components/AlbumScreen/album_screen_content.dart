import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../../components/favourite_button.dart';
import 'album_screen_content_flexible_space_bar.dart';
import 'download_button.dart';
import 'song_list_tile.dart';
import 'playlist_name_edit_button.dart';

typedef BaseItemDtoCallback = void Function(BaseItemDto item);

class AlbumScreenContent extends StatefulWidget {
  const AlbumScreenContent({
    Key? key,
    required this.parent,
    required this.children,
  }) : super(key: key);

  final BaseItemDto parent;
  final List<BaseItemDto> children;

  @override
  State<AlbumScreenContent> createState() => _AlbumScreenContentState();
}

class _AlbumScreenContentState extends State<AlbumScreenContent> {
  @override
  Widget build(BuildContext context) {
    void onDelete(BaseItemDto item) {
      // This is pretty inefficient (has to search through whole list) but
      // SongsSliverList gets passed some weird split version of children to
      // handle multi-disc albums and it's 00:35 so I can't be bothered to get
      // it to return an index
      setState(() {
        widget.children.remove(item);
      });
    }

    List<List<BaseItemDto>> childrenPerDisc = [];
    // if not in playlist, try splitting up tracks by disc numbers
    // if first track has a disc number, let's assume the rest has it too
    if (widget.parent.type != "Playlist" &&
        widget.children[0].parentIndexNumber != null) {
      int? lastDiscNumber;
      for (var child in widget.children) {
        if (child.parentIndexNumber != null &&
            child.parentIndexNumber != lastDiscNumber) {
          lastDiscNumber = child.parentIndexNumber;
          childrenPerDisc.add([]);
        }
        childrenPerDisc.last.add(child);
      }
    }

    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(widget.parent.name ??
                AppLocalizations.of(context)!.unknownName),
            // 125 + 186 is the total height of the widget we use as a
            // FlexibleSpaceBar. We add the toolbar height since the widget
            // should appear below the appbar.
            // TODO: This height is affected by platform density.
            expandedHeight: kToolbarHeight + 125 + 186,
            pinned: true,
            flexibleSpace: AlbumScreenContentFlexibleSpaceBar(
              parentItem: widget.parent,
              isPlaylist: widget.parent.type == "Playlist",
              items: widget.children,
            ),
            actions: [
              if (widget.parent.type == "Playlist" &&
                  !FinampSettingsHelper.finampSettings.isOffline)
                PlaylistNameEditButton(playlist: widget.parent),
              FavoriteButton(item: widget.parent),
              DownloadButton(parent: widget.parent, items: widget.children)
            ],
          ),
          if (widget.children.length > 1 &&
              childrenPerDisc.length >
                  1) // show headers only for multi disc albums
            for (var childrenOfThisDisc in childrenPerDisc)
              SliverStickyHeader(
                header: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Text(
                    AppLocalizations.of(context)!
                        .discNumber(childrenOfThisDisc[0].parentIndexNumber!),
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
                sliver: SongsSliverList(
                  childrenForList: childrenOfThisDisc,
                  childrenForQueue: Future.value(widget.children),
                  parent: widget.parent,
                  onRemoveFromList: onDelete,
                ),
              )
          else if (widget.children.isNotEmpty)
            SongsSliverList(
              childrenForList: widget.children,
              childrenForQueue: Future.value(widget.children),
              parent: widget.parent,
              onRemoveFromList: onDelete,
            ),
        ],
      ),
    );
  }
}

class SongsSliverList extends StatefulWidget {
  const SongsSliverList({
    Key? key,
    required this.childrenForList,
    required this.childrenForQueue,
    required this.parent,
    this.onRemoveFromList,
    this.showPlayCount = false,
    this.isOnArtistScreen = false,
  }) : super(key: key);

  final List<BaseItemDto> childrenForList;
  final Future<List<BaseItemDto>> childrenForQueue;
  final BaseItemDto parent;
  final BaseItemDtoCallback? onRemoveFromList;
  final bool showPlayCount;
  final bool isOnArtistScreen;

  @override
  State<SongsSliverList> createState() => _SongsSliverListState();
}

class _SongsSliverListState extends State<SongsSliverList> {
  final GlobalKey<SliverAnimatedListState> sliverListKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // When user selects song from disc other than first, index number is
          // incorrect and song with the same index on first disc is played instead.
          // Adding this offset ensures playback starts for nth song on correct disc.
          final indexOffset = widget.parent.type == "MusicAlbum"
              ? widget.childrenForQueue.then((childrenForQueue) =>
                  childrenForQueue.indexOf(widget.childrenForList[0]))
              : Future.value(0);

          final BaseItemDto item = widget.childrenForList[index];

          BaseItemDto removeItem() {
            late BaseItemDto item;

            setState(() {
              item = widget.childrenForList.removeAt(index);
            });

            return item;
          }

          return SongListTile(
            item: item,
            childrenFuture: widget.childrenForQueue,
            indexFuture: indexOffset.then((offset) => offset + index),
            parentItem: widget.parent,
            onRemoveFromList: () {
              final item = removeItem();
              if (widget.onRemoveFromList != null) {
                widget.onRemoveFromList!(item);
              }
            },
            isInPlaylist: widget.parent.type == "Playlist",
            isOnArtistScreen: widget.isOnArtistScreen,
            // show artists except for this one scenario
            showArtists: !(
                    // we're on album screen
                    widget.parent.type == "MusicAlbum"
                        // "hide song artists if they're the same as album artists" == true
                        &&
                        FinampSettingsHelper
                            .finampSettings.hideSongArtistsIfSameAsAlbumArtists
                        // song artists == album artists
                        &&
                        setEquals(
                            widget.parent.albumArtists
                                ?.map((e) => e.name)
                                .toSet(),
                            item.artists?.toSet()))
                // hide song artist if on the artist screen
                &&
                widget.parent.type != "MusicArtist",
            showPlayCount: widget.showPlayCount,
          );
        },
        childCount: widget.childrenForList.length,
      ),
    );
  }
}
