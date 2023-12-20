import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:logging/logging.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../../components/favourite_button.dart';
import 'album_screen_content_flexible_space_bar.dart';
import 'download_button.dart';
import 'song_list_tile.dart';
import 'playlist_name_edit_button.dart';

typedef DeleteCallback = void Function(int index);

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
    void onDelete(int index) {
      setState(() {
        widget.children.removeAt(index);
      });
    }

    List<List<BaseItemDto>> childrenPerDisc = [];
    // if not in playlist, try splitting up tracks by disc numbers
    // if first track has a disc number, let's assume the rest has it too
    if (widget.parent.type != "Playlist" &&
        widget.children.isNotEmpty && widget.children[0].parentIndexNumber != null) {
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
            // 125 + 64 is the total height of the widget we use as a
            // FlexibleSpaceBar. We add the toolbar height since the widget
            // should appear below the appbar.
            // TODO: This height is affected by platform density.
            expandedHeight: kToolbarHeight + 125 + 64,
            pinned: true,
            flexibleSpace: AlbumScreenContentFlexibleSpaceBar(
              album: widget.parent,
              items: widget.children,
            ),
            actions: [
              if (widget.parent.type == "Playlist" &&
                  !FinampSettingsHelper.finampSettings.isOffline)
                PlaylistNameEditButton(playlist: widget.parent),
              FavoriteButton(item: widget.parent),
              DownloadButton(
                  item: DownloadStub.fromItem(
                      type: DownloadItemType.collectionDownload,
                      item: widget.parent))
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
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    AppLocalizations.of(context)!
                        .discNumber(childrenOfThisDisc[0].parentIndexNumber!),
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
                sliver: SongsSliverList(
                  childrenForList: childrenOfThisDisc,
                  childrenForQueue: widget.children,
                  parent: widget.parent,
                  onDelete: onDelete,
                ),
              )
          else if (widget.children.isNotEmpty)
            SongsSliverList(
              childrenForList: widget.children,
              childrenForQueue: widget.children,
              parent: widget.parent,
              onDelete: onDelete,
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
    this.onDelete,
  }) : super(key: key);

  final List<BaseItemDto> childrenForList;
  final List<BaseItemDto> childrenForQueue;
  final BaseItemDto parent;
  final DeleteCallback? onDelete;

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
    // When user selects song from disc other than first, index number is
    // incorrect and song with the same index on first disc is played instead.
    // Adding this offset ensures playback starts for nth song on correct disc.
    final int indexOffset =
        widget.childrenForQueue.indexOf(widget.childrenForList[0]);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
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
            children: widget.childrenForQueue,
            index: index + indexOffset,
            parentId: widget.parent.id,
            onDelete: () {
              final item = removeItem();
              if (widget.onDelete != null) {
                widget.onDelete!(index + indexOffset);
              }
            },
            isInPlaylist: widget.parent.type == "Playlist",
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
                        widget.parent.albumArtists?.map((e) => e.name).toSet(),
                        item.artists?.toSet())),
          );
        },
        childCount: widget.childrenForList.length,
      ),
    );
  }
}
