import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/AudioServiceHelper.dart';
import '../../services/JellyfinApiData.dart';
import '../../services/FinampSettingsHelper.dart';
import '../../services/DownloadsHelper.dart';
import '../../services/processArtist.dart';
import '../AlbumImage.dart';
import '../printDuration.dart';
import '../errorSnackbar.dart';
import 'DownloadedIndicator.dart';

enum SongListTileMenuItems {
  AddToQueue,
  AddToPlaylist,
  GoToAlbum,
}

class SongListTile extends StatefulWidget {
  const SongListTile({
    Key? key,
    required this.item,
    required this.children,
    required this.index,
    this.parentId,
    this.isSong = false,
  }) : super(key: key);

  final BaseItemDto item;
  final List<BaseItemDto> children;
  final int index;
  final bool isSong;
  final String? parentId;

  @override
  _SongListTileState createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onLongPressStart: (details) async {
        Feedback.forLongPress(context);

        // This horrible check does 2 things:
        //  - Checks if the item's parent is not the same as the parent item
        //    that created the widget. The ids will be different if the
        //    SongListTile is in a playlist, but they will be the same if viewed
        //    in the item's album. We don't want to show this menu item if we're
        //    already in the item's album.
        //
        //  - Checks if the album is downloaded if in offline mode. If we're in
        //    offline mode, we need the album to actually be downloaded to show
        //    its metadata. This function also checks if widget.item.parentId is
        //    null.
        final canGoToAlbum = widget.item.parentId != widget.parentId &&
            _isAlbumDownloadedIfOffline(widget.item.parentId);

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
              value: SongListTileMenuItems.AddToQueue,
              child: ListTile(
                leading: Icon(Icons.queue_music),
                title: Text("Add To Queue"),
              ),
            ),
            PopupMenuItem<SongListTileMenuItems>(
              enabled: !isOffline,
              value: SongListTileMenuItems.AddToPlaylist,
              child: ListTile(
                leading: Icon(Icons.playlist_add),
                title: Text("Add To Playlist"),
                enabled: !isOffline,
              ),
            ),
            PopupMenuItem<SongListTileMenuItems>(
              enabled: canGoToAlbum,
              value: SongListTileMenuItems.GoToAlbum,
              child: ListTile(
                leading: Icon(Icons.album),
                title: Text("Go To Album"),
                enabled: canGoToAlbum,
              ),
            ),
          ],
        );

        switch (selection) {
          case SongListTileMenuItems.AddToQueue:
            await audioServiceHelper.addQueueItem(widget.item);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Added to queue.")));
            break;
          case SongListTileMenuItems.AddToPlaylist:
            Navigator.of(context)
                .pushNamed("/music/addtoplaylist", arguments: widget.item);
            break;
          case SongListTileMenuItems.GoToAlbum:
            late BaseItemDto album;
            if (FinampSettingsHelper.finampSettings.isOffline) {
              // If offline, load the album's BaseItemDto from DownloadHelper.
              final downloadsHelper = GetIt.instance<DownloadsHelper>();

              // downloadedParent won't be null here since the menu item already
              // checks if the DownloadedParent exists.
              album = downloadsHelper
                  .getDownloadedParent(widget.item.parentId!)!
                  .item;
            } else {
              // If online, get the album's BaseItemDto from the server.
              try {
                final jellyfinApiData = GetIt.instance<JellyfinApiData>();
                album =
                    await jellyfinApiData.getItemById(widget.item.parentId!);
              } catch (e) {
                errorSnackbar(e, context);
                break;
              }
            }
            Navigator.of(context)
                .pushNamed("/music/albumscreen", arguments: album);
            break;
          case null:
            break;
        }
      },
      child: Dismissible(
        key: Key(widget.index.toString()),
        background: Container(
          color: Colors.green,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Icon(Icons.queue_music),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        confirmDismiss: (direction) async {
          await audioServiceHelper.addQueueItem(widget.item);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Added to queue.")));
          return false;
        },
        direction: DismissDirection.startToEnd,
        child: ListTile(
          leading: AlbumImage(
            itemId: widget.item.parentId,
          ),
          title: StreamBuilder<MediaItem?>(
            stream: AudioService.currentMediaItemStream,
            builder: (context, snapshot) {
              return Text(
                widget.item.name ?? "Unknown Name",
                style: TextStyle(
                  color: snapshot.data?.extras!["itemId"] == widget.item.id &&
                          snapshot.data?.extras!["parentId"] == widget.parentId
                      ? Colors.green
                      : null,
                ),
              );
            },
          ),
          subtitle: Text(widget.isSong
              ? processArtist(widget.item.albumArtist)
              : printDuration(
                  Duration(
                      microseconds: (widget.item.runTimeTicks == null
                          ? 0
                          : widget.item.runTimeTicks! ~/ 10)),
                )),
          trailing: DownloadedIndicator(item: widget.item),
          onTap: () {
            audioServiceHelper.replaceQueueWithItem(
              itemList: widget.children,
              initialIndex: widget.index,
            );
          },
        ),
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
