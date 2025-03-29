import 'package:finamp/components/AlbumScreen/track_list_tile.dart';
import 'package:finamp/components/MusicScreen/album_item.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutoGridItem extends ConsumerWidget {
  final BaseItemDto baseItem;

  const AutoGridItem({super.key, required this.baseItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget gridItem;

    final BaseItemDtoType itemType = BaseItemDtoType.fromItem(baseItem);
    switch (itemType) {
      case BaseItemDtoType.album:
        gridItem = AlbumItem(
          key: ValueKey(baseItem.id),
          album: baseItem,
          isPlaylist: false,
          isGrid: true,
          gridAddSettingsListener: false,
        );
        break;
      case BaseItemDtoType.playlist:
        gridItem = AlbumItem(
          key: ValueKey(baseItem.id),
          album: baseItem,
          isPlaylist: true,
          isGrid: true,
          gridAddSettingsListener: false,
        );
        break;
      case BaseItemDtoType.artist:
        gridItem = AlbumItem(
          key: ValueKey(baseItem.id),
          album: baseItem,
          isPlaylist: false,
          isGrid: true,
          gridAddSettingsListener: false,
        );
        break;
      case BaseItemDtoType.track:
        gridItem = TrackListTile(
          key: ValueKey(baseItem.id),
          item: baseItem,
          isTrack: true,
          index: Future.value(0),
          isShownInSearch: false,
          allowDismiss: false,
        );
        break;
      case BaseItemDtoType.genre:
        gridItem = AlbumItem(
          key: ValueKey(baseItem.id),
          album: baseItem,
          isPlaylist: false,
          isGrid: true,
          gridAddSettingsListener: false,
        );
        break;
      default:
        gridItem = SizedBox.shrink();
    }

    return SizedBox(
      width: 120,
      height: 120,
      child: gridItem,
    );
  }
}
