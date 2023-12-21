import 'package:finamp/components/MusicScreen/album_item_list_tile.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/downloads_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../screens/artist_screen.dart';
import '../../screens/album_screen.dart';
import '../error_snackbar.dart';
import 'album_item_card.dart';

enum _AlbumListTileMenuItems {
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

/// This widget is kind of a shell around AlbumItemCard and AlbumItemListTile.
/// Depending on the values given, a list tile or a card will be returned. This
/// widget exists to handle the dropdown stuff and other stuff shared between
/// the two widgets.
class AlbumItem extends StatefulWidget {
  const AlbumItem({
    Key? key,
    required this.album,
    required this.isPlaylist,
    this.parentType,
    this.onTap,
    this.isGrid = false,
    this.gridAddSettingsListener = false,
  }) : super(key: key);

  /// The album (or item, I just used to call items albums before Finamp
  /// supported other types) to show in the widget.
  final BaseItemDto album;

  /// The parent type of the item. Used to change onTap functionality for stuff
  /// like artists.
  final String? parentType;

  /// Used to differentiate between albums and playlists, since they use the same internal logic and widgets
  final bool isPlaylist;

  /// A custom onTap can be provided to override the default value, which is to
  /// open the item's album/artist screen.
  final void Function()? onTap;

  /// If specified, use cards instead of list tiles. Use this if you want to use
  /// this widget in a grid view.
  final bool isGrid;

  /// If true, the grid item will use a ValueListenableBuilder to check whether
  /// or not to show the text. You'll want to set this to false if the
  /// [AlbumItem] would be rebuilt by FinampSettings anyway.
  final bool gridAddSettingsListener;

