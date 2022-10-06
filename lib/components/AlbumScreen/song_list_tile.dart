import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/downloads_helper.dart';
import '../../services/process_artist.dart';
import '../../services/music_player_background_task.dart';
import '../../screens/album_screen.dart';
import '../../screens/add_to_playlist_screen.dart';
import '../favourite_button.dart';
import '../album_image.dart';
import '../print_duration.dart';
import '../error_snackbar.dart';
import 'downloaded_indicator.dart';

enum SongListTileMenuItems {
  addToQueue,
  replaceQueueWithItem,
  addToPlaylist,
  removeFromPlaylist,
  instantMix,
  goToAlbum,
  addFavourite,
  removeFavourite,
}

class SongListTile extends StatefulWidget {
  const SongListTile({
    Key? key,
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
    this.isSong = false,
    this.showArtists = true,
  }) : super(key: key);

  final BaseItemDto item;
  final List<BaseItemDto>? children;
  final int? index;
  final bool isSong;
  final String? parentId;
  final bool showArtists;

  @override
  State<SongListTile> createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  // Like in AlbumListTile, we make a "mutable item" so that we can setState the
  // favourite property.
  late BaseItemDto mutableItem = widget.item;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final listTile = ListTile(
      leading: AlbumImage(item: mutableItem),
      title: StreamBuilder<MediaItem?>(
        stream: _audioHandler.mediaItem,
        builder: (context, snapshot) {
          return RichText(
            text: TextSpan(
              children: [
                // third condition checks if the item is viewed from its album (instead of e.g. a playlist)
                // same horrible check as in canGoToAlbum in GestureDetector below
                if (mutableItem.indexNumber != null &&
                    !widget.isSong &&
                    mutableItem.albumId == widget.parentId)
                  TextSpan(
                      text: "${mutableItem.indexNumber}. ",
                      style: TextStyle(color: Theme.of(context).disabledColor)),
                TextSpan(
                  text: mutableItem.name ??
                      AppLocalizations.of(context)!.unknownName,
                  style: TextStyle(
                    color: snapshot.data?.extras?["itemJson"]["Id"] ==
                                mutableItem.id &&
                            snapshot.data?.extras?["itemJson"]["AlbumId"] ==
                                widget.parentId
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                ),
              ],
              style: Theme.of(context).textTheme.subtitle1,
            ),
          );
        },
      ),
      subtitle: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(-3, 0),
                child: DownloadedIndicator(
                  item: mutableItem,
                  size: Theme.of(context).textTheme.bodyText2!.fontSize! + 3,
                ),
              ),
              alignment: PlaceholderAlignment.top,
            ),
            TextSpan(
              text: printDuration(Duration(
                  microseconds: (mutableItem.runTimeTicks == null
                      ? 0
                      : mutableItem.runTimeTicks! ~/ 10))),
              style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.color
                      ?.withOpacity(0.7)),
            ),
            if (widget.showArtists)
              TextSpan(
                text:
                    " · ${processArtist(mutableItem.artists?.join(", ") ?? mutableItem.albumArtist, context)}",
                style: TextStyle(color: Theme.of(context).disabledColor),
              )
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: FavoriteButton(
        item: mutableItem,
        onlyIfFav: true,
      ),
      onTap: () {
        _audioServiceHelper.replaceQueueWithItem(
          itemList: widget.children ?? [mutableItem],
          initialIndex: widget.index ?? 0,
        );
      },
    );

    return GestureDetector(
      onLongPressStart: (details) async {
        Feedback.forLongPress(context);

        // This horrible check does 2 things:
        //  - Checks if the item's album is not the same as the parent item
        //    that created the widget. The ids will be different if the
        //    SongListTile is in a playlist, but they will be the same if viewed
        //    in the item's album. We don't want to show this menu item if we're
        //    already in the item's album.
        //
        //  - Checks if the album is downloaded if in offline mode. If we're in
        //    offline mode, we need the album to actually be downloaded to show
        //    its metadata. This function also checks if mutableItem.parentId is
        //    null.
        final canGoToAlbum = mutableItem.albumId != widget.parentId &&
            _isAlbumDownloadedIfOffline(mutableItem.parentId);

        // Some options are disabled in offline mode
        final isOffline = FinampSettingsHelper.finampSettings.isOffline;

        final selection = await showMenu<SongListTileMenuItems>(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            screenSize.width - details.globalPosition.dx,
            screenSize.height - details.globalPosition.dy,
          ),
          items: [
            PopupMenuItem<SongListTileMenuItems>(
              value: SongListTileMenuItems.addToQueue,
              child: ListTile(
                leading: const Icon(Icons.queue_music),
                title: Text(AppLocalizations.of(context)!.addToQueue),
              ),
            ),
            PopupMenuItem<SongListTileMenuItems>(
              value: SongListTileMenuItems.replaceQueueWithItem,
              child: ListTile(
                leading: const Icon(Icons.play_circle),
                title: Text(AppLocalizations.of(context)!.replaceQueue),
              ),
            ),
            PopupMenuItem<SongListTileMenuItems>(
              enabled: !isOffline,
              value: SongListTileMenuItems.addToPlaylist,
              child: ListTile(
                leading: const Icon(Icons.playlist_add),
                title: Text(AppLocalizations.of(context)!.addToPlaylistTitle),
                enabled: !isOffline,
              ),
            ),
            PopupMenuItem<SongListTileMenuItems>(
              enabled: !isOffline && widget.parentId != null,
              value: SongListTileMenuItems.removeFromPlaylist,
              child: ListTile(
                leading: const Icon(Icons.playlist_remove),
                title:
                    Text(AppLocalizations.of(context)!.removeFromPlaylistTitle),
                enabled: !isOffline,
              ),
            ),
            PopupMenuItem<SongListTileMenuItems>(
              enabled: !isOffline,
              value: SongListTileMenuItems.instantMix,
              child: ListTile(
                leading: const Icon(Icons.explore),
                title: Text(AppLocalizations.of(context)!.instantMix),
                enabled: !isOffline,
              ),
            ),
            PopupMenuItem<SongListTileMenuItems>(
              enabled: canGoToAlbum,
              value: SongListTileMenuItems.goToAlbum,
              child: ListTile(
                leading: const Icon(Icons.album),
                title: Text(AppLocalizations.of(context)!.goToAlbum),
                enabled: canGoToAlbum,
              ),
            ),
            mutableItem.userData!.isFavorite
                ? PopupMenuItem<SongListTileMenuItems>(
                    value: SongListTileMenuItems.removeFavourite,
                    child: ListTile(
                      leading: const Icon(Icons.favorite_border),
                      title:
                          Text(AppLocalizations.of(context)!.removeFavourite),
                    ),
                  )
                : PopupMenuItem<SongListTileMenuItems>(
                    value: SongListTileMenuItems.addFavourite,
                    child: ListTile(
                      leading: const Icon(Icons.favorite),
                      title: Text(AppLocalizations.of(context)!.addFavourite),
                    ),
                  ),
          ],
        );

        if (!mounted) return;

        switch (selection) {
          case SongListTileMenuItems.addToQueue:
            await _audioServiceHelper.addQueueItem(mutableItem);

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.addedToQueue),
            ));
            break;

          case SongListTileMenuItems.replaceQueueWithItem:
            await _audioServiceHelper
                .replaceQueueWithItem(itemList: [mutableItem]);

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.queueReplaced),
            ));
            break;

          case SongListTileMenuItems.addToPlaylist:
            Navigator.of(context).pushNamed(AddToPlaylistScreen.routeName,
                arguments: mutableItem.id);
            break;

          case SongListTileMenuItems.instantMix:
            await _audioServiceHelper.startInstantMixForItem(mutableItem);

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.startingInstantMix),
            ));
            break;
          case SongListTileMenuItems.goToAlbum:
            late BaseItemDto album;
            if (FinampSettingsHelper.finampSettings.isOffline) {
              // If offline, load the album's BaseItemDto from DownloadHelper.
              final downloadsHelper = GetIt.instance<DownloadsHelper>();

              // downloadedParent won't be null here since the menu item already
              // checks if the DownloadedParent exists.
              album = downloadsHelper
                  .getDownloadedParent(mutableItem.parentId!)!
                  .item;
            } else {
              // If online, get the album's BaseItemDto from the server.
              try {
                album =
                    await _jellyfinApiHelper.getItemById(mutableItem.parentId!);
              } catch (e) {
                errorSnackbar(e, context);
                break;
              }
            }

            if (!mounted) return;

            Navigator.of(context)
                .pushNamed(AlbumScreen.routeName, arguments: album);
            break;
          case SongListTileMenuItems.addFavourite:
            try {
              final newUserData =
                  await _jellyfinApiHelper.addFavourite(mutableItem.id);

              if (!mounted) return;

              setState(() {
                mutableItem.userData = newUserData;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!.favouriteAdded),
              ));
            } catch (e) {
              errorSnackbar(e, context);
            }
            break;
          case SongListTileMenuItems.removeFavourite:
            try {
              final newUserData =
                  await _jellyfinApiHelper.removeFavourite(mutableItem.id);

              if (!mounted) return;

              setState(() {
                mutableItem.userData = newUserData;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!.favouriteRemoved),
              ));
            } catch (e) {
              errorSnackbar(e, context);
            }
            break;
          case null:
            break;
          case SongListTileMenuItems.removeFromPlaylist:
            if (widget.parentId != null) {
              BaseItemDto item =
                  await _jellyfinApiHelper.getItemById(widget.parentId!);
              if (item.type == "Playlist") {
                await _jellyfinApiHelper.removeItemsFromPlaylist(
                    playlistId: item.id, ids: [mutableItem.id]);
              } else {
                errorSnackbar(Exception("Parent is not Playlist"), context);
              }
            } else {
              errorSnackbar(Exception("Parent Item is null"), context);
            }
            break;
        }
      },
      child: widget.isSong
          ? listTile
          : Dismissible(
              key: Key(widget.index.toString()),
              background: Container(
                color: Theme.of(context).colorScheme.secondary,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: const [
                      AspectRatio(
                        aspectRatio: 1,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Icon(Icons.queue_music),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              confirmDismiss: (direction) async {
                await _audioServiceHelper.addQueueItem(mutableItem);

                if (!mounted) return false;

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(AppLocalizations.of(context)!.addedToQueue),
                ));

                return false;
              },
              child: listTile,
            ),
    );
  }
}

/// If offline, check if an album is downloaded. Always returns true if online.
/// Returns false if albumId is null.
bool _isAlbumDownloadedIfOffline(String? albumId) {
  if (albumId == null) {
    return false;
  } else if (FinampSettingsHelper.finampSettings.isOffline) {
    final downloadsHelper = GetIt.instance<DownloadsHelper>();
    return downloadsHelper.isAlbumDownloaded(albumId);
  } else {
    return true;
  }
}
