import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../screens/album_screen.dart';
import 'AlbumScreen/downloaded_indicator.dart';
import 'favourite_button.dart';
import 'album_image.dart';
import 'print_duration.dart';
import 'error_snackbar.dart';

enum AlbumListTileMenuItems {
  addFavourite,
  removeFavourite,
  addToMixList,
  removeFromMixList,
  playNext,
  addToNextUp,
  shuffleNext,
  shuffleToNextUp,
  addToQueue,
  shuffleToQueue,
}

class AlbumListTile extends StatefulWidget {
  const AlbumListTile(
      {Key? key,
      required this.item,

      /// Children that are related to this list tile, such as the other songs in
      /// the album. This is used to give the audio service all the songs for the
      /// item. If null, only this song will be given to the audio service.
      this.children,

      /// Index of the song in whatever parent this widget is in. Used to start
      /// the audio service at a certain index, such as when selecting the middle
      /// song in an album.
      this.index,
      this.parentId,
      this.parentName})
      : super(key: key);

  final BaseItemDto item;
  final List<BaseItemDto>? children;
  final int? index;
  final String? parentId;
  final String? parentName;

  @override
  State<AlbumListTile> createState() => _AlbumListTileState();
}

class _AlbumListTileState extends State<AlbumListTile> {
  final _queueService = GetIt.instance<QueueService>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final listTile = ListTile(
      leading: AlbumImage(item: widget.item),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text:
                  widget.item.name ?? AppLocalizations.of(context)!.unknownName,
            ),
          ],
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(-3, 0),
                child: DownloadedIndicator(
                  item: widget.item,
                  size: Theme.of(context).textTheme.bodyMedium!.fontSize! + 3,
                ),
              ),
              alignment: PlaceholderAlignment.top,
            ),
            TextSpan(
              text: widget.item.productionYearString,
              style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.7)),
            ),
            TextSpan(
              text:
                  " · ${printDuration(Duration(microseconds: (widget.item.runTimeTicks == null ? 0 : widget.item.runTimeTicks! ~/ 10)))}",
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: FavoriteButton(
        item: widget.item,
        onlyIfFav: true,
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(AlbumScreen.routeName, arguments: widget.item);
      },
    );

    return GestureDetector(
        onLongPressStart: (details) async {
          Feedback.forLongPress(context);

          final selection = await showMenu<AlbumListTileMenuItems>(
            context: context,
            position: RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              screenSize.width - details.globalPosition.dx,
              screenSize.height - details.globalPosition.dy,
            ),
            items: [
              widget.item.userData!.isFavorite
                  ? PopupMenuItem<AlbumListTileMenuItems>(
                      value: AlbumListTileMenuItems.removeFavourite,
                      child: ListTile(
                        leading: const Icon(Icons.favorite_border),
                        title:
                            Text(AppLocalizations.of(context)!.removeFavourite),
                      ),
                    )
                  : PopupMenuItem<AlbumListTileMenuItems>(
                      value: AlbumListTileMenuItems.addFavourite,
                      child: ListTile(
                        leading: const Icon(Icons.favorite),
                        title: Text(AppLocalizations.of(context)!.addFavourite),
                      ),
                    ),
              _jellyfinApiHelper.selectedMixAlbums.contains(widget.item)
                  ? PopupMenuItem<AlbumListTileMenuItems>(
                      value: AlbumListTileMenuItems.removeFromMixList,
                      child: ListTile(
                        leading: const Icon(Icons.explore_off),
                        title:
                            Text(AppLocalizations.of(context)!.removeFromMix),
                      ),
                    )
                  : PopupMenuItem<AlbumListTileMenuItems>(
                      value: AlbumListTileMenuItems.addToMixList,
                      child: ListTile(
                        leading: const Icon(Icons.explore),
                        title: Text(AppLocalizations.of(context)!.addToMix),
                      ),
                    ),
              if (_queueService.getQueue().nextUp.isNotEmpty)
                PopupMenuItem<AlbumListTileMenuItems>(
                  value: AlbumListTileMenuItems.playNext,
                  child: ListTile(
                    leading: const Icon(Icons.hourglass_bottom),
                    title: Text(AppLocalizations.of(context)!.playNext),
                  ),
                ),
              PopupMenuItem<AlbumListTileMenuItems>(
                value: AlbumListTileMenuItems.addToNextUp,
                child: ListTile(
                  leading: const Icon(Icons.hourglass_top),
                  title: Text(AppLocalizations.of(context)!.addToNextUp),
                ),
              ),
              if (_queueService.getQueue().nextUp.isNotEmpty)
                PopupMenuItem<AlbumListTileMenuItems>(
                  value: AlbumListTileMenuItems.shuffleNext,
                  child: ListTile(
                    leading: const Icon(Icons.hourglass_bottom),
                    title: Text(AppLocalizations.of(context)!.shuffleNext),
                  ),
                ),
              PopupMenuItem<AlbumListTileMenuItems>(
                value: AlbumListTileMenuItems.shuffleToNextUp,
                child: ListTile(
                  leading: const Icon(Icons.hourglass_top),
                  title: Text(AppLocalizations.of(context)!.shuffleToNextUp),
                ),
              ),
              PopupMenuItem<AlbumListTileMenuItems>(
                value: AlbumListTileMenuItems.addToQueue,
                child: ListTile(
                  leading: const Icon(Icons.queue_music),
                  title: Text(AppLocalizations.of(context)!.addToQueue),
                ),
              ),
              PopupMenuItem<AlbumListTileMenuItems>(
                value: AlbumListTileMenuItems.shuffleToQueue,
                child: ListTile(
                  leading: const Icon(Icons.queue_music),
                  title: Text(AppLocalizations.of(context)!.shuffleToQueue),
                ),
              ),
            ],
          );

          if (!mounted) return;

          switch (selection) {
            case AlbumListTileMenuItems.addFavourite:
              try {
                final newUserData =
                    await _jellyfinApiHelper.addFavourite(widget.item.id);

                if (!mounted) return;

                setState(() {
                  widget.item.userData = newUserData;
                });
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case AlbumListTileMenuItems.removeFavourite:
              try {
                final newUserData =
                    await _jellyfinApiHelper.removeFavourite(widget.item.id);

                if (!mounted) return;

                setState(() {
                  widget.item.userData = newUserData;
                });
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case AlbumListTileMenuItems.addToMixList:
              try {
                _jellyfinApiHelper.addAlbumToMixBuilderList(widget.item);
                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case AlbumListTileMenuItems.removeFromMixList:
              try {
                _jellyfinApiHelper.removeAlbumFromMixBuilderList(widget.item);
                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case AlbumListTileMenuItems.playNext:
              try {
                List<BaseItemDto>? albumTracks =
                    await _jellyfinApiHelper.getItems(
                  parentItem: widget.item,
                  isGenres: false,
                  sortBy: "ParentIndexNumber,IndexNumber,SortName",
                  includeItemTypes: "Audio",
                );

                if (albumTracks == null) {
                  _displayCouldNotLoadAlbumWarning(context);
                  return;
                }

                _queueService.addNext(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName: widget.item.name ??
                              AppLocalizations.of(context)!.placeholderSource),
                      id: widget.item.id,
                      item: widget.item,
                    ));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        AppLocalizations.of(context)!.confirmPlayNext("album")),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case AlbumListTileMenuItems.addToNextUp:
              try {
                List<BaseItemDto>? albumTracks =
                    await _jellyfinApiHelper.getItems(
                  parentItem: widget.item,
                  isGenres: false,
                  sortBy: "ParentIndexNumber,IndexNumber,SortName",
                  includeItemTypes: "Audio",
                );

                if (albumTracks == null) {
                  _displayCouldNotLoadAlbumWarning(context);
                  return;
                }

                _queueService.addToNextUp(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName: widget.item.name ??
                              AppLocalizations.of(context)!.placeholderSource),
                      id: widget.item.id,
                      item: widget.item,
                    ));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .confirmAddToNextUp("album")),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case AlbumListTileMenuItems.shuffleNext:
              try {
                List<BaseItemDto>? albumTracks =
                    await _jellyfinApiHelper.getItems(
                  parentItem: widget.item,
                  isGenres: false,
                  sortBy: "Random",
                  includeItemTypes: "Audio",
                );

                if (albumTracks == null) {
                  _displayCouldNotLoadAlbumWarning(context);
                  return;
                }

                _queueService.addNext(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName: widget.item.name ??
                              AppLocalizations.of(context)!.placeholderSource),
                      id: widget.item.id,
                      item: widget.item,
                    ));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        AppLocalizations.of(context)!.confirmPlayNext("album")),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case AlbumListTileMenuItems.shuffleToNextUp:
              try {
                List<BaseItemDto>? albumTracks =
                    await _jellyfinApiHelper.getItems(
                  parentItem: widget.item,
                  isGenres: false,
                  sortBy:
                      "Random", //TODO this isn't working anymore with Jellyfin 10.9 (unstable)
                  includeItemTypes: "Audio",
                );

                if (albumTracks == null) {
                  _displayCouldNotLoadAlbumWarning(context);
                  return;
                }

                _queueService.addToNextUp(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName: widget.item.name ??
                              AppLocalizations.of(context)!.placeholderSource),
                      id: widget.item.id,
                      item: widget.item,
                    ));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        AppLocalizations.of(context)!.confirmShuffleToNextUp),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case AlbumListTileMenuItems.addToQueue:
              try {
                List<BaseItemDto>? albumTracks =
                    await _jellyfinApiHelper.getItems(
                  parentItem: widget.item,
                  isGenres: false,
                  sortBy: "ParentIndexNumber,IndexNumber,SortName",
                  includeItemTypes: "Audio",
                );

                if (albumTracks == null) {
                  _displayCouldNotLoadAlbumWarning(context);
                  return;
                }

                _queueService.addToQueue(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName: widget.item.name ??
                              AppLocalizations.of(context)!.placeholderSource),
                      id: widget.item.id,
                      item: widget.item,
                    ));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .confirmAddToQueue("album")),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case AlbumListTileMenuItems.shuffleToQueue:
              try {
                List<BaseItemDto>? albumTracks =
                    await _jellyfinApiHelper.getItems(
                  parentItem: widget.item,
                  isGenres: false,
                  sortBy: "Random",
                  includeItemTypes: "Audio",
                );

                if (albumTracks == null) {
                  _displayCouldNotLoadAlbumWarning(context);
                  return;
                }

                _queueService.addToQueue(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName: widget.item.name ??
                              AppLocalizations.of(context)!.placeholderSource),
                      id: widget.item.id,
                      item: widget.item,
                    ));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .confirmAddToQueue("album")),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            default:
              break;
          }
        },
        child: listTile);
  }

  void _displayCouldNotLoadAlbumWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.couldNotLoad("album")),
      ),
    );
  }
}