  @override
  State<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends State<AlbumItem> {
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();

  late BaseItemDto mutableAlbum;

  QueueService get _queueService => GetIt.instance<QueueService>();

  late Function() onTap;
  late AppLocalizations local;
  late ScaffoldMessengerState messenger;

  @override
  void initState() {
    super.initState();
    mutableAlbum = widget.album;

    // this is jank lol
    onTap = widget.onTap ??
        () {
          if (mutableAlbum.type == "MusicArtist" ||
              mutableAlbum.type == "MusicGenre") {
            Navigator.of(context)
                .pushNamed(ArtistScreen.routeName, arguments: mutableAlbum);
          } else {
            Navigator.of(context)
                .pushNamed(AlbumScreen.routeName, arguments: mutableAlbum);
          }
        };
  }

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;
    messenger = ScaffoldMessenger.of(context);

    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: widget.isGrid
          ? Theme.of(context).cardTheme.margin ?? const EdgeInsets.all(4.0)
          : EdgeInsets.zero,
      child: GestureDetector(
        onLongPressStart: (details) async {
          Feedback.forLongPress(context);

          final isOffline = FinampSettingsHelper.finampSettings.isOffline;

          final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

          final selection = await showMenu<_AlbumListTileMenuItems>(
            context: context,
            position: RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              screenSize.width - details.globalPosition.dx,
              screenSize.height - details.globalPosition.dy,
            ),
            items: [
              mutableAlbum.userData!.isFavorite
                  ? PopupMenuItem<_AlbumListTileMenuItems>(
                      enabled: !isOffline,
                      value: _AlbumListTileMenuItems.removeFavourite,
                      child: ListTile(
                        enabled: !isOffline,
                        leading: const Icon(Icons.favorite_border),
                        title: Text(local.removeFavourite),
                      ),
                    )
                  : PopupMenuItem<_AlbumListTileMenuItems>(
                      enabled: !isOffline,
                      value: _AlbumListTileMenuItems.addFavourite,
                      child: ListTile(
                        enabled: !isOffline,
                        leading: const Icon(Icons.favorite),
                        title: Text(local.addFavourite),
                      ),
                    ),
              jellyfinApiHelper.selectedMixAlbums.contains(mutableAlbum.id)
                  ? PopupMenuItem<_AlbumListTileMenuItems>(
                      enabled: !isOffline,
                      value: _AlbumListTileMenuItems.removeFromMixList,
                      child: ListTile(
                        enabled: !isOffline,
                        leading: const Icon(Icons.explore_off),
                        title: Text(local.removeFromMix),
                      ),
                    )
                  : PopupMenuItem<_AlbumListTileMenuItems>(
                      enabled: !isOffline,
                      value: _AlbumListTileMenuItems.addToMixList,
                      child: ListTile(
                        enabled: !isOffline,
                        leading: const Icon(Icons.explore),
                        title: Text(local.addToMix),
                      ),
                    ),
              if (_queueService.getQueue().nextUp.isNotEmpty)
                PopupMenuItem<_AlbumListTileMenuItems>(
                  value: _AlbumListTileMenuItems.playNext,
                  child: ListTile(
                    leading: const Icon(Icons.hourglass_bottom),
                    title: Text(local.playNext),
                  ),
                ),
              PopupMenuItem<_AlbumListTileMenuItems>(
                value: _AlbumListTileMenuItems.addToNextUp,
                child: ListTile(
                  leading: const Icon(Icons.hourglass_top),
                  title: Text(local.addToNextUp),
                ),
              ),
              if (_queueService.getQueue().nextUp.isNotEmpty)
                PopupMenuItem<_AlbumListTileMenuItems>(
                  value: _AlbumListTileMenuItems.shuffleNext,
                  child: ListTile(
                    leading: const Icon(Icons.hourglass_bottom),
                    title: Text(local.shuffleNext),
                  ),
                ),
              PopupMenuItem<_AlbumListTileMenuItems>(
                value: _AlbumListTileMenuItems.shuffleToNextUp,
                child: ListTile(
                  leading: const Icon(Icons.hourglass_top),
                  title: Text(local.shuffleToNextUp),
                ),
              ),
              PopupMenuItem<_AlbumListTileMenuItems>(
                value: _AlbumListTileMenuItems.addToQueue,
                child: ListTile(
                  leading: const Icon(Icons.queue_music),
                  title: Text(local.addToQueue),
                ),
              ),
              PopupMenuItem<_AlbumListTileMenuItems>(
                value: _AlbumListTileMenuItems.shuffleToQueue,
                child: ListTile(
                  leading: const Icon(Icons.queue_music),
                  title: Text(local.shuffleToQueue),
                ),
              ),
            ],
          );

          if (!mounted) return;

          switch (selection) {

            case _AlbumListTileMenuItems.addFavourite:
              try {
                final newUserData =
                    await jellyfinApiHelper.addFavourite(mutableAlbum.id);

                if (!mounted) return;

                setState(() {
                  mutableAlbum.userData = newUserData;
                });

                messenger.showSnackBar(
                    const SnackBar(content: Text("Favourite added.")));
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case _AlbumListTileMenuItems.removeFavourite:
              try {
                final newUserData =
                    await jellyfinApiHelper.removeFavourite(mutableAlbum.id);

                if (!mounted) return;

                setState(() {
                  mutableAlbum.userData = newUserData;
                });
                messenger.showSnackBar(
                    const SnackBar(content: Text("Favourite removed.")));
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case _AlbumListTileMenuItems.addToMixList:
              try {
                jellyfinApiHelper.addAlbumToMixBuilderList(mutableAlbum);
                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case _AlbumListTileMenuItems.removeFromMixList:
              try {
                jellyfinApiHelper.removeAlbumFromMixBuilderList(mutableAlbum);
                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case _AlbumListTileMenuItems.playNext:
              try {
                List<BaseItemDto>? albumTracks;
                if (isOffline) {
                  final downloadsHelper = GetIt.instance<DownloadsHelper>();

                  // The downloadedParent won't be null here if we've already
                  // navigated to it in offline mode
                  final downloadedParent =
                      downloadsHelper.getDownloadedParent(widget.album.id)!;

                  albumTracks = downloadedParent.downloadedChildren.values.toList();
                } else {
                  albumTracks =
                      await jellyfinApiHelper.getItems(
                    parentItem: mutableAlbum,
                    isGenres: false,
                    sortBy: "ParentIndexNumber,IndexNumber,SortName",
                    includeItemTypes: "Audio",
                  );
                }

                if (albumTracks == null) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                          "Couldn't load ${widget.isPlaylist ? "playlist" : "album"}."),
                    ),
                  );
                  return;
                }

                _queueService.addNext(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: widget.isPlaylist
                          ? QueueItemSourceType.nextUpPlaylist
                          : QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName:
                              mutableAlbum.name ?? local.placeholderSource),
                      id: mutableAlbum.id,
                      item: mutableAlbum,
                    ));

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(local.confirmPlayNext(
                        widget.isPlaylist ? "playlist" : "album")),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case _AlbumListTileMenuItems.addToNextUp:
              try {
                List<BaseItemDto>? albumTracks;
                if (isOffline) {
                  final downloadsHelper = GetIt.instance<DownloadsHelper>();

                  // The downloadedParent won't be null here if we've already
                  // navigated to it in offline mode
                  final downloadedParent =
                      downloadsHelper.getDownloadedParent(widget.album.id)!;

                  albumTracks = downloadedParent.downloadedChildren.values.toList();
                } else {
                  albumTracks =
                      await jellyfinApiHelper.getItems(
                    parentItem: mutableAlbum,
                    isGenres: false,
                    sortBy: "ParentIndexNumber,IndexNumber,SortName",
                    includeItemTypes: "Audio",
                  );
                }

                if (albumTracks == null) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                          "Couldn't load ${widget.isPlaylist ? "playlist" : "album"}."),
                    ),
                  );
                  return;
                }

