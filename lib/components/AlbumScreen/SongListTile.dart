import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/AudioServiceHelper.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/FinampSettingsHelper.dart';
import '../../services/DownloadsHelper.dart';
import '../../services/processArtist.dart';
import '../../services/MusicPlayerBackgroundTask.dart';
import '../AlbumImage.dart';
import '../printDuration.dart';
import '../errorSnackbar.dart';
import 'DownloadedIndicator.dart';

enum SongListTileMenuItems {
  AddToQueue,
  ReplaceQueueWithItem,
  AddToPlaylist,
  GoToAlbum,
  AddFavourite,
  RemoveFavourite,
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
  }) : super(key: key);

  final BaseItemDto item;
  final List<BaseItemDto>? children;
  final int? index;
  final bool isSong;
  final String? parentId;

  @override
  _SongListTileState createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _jellyfinApiData = GetIt.instance<JellyfinApiData>();

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
                if (mutableItem.indexNumber != null
                    && !widget.isSong
                    && mutableItem.albumId == widget.parentId)
                  TextSpan(
                    text: mutableItem.indexNumber.toString() + ". ",
                    style: TextStyle(color: Theme.of(context).disabledColor)
                ),
                TextSpan(
                text: mutableItem.name ?? "Unknown Name",
                style: TextStyle(
                  color:
                      snapshot.data?.extras?["itemJson"]["Id"] == mutableItem.id &&
                              snapshot.data?.extras?["itemJson"]["AlbumId"] ==
                                  widget.parentId
                          ? Theme.of(context).colorScheme.secondary
                          : null,
                  ),
                ),
              ],
              style: const TextStyle(fontSize: 16.0)
            ),
          );
        },
      ),
      subtitle: Text(widget.isSong
          ? processArtist(
              mutableItem.artists?.join(", ") ?? mutableItem.albumArtist)
          : printDuration(
              Duration(
                  microseconds: (mutableItem.runTimeTicks == null
                      ? 0
                      : mutableItem.runTimeTicks! ~/ 10)),
            )),
      trailing: DownloadedIndicator(item: mutableItem),
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
            const PopupMenuItem<SongListTileMenuItems>(
              value: SongListTileMenuItems.AddToQueue,
              child: ListTile(
                leading: Icon(Icons.queue_music),
                title: Text("Add To Queue"),
              ),
            ),
            const PopupMenuItem<SongListTileMenuItems>(
              value: SongListTileMenuItems.ReplaceQueueWithItem,
              child: ListTile(
                leading: Icon(Icons.play_circle),
                title: Text("Replace Queue"),
              ),
            ),
            PopupMenuItem<SongListTileMenuItems>(
              enabled: !isOffline,
              value: SongListTileMenuItems.AddToPlaylist,
              child: ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text("Add To Playlist"),
                enabled: !isOffline,
              ),
            ),
            PopupMenuItem<SongListTileMenuItems>(
              enabled: canGoToAlbum,
              value: SongListTileMenuItems.GoToAlbum,
              child: ListTile(
                leading: const Icon(Icons.album),
                title: const Text("Go To Album"),
                enabled: canGoToAlbum,
              ),
            ),
            mutableItem.userData!.isFavorite
                ? const PopupMenuItem<SongListTileMenuItems>(
                    value: SongListTileMenuItems.RemoveFavourite,
                    child: ListTile(
                      leading: Icon(Icons.star_border),
                      title: Text("Remove Favourite"),
                    ),
                  )
                : const PopupMenuItem<SongListTileMenuItems>(
                    value: SongListTileMenuItems.AddFavourite,
                    child: ListTile(
                      leading: Icon(Icons.star),
                      title: Text("Add Favourite"),
                    ),
                  ),
          ],
        );

        switch (selection) {
          case SongListTileMenuItems.AddToQueue:
            await _audioServiceHelper.addQueueItem(mutableItem);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Added to queue.")));
            break;

          case SongListTileMenuItems.ReplaceQueueWithItem:
            await _audioServiceHelper
                .replaceQueueWithItem(itemList: [mutableItem]);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Queue replaced.")));
            break;

          case SongListTileMenuItems.AddToPlaylist:
            Navigator.of(context)
                .pushNamed("/music/addtoplaylist", arguments: mutableItem.id);
            break;

          case SongListTileMenuItems.GoToAlbum:
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
                    await _jellyfinApiData.getItemById(mutableItem.parentId!);
              } catch (e) {
                errorSnackbar(e, context);
                break;
              }
            }
            Navigator.of(context)
                .pushNamed("/music/albumscreen", arguments: album);
            break;
          case SongListTileMenuItems.AddFavourite:
            try {
              final newUserData =
                  await _jellyfinApiData.addFavourite(mutableItem.id);
              setState(() {
                mutableItem.userData = newUserData;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Favourite added.")));
            } catch (e) {
              errorSnackbar(e, context);
            }
            break;
          case SongListTileMenuItems.RemoveFavourite:
            try {
              final newUserData =
                  await _jellyfinApiData.removeFavourite(mutableItem.id);
              setState(() {
                mutableItem.userData = newUserData;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Favourite removed.")));
            } catch (e) {
              errorSnackbar(e, context);
            }
            break;
          case null:
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
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Added to queue.")));
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
