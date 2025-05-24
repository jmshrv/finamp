import 'package:finamp/components/PlayerScreen/album_chip.dart';
import 'package:finamp/components/PlayerScreen/artist_chip.dart';
import 'package:finamp/components/PlayerScreen/item_amount_chip.dart';
import 'package:finamp/components/album_image.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final double infoHeaderFullHeight = 120.0;
final double infoHeaderCondensedHeight = 80.0;

class MenuItemInfoHeader extends SliverPersistentHeaderDelegate {
  BaseItemDto item;

  MenuItemInfoHeader({
    required this.item,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return switch (BaseItemDtoType.fromItem(item)) {
      BaseItemDtoType.track => TrackInfo(
          item: item,
        ),
      BaseItemDtoType.album => AlbumInfo(
          //TODO don't show parent album
          item: item,
        ),
      BaseItemDtoType.playlist => AlbumInfo(
          //TODO show track count instead of artist+album info
          item: item,
        ),
      BaseItemDtoType.genre => ArtistInfo(
          item: item,
        ),
      BaseItemDtoType.artist => ArtistInfo(
          item: item,
        ),
      _ => TrackInfo(
          item: item,
        ),
    };
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 150;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class TrackInfo extends ConsumerWidget {
  const TrackInfo({
    super.key,
    required this.item,
  }) : condensed = false;

  const TrackInfo.condensed({
    super.key,
    required this.item,
  }) : condensed = true;

  final BaseItemDto item;
  final bool condensed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ItemInfo(
      item: item,
      condensed: condensed,
    );
  }
}

class AlbumInfo extends ConsumerWidget {
  const AlbumInfo({
    super.key,
    required this.item,
  }) : condensed = false;

  const AlbumInfo.condensed({
    super.key,
    required this.item,
  }) : condensed = true;

  final BaseItemDto item;
  final bool condensed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ItemInfo(
      item: item,
      condensed: condensed,
    );
  }
}

class ArtistInfo extends ConsumerStatefulWidget {
  const ArtistInfo({
    super.key,
    required this.item,
  }) : condensed = false;

  const ArtistInfo.condensed({
    super.key,
    required this.item,
  }) : condensed = true;

  final BaseItemDto item;
  final bool condensed;

  @override
  ConsumerState createState() => _ArtistInfoState();
}

class ItemInfo extends ConsumerStatefulWidget {
  const ItemInfo({
    super.key,
    required this.item,
    required this.condensed,
  });

  final BaseItemDto item;
  final bool condensed;

  @override
  ConsumerState createState() => _ItemInfoState();
}

class _ItemInfoState extends ConsumerState<ItemInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: widget.condensed ? 28.0 : 12.0),
          height: widget.condensed
              ? infoHeaderCondensedHeight
              : infoHeaderFullHeight,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.25)
                : Colors.white.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: AlbumImage(
                  item: widget.item,
                  borderRadius: BorderRadius.zero,
                  tapToZoom: true,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.item.name ??
                            AppLocalizations.of(context)!.unknownName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: widget.condensed ? 16 : 18,
                          height: 1.2,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                      ),
                      Padding(
                        padding: widget.condensed
                            ? const EdgeInsets.only(top: 6.0)
                            : const EdgeInsets.symmetric(vertical: 4.0),
                        child: ArtistChips(
                          baseItem: widget.item,
                          backgroundColor: IconTheme.of(context)
                                  .color
                                  ?.withOpacity(0.1) ??
                              Theme.of(context).textTheme.bodyMedium?.color ??
                              Colors.white,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  Colors.white,
                        ),
                      ),
                      if (!widget.condensed)
                        AlbumChips(
                          baseItem: widget.item,
                          backgroundColor: IconTheme.of(context)
                                  .color
                                  ?.withOpacity(0.1) ??
                              Theme.of(context).textTheme.bodyMedium?.color ??
                              Colors.white,
                          key: widget.item.album == null
                              ? null
                              : ValueKey("${widget.item.album}-album"),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArtistInfoState extends ConsumerState<ArtistInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: widget.condensed ? 28.0 : 12.0),
          height: widget.condensed
              ? infoHeaderCondensedHeight
              : infoHeaderFullHeight,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.25)
                : Colors.white.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(9999),
                  bottomLeft: Radius.circular(9999),
                  // circular radii influence each other. this should look roughly the same as BorderRadius.circular(12)
                  topRight: Radius.circular(2000),
                  bottomRight: Radius.circular(2000)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: AlbumImage(
                  item: widget.item,
                  borderRadius: BorderRadius.circular(9999),
                  tapToZoom: true,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.item.name ??
                            AppLocalizations.of(context)!.unknownName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: widget.condensed ? 16 : 18,
                          height: 1.2,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      if (!widget.condensed)
                        ItemAmountChip(
                          baseItem: widget
                              .item, //FIXME fetch extended item when menu is opened to include BaseItemDto.albumCount
                          backgroundColor: IconTheme.of(context)
                                  .color
                                  ?.withOpacity(0.1) ??
                              Theme.of(context).textTheme.bodyMedium?.color ??
                              Colors.white,
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
