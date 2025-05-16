import 'package:finamp/components/MusicScreen/collection_item.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/jellyfin_models.dart';

class CollectionsSliverList extends ConsumerStatefulWidget {
  const CollectionsSliverList({
    super.key,
    required this.childrenForList,
    required this.parent,
    this.genreFilter,
    this.albumShowsYearAndDurationInstead = false,
  });

  final List<BaseItemDto> childrenForList;
  final BaseItemDto parent;
  final BaseItemDto? genreFilter;
  final bool albumShowsYearAndDurationInstead;

  @override
  ConsumerState<CollectionsSliverList> createState() => _ItemsSliverListState();
}

class _ItemsSliverListState extends ConsumerState<CollectionsSliverList> {
  final GlobalKey<SliverAnimatedListState> sliverListKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filterArtistScreens = ref.watch(finampSettingsProvider.genreFilterArtistScreens);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final BaseItemDto item = widget.childrenForList[index];
          final itemType = BaseItemDtoType.fromItem(item);
          return CollectionItem(
            key: ValueKey(item.id),
            item: item,
            isPlaylist: false,
            genreFilter: (itemType == BaseItemDtoType.artist && filterArtistScreens) ? widget.genreFilter : null,
            albumShowsYearAndDurationInstead: widget.albumShowsYearAndDurationInstead,
          );
        },
        childCount: widget.childrenForList.length,
      ),
    );
  }
}