                _queueService.addToNextUp(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: widget.isPlaylist
                          ? QueueItemSourceType.nextUpPlaylist
                          : QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName:
                              mutableAlbum.name ?? local.placeholderSource),
                      id: mutableAlbum.id,
                      item: mutableAlbum,
                    ));

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(local.confirmAddToNextUp(
                        widget.isPlaylist ? "playlist" : "album")),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case _AlbumListTileMenuItems.shuffleNext:
              try {
                List<BaseItemDto>? albumTracks;
                if (isOffline) {
                  final downloadsHelper = GetIt.instance<DownloadsHelper>();

                  // The downloadedParent won't be null here if we've already
                  // navigated to it in offline mode
                  final downloadedParent =
                      downloadsHelper.getDownloadedParent(widget.album.id)!;

                  albumTracks = downloadedParent.downloadedChildren.values.toList();
                } else {
                  albumTracks =
                      await jellyfinApiHelper.getItems(
                    parentItem: mutableAlbum,
                    isGenres: false,
                    sortBy: "Random",
                    includeItemTypes: "Audio",
                  );
                }

                if (albumTracks == null) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                          "Couldn't load ${widget.isPlaylist ? "playlist" : "album"}."),
                    ),
                  );
                  return;
                }

                _queueService.addNext(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: widget.isPlaylist
                          ? QueueItemSourceType.nextUpPlaylist
                          : QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName:
                              mutableAlbum.name ?? local.placeholderSource),
                      id: mutableAlbum.id,
                      item: mutableAlbum,
                    ));

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(local.confirmPlayNext(
                        widget.isPlaylist ? "playlist" : "album")),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case _AlbumListTileMenuItems.shuffleToNextUp:
              try {
                List<BaseItemDto>? albumTracks =
                    await jellyfinApiHelper.getItems(
                  parentItem: mutableAlbum,
                  isGenres: false,
                  sortBy:
                      "Random", //TODO this isn't working anymore with Jellyfin 10.9 (unstable)
                  includeItemTypes: "Audio",
                );

                if (albumTracks == null) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                          "Couldn't load ${widget.isPlaylist ? "playlist" : "album"}."),
                    ),
                  );
                  return;
                }

                _queueService.addToNextUp(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: widget.isPlaylist
                          ? QueueItemSourceType.nextUpPlaylist
                          : QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName:
                              mutableAlbum.name ?? local.placeholderSource),
                      id: mutableAlbum.id,
                      item: mutableAlbum,
                    ));

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(local.confirmShuffleToNextUp),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case _AlbumListTileMenuItems.addToQueue:
              try {
                List<BaseItemDto>? albumTracks =
                    await jellyfinApiHelper.getItems(
                  parentItem: mutableAlbum,
                  isGenres: false,
                  sortBy: "ParentIndexNumber,IndexNumber,SortName",
                  includeItemTypes: "Audio",
                );

                if (albumTracks == null) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                          "Couldn't load ${widget.isPlaylist ? "playlist" : "album"}."),
                    ),
                  );
                  return;
                }

                _queueService.addToQueue(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: widget.isPlaylist
                          ? QueueItemSourceType.nextUpPlaylist
                          : QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName:
                              mutableAlbum.name ?? local.placeholderSource),
                      id: mutableAlbum.id,
                      item: mutableAlbum,
                    ));

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(local.confirmAddToQueue(
                        widget.isPlaylist ? "playlist" : "album")),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case _AlbumListTileMenuItems.shuffleToQueue:
              try {
                List<BaseItemDto>? albumTracks =
                    await jellyfinApiHelper.getItems(
                  parentItem: mutableAlbum,
                  isGenres: false,
                  sortBy: "Random",
                  includeItemTypes: "Audio",
                );

                if (albumTracks == null) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                          "Couldn't load ${widget.isPlaylist ? "playlist" : "album"}."),
                    ),
                  );
                  return;
                }

                _queueService.addToQueue(
                    items: albumTracks,
                    source: QueueItemSource(
                      type: widget.isPlaylist
                          ? QueueItemSourceType.nextUpPlaylist
                          : QueueItemSourceType.nextUpAlbum,
                      name: QueueItemSourceName(
                          type: QueueItemSourceNameType.preTranslated,
                          pretranslatedName:
                              mutableAlbum.name ?? local.placeholderSource),
                      id: mutableAlbum.id,
                      item: mutableAlbum,
                    ));

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(local.confirmAddToQueue(
                        widget.isPlaylist ? "playlist" : "album")),
                  ),
                );

                setState(() {});
              } catch (e) {
                errorSnackbar(e, context);
              }
              break;
            case null:
              break;
          }
        },
        child: widget.isGrid
            ? AlbumItemCard(
                item: mutableAlbum,
                onTap: onTap,
                parentType: widget.parentType,
                addSettingsListener: widget.gridAddSettingsListener,
              )
            : AlbumItemListTile(
                item: mutableAlbum,
                onTap: onTap,
                parentType: widget.parentType,
              ),
      ),
    );
  }
}
