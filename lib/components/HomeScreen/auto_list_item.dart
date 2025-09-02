import 'package:finamp/components/AlbumScreen/track_list_tile.dart';
import 'package:finamp/components/MusicScreen/artist_item.dart';
import 'package:finamp/components/MusicScreen/item_collection_card.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutoListItem extends ConsumerWidget {
  final BaseItemDto baseItem;

  const AutoListItem({super.key, required this.baseItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget listItem;

    final BaseItemDtoType itemType = BaseItemDtoType.fromItem(baseItem);
    switch (itemType) {
      case BaseItemDtoType.album:
        listItem = ItemCollectionCard(
          key: ValueKey(baseItem.id),
          item: baseItem,
        );
        break;
      case BaseItemDtoType.playlist:
        listItem = ItemCollectionCard(
          key: ValueKey(baseItem.id),
          item: baseItem,
        );
        break;
      case BaseItemDtoType.artist:
        listItem = ArtistItem(
          key: ValueKey(baseItem.id),
          artist: baseItem,
          isGrid: false,
        );
        break;
      case BaseItemDtoType.track:
        listItem = TrackListTile(
          key: ValueKey(baseItem.id),
          item: baseItem,
          isTrack: true,
          index: 0,
          isShownInSearchOrHistory: false,
          allowDismiss: false,
        );
        break;
      case BaseItemDtoType.genre:
        listItem = ItemCollectionCard(
          key: ValueKey(baseItem.id),
          item: baseItem,
        );
        break;
      default:
        listItem = SizedBox.shrink();
    }

    return listItem;
  }
}
