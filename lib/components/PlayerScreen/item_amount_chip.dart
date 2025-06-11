import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/artist_content_provider.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

final _borderRadius = BorderRadius.circular(4);

class ItemAmountChip extends ConsumerStatefulWidget {
  const ItemAmountChip({
    required this.baseItem,
    this.backgroundColor,
    this.color,
    super.key,
  });

  final BaseItemDto baseItem;
  final Color? backgroundColor;
  final Color? color;

  @override
  ConsumerState<ItemAmountChip> createState() => _ItemAmountChipState();
}

class _ItemAmountChipState extends ConsumerState<ItemAmountChip> {
  bool showTrackCountForArtists =
      FinampSettingsHelper.finampSettings.artistListType == ArtistType.artist;
  
@override
  Widget build(BuildContext context) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final downloadsService = GetIt.instance<DownloadsService>();
    final library = GetIt.instance<FinampUserHelper>().currentUser?.currentView;
    final isOffline = ref.watch(finampSettingsProvider.isOffline);

    final itemType = BaseItemDtoType.fromItem(widget.baseItem);

    final Future<int> itemCountFuture = switch (itemType) {
      BaseItemDtoType.album => Future.value(widget.baseItem.childCount ?? 0),
      BaseItemDtoType.artist => isOffline
          ? ref
              .read(getArtistAlbumsProvider(widget.baseItem, library, null)
                  .future)
              .then((albums) => albums.length)
          : (showTrackCountForArtists
              ? jellyfinApiHelper
                  .getItemsWithTotalRecordCount(
                      libraryFilter: library,
                      parentItem: widget.baseItem,
                      includeItemTypes: BaseItemDtoType.track.idString,
                      limit: 1,
                      artistType: ArtistType.artist)
                  .then((fetchedItems) => fetchedItems.totalRecordCount)
              : jellyfinApiHelper
                  .getItemsWithTotalRecordCount(
                      libraryFilter: library,
                      parentItem: widget.baseItem,
                      includeItemTypes: BaseItemDtoType.album.idString,
                      limit: 1,
                      artistType: ArtistType.albumartist)
                  .then((fetchedItems) => fetchedItems.totalRecordCount)),
      BaseItemDtoType.genre => isOffline
          ? downloadsService
              .getAllCollections(
                  baseTypeFilter: BaseItemDtoType.album,
                  fullyDownloaded:
                      ref.watch(finampSettingsProvider.onlyShowFullyDownloaded),
                  viewFilter: library?.id,
                  nullableViewFilters: ref.watch(
                      finampSettingsProvider.showDownloadsWithUnknownLibrary),
                  genreFilter: widget.baseItem)
              .then((fetchedItems) =>
                  fetchedItems.map((e) => e.baseItem).nonNulls.length)
          : jellyfinApiHelper
              .getItemsWithTotalRecordCount(
                parentItem: library,
                genreFilter: widget.baseItem,
                limit: 1,
                includeItemTypes: "MusicAlbum",
              )
              .then((fetchedItems) => fetchedItems.totalRecordCount),
      BaseItemDtoType.playlist => Future.value(widget.baseItem.childCount ?? 0),
      _ => Future.value(widget.baseItem.childCount ?? 0),
    };

    final childItemType = switch (itemType) {
      BaseItemDtoType.album => BaseItemDtoType.track,
      BaseItemDtoType.artist => showTrackCountForArtists
          ? BaseItemDtoType.track
          : BaseItemDtoType.album,
      BaseItemDtoType.genre => BaseItemDtoType.album,
      BaseItemDtoType.playlist => BaseItemDtoType.track,
      _ => BaseItemDtoType.unknown,
    };

    
    return FutureBuilder(
        future: itemCountFuture,
        builder: (context, asyncSnapshot) {
          final itemCount = asyncSnapshot.data;
          if (itemType == BaseItemDtoType.artist && itemCount == 0) {
            showTrackCountForArtists = true;
          }
          return Semantics.fromProperties(
            properties: SemanticsProperties(
              label: itemCount != null
                  ? AppLocalizations.of(context)!
                      .itemCount(childItemType.name, itemCount)
                  : AppLocalizations.of(context)!.itemCountCalculating,
              button: true,
            ),
            excludeSemantics: true,
            container: true,
            child: Material(
              color: widget.backgroundColor ?? Colors.white.withOpacity(0.1),
              borderRadius: _borderRadius,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4.0,
                    children: [
                      if (itemCount == null)
                        CircularProgressIndicator(
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                            maxWidth: 16,
                            maxHeight: 16,
                          ),
                          padding: const EdgeInsets.all(2.0),
                          color: widget.color ??
                              Theme.of(context).textTheme.bodySmall!.color ??
                              Colors.white,
                          strokeWidth: 2.0,
                        ),
                      Text(
                        itemCount != null
                            ? AppLocalizations.of(context)!
                                .itemCount(childItemType.name, itemCount)
                            : AppLocalizations.of(context)!
                                .itemCountLoading(childItemType.name),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          color: widget.color ??
                              Theme.of(context).textTheme.bodySmall!.color ??
                              Colors.white,
                        ),
                      )
                    ],
                  )
              ),
            ),
          );
        }
    );
  }
}
