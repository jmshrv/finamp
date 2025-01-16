import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../components/favourite_button.dart';
import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../padded_custom_scrollview.dart';
import 'album_screen_content_flexible_space_bar.dart';
import 'download_button.dart';
import 'playlist_name_edit_button.dart';
import 'track_list_tile.dart';

typedef BaseItemDtoCallback = void Function(BaseItemDto item);

class AlbumScreenContent extends StatefulWidget {
  const AlbumScreenContent({
    super.key,
    required this.parent,
    required this.displayChildren,
    required this.queueChildren,
  });

  final BaseItemDto parent;
  final List<BaseItemDto> displayChildren;
  final List<BaseItemDto> queueChildren;

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
        widget.queueChildren.removeWhere((element) => element.id == item.id);
        widget.displayChildren.removeWhere((element) => element.id == item.id);
      });
    }

    List<List<BaseItemDto>> childrenPerDisc = [];
    // if not in playlist, try splitting up tracks by disc numbers
    // if first track has a disc number, let's assume the rest has it too
    if (widget.parent.type != "Playlist" &&
        widget.displayChildren.isNotEmpty &&
        widget.displayChildren[0].parentIndexNumber != null) {
      int? lastDiscNumber;
      for (var child in widget.displayChildren) {
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
        SliverAppBar(
          title: Text(
              widget.parent.name ?? AppLocalizations.of(context)!.unknownName),
          // 125 + 64 is the total height of the widget we use as a
          // FlexibleSpaceBar. We add the toolbar height since the widget
          // should appear below the appbar.
          // TODO: This height is affected by platform density.
          expandedHeight: kToolbarHeight + 125 + 80,
          // collapsedHeight: kToolbarHeight + 125 + 80,
          pinned: true,
          flexibleSpace: AlbumScreenContentFlexibleSpaceBar(
            parentItem: widget.parent,
            isPlaylist: widget.parent.type == "Playlist",
            items: widget.queueChildren,
          ),
          actions: [
            if (widget.parent.type == "Playlist" &&
                !FinampSettingsHelper.finampSettings.isOffline)
              PlaylistNameEditButton(playlist: widget.parent),
            FavoriteButton(item: widget.parent),
            DownloadButton(
                item: DownloadStub.fromItem(
                    type: DownloadItemType.collection, item: widget.parent),
                children: widget.displayChildren.length)
          ],
        ),
        if (widget.displayChildren.length > 1 &&
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
                childrenForQueue: Future.value(widget.queueChildren),
                parent: widget.parent,
                onRemoveFromList: onDelete,
              ),
            )
        else if (widget.displayChildren.isNotEmpty)
          SongsSliverList(
            childrenForList: widget.displayChildren,
            childrenForQueue: Future.value(widget.queueChildren),
            parent: widget.parent,
            onRemoveFromList: onDelete,
          )
      ],
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
          // When user selects song from disc other than first, index number is
          // incorrect and song with the same index on first disc is played instead.
          // Adding this offset ensures playback starts for nth song on correct disc.
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
                FinampSettingsHelper.finampSettings.showCoversOnAlbumScreen,
            parentItem: widget.parent,
            onRemoveFromList: () {
              final item = removeItem();
              if (widget.onRemoveFromList != null) {
                widget.onRemoveFromList!(item);
              }
            },
            isInPlaylist: widget.parent.type == "Playlist",
            isOnArtistScreen: widget.isOnArtistScreen,
            showPlayCount: widget.showPlayCount,
          );
        },
        childCount: widget.childrenForList.length,
      ),
    );
  }
}
