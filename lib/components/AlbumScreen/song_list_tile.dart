import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../../services/isar_downloads.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/media_state_stream.dart';
import '../../services/process_artist.dart';
import '../../screens/album_screen.dart';
import '../../screens/add_to_playlist_screen.dart';
import '../favourite_button.dart';
import '../album_image.dart';
import '../print_duration.dart';
import '../error_snackbar.dart';
import 'downloaded_indicator.dart';

enum SongListTileMenuItems {
  addToQueue,
  playNext,
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
    this.onDelete,

    /// Whether this widget is being displayed in a playlist. If true, will show
    /// the remove from playlist button.
    this.isInPlaylist = false,
  }) : super(key: key);

  final BaseItemDto item;
  final List<BaseItemDto>? children;
  final int? index;
  final bool isSong;
  final String? parentId;
  final bool showArtists;
  final VoidCallback? onDelete;
  final bool isInPlaylist;

  @override
  State<SongListTile> createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    /// Sets the item's favourite on the Jellyfin server.
    Future<void> setFavourite() async {
      try {
        // We switch the widget state before actually doing the request to
        // make the app feel faster (without, there is a delay from the
        // user adding the favourite and the icon showing)
        setState(() {
          widget.item.userData!.isFavorite = !widget.item.userData!.isFavorite;
        });

        // Since we flipped the favourite state already, we can use the flipped
        // state to decide which API call to make
        final newUserData = widget.item.userData!.isFavorite
            ? await _jellyfinApiHelper.addFavourite(widget.item.id)
            : await _jellyfinApiHelper.removeFavourite(widget.item.id);

        if (!mounted) return;

        setState(() {
          widget.item.userData = newUserData;
        });
      } catch (e) {
        setState(() {
          widget.item.userData!.isFavorite = !widget.item.userData!.isFavorite;
        });
        errorSnackbar(e, context);
      }
    }

    final listTile = StreamBuilder<MediaState>(
        stream: mediaStateStream,
        builder: (context, snapshot) {
          // I think past me did this check directly from the JSON for
          // performance. It works for now, apologies if you're debugging it
          // years in the future.
          final isCurrentlyPlaying =
              snapshot.data?.mediaItem?.extras?["itemJson"]["Id"] ==
                      widget.item.id &&
                  snapshot.data?.mediaItem?.extras?["itemJson"]["AlbumId"] ==
                      widget.parentId;

          return ListTile(
            leading: AlbumImage(item: widget.item),
            title: RichText(
              text: TextSpan(
                children: [
                  // third condition checks if the item is viewed from its album (instead of e.g. a playlist)
                  // same horrible check as in canGoToAlbum in GestureDetector below
                  if (widget.item.indexNumber != null &&
                      !widget.isSong &&
                      widget.item.albumId == widget.parentId)
                    TextSpan(
                        text: "${widget.item.indexNumber}. ",
                        style:
                            TextStyle(color: Theme.of(context).disabledColor)),
                  TextSpan(
                    text: widget.item.name ??
                        AppLocalizations.of(context)!.unknownName,
                    style: TextStyle(
                      color: isCurrentlyPlaying
                          ? Theme.of(context).colorScheme.secondary
                          : null,
                    ),
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
                        item: DownloadStub.fromItem(item: widget.item, type: DownloadItemType.song),
                        size:
                            Theme.of(context).textTheme.bodyMedium!.fontSize! +
                                3,
                      ),
                    ),
                    alignment: PlaceholderAlignment.top,
                  ),
                  TextSpan(
                    text: printDuration(Duration(
                        microseconds: (widget.item.runTimeTicks == null
                            ? 0
                            : widget.item.runTimeTicks! ~/ 10))),
                    style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7)),
                  ),
                  if (widget.showArtists)
                    TextSpan(
                      text:
                          " · ${processArtist(widget.item.artists?.join(", ") ?? widget.item.albumArtist, context)}",
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    )
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCurrentlyPlaying &&
                    (snapshot.data?.playbackState.playing ?? false
                    ))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: MiniMusicVisualizer(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 4,
                      height: 15,
                    ),
                  ),
                FavoriteButton(
                  item: widget.item,
                  onlyIfFav: true,
                ),
              ],
            ),
            onTap: () {
              _audioServiceHelper.replaceQueueWithItem(
                itemList: widget.children ?? [widget.item],
                initialIndex: widget.index ?? 0,
              );
            },
          );
        });

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
        //    its metadata. This function also checks if widget.item.parentId is
        //    null.
        late final bool canGoToAlbum;
        late final BaseItemDto? album;
        // TODO clean this long-term album storage back out - does it cross async bound?
        if (widget.item == null) {
          canGoToAlbum=false;
        } else if (FinampSettingsHelper.finampSettings.isOffline) {
          final isarDownloads = GetIt.instance<IsarDownloads>();
          album = isarDownloads.getAlbumDownloadFromSong(widget.item)?.baseItem;
          canGoToAlbum = album != null && widget.item.albumId != widget.parentId;
        } else {
          canGoToAlbum=widget.item.albumId != widget.parentId;
        }

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
            if (_audioServiceHelper.hasQueueItems()) ...[
              PopupMenuItem<SongListTileMenuItems>(
                value: SongListTileMenuItems.addToQueue,
                child: ListTile(
                  leading: const Icon(Icons.queue_music),
                  title: Text(AppLocalizations.of(context)!.addToQueue),
                ),
              ),
              PopupMenuItem<SongListTileMenuItems>(
                value: SongListTileMenuItems.playNext,
                child: ListTile(
                  leading: const Icon(Icons.queue_music),
                  title: Text(AppLocalizations.of(context)!.playNext),
                ),
              ),
            ],
            PopupMenuItem<SongListTileMenuItems>(
              value: SongListTileMenuItems.replaceQueueWithItem,
              child: ListTile(
                leading: const Icon(Icons.play_circle),
                title: Text(AppLocalizations.of(context)!.replaceQueue),
              ),
            ),
            if (widget.isInPlaylist)
              PopupMenuItem<SongListTileMenuItems>(
                enabled: !isOffline,
                value: SongListTileMenuItems.addToPlaylist,
                child: ListTile(
                  leading: const Icon(Icons.playlist_add),
                  title: Text(AppLocalizations.of(context)!.addToPlaylistTitle),
                  enabled: !isOffline,
                ),
              ),
            widget.isInPlaylist
                ? PopupMenuItem<SongListTileMenuItems>(
                    enabled: !isOffline,
                    value: SongListTileMenuItems.removeFromPlaylist,
                    child: ListTile(
                      leading: const Icon(Icons.playlist_remove),
                      title: Text(AppLocalizations.of(context)!
                          .removeFromPlaylistTitle),
                      enabled: !isOffline && widget.parentId != null,
                    ),
                  )
                : PopupMenuItem<SongListTileMenuItems>(
                    enabled: !isOffline,
                    value: SongListTileMenuItems.addToPlaylist,
                    child: ListTile(
                      leading: const Icon(Icons.playlist_add),
                      title: Text(
                          AppLocalizations.of(context)!.addToPlaylistTitle),
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
            widget.item.userData!.isFavorite
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
            await _audioServiceHelper.addQueueItems([widget.item]);

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.addedToQueue),
            ));
            break;

          case SongListTileMenuItems.playNext:
            await _audioServiceHelper.insertQueueItemsNext([widget.item]);

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.insertedIntoQueue),
            ));
            break;

          case SongListTileMenuItems.replaceQueueWithItem:
            await _audioServiceHelper
                .replaceQueueWithItem(itemList: [widget.item]);

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.queueReplaced),
            ));
            break;

          case SongListTileMenuItems.addToPlaylist:
            Navigator.of(context).pushNamed(AddToPlaylistScreen.routeName,
                arguments: widget.item.id);
            break;

          case SongListTileMenuItems.removeFromPlaylist:
            try {
              await _jellyfinApiHelper.removeItemsFromPlaylist(
                  playlistId: widget.parentId!,
                  entryIds: [widget.item.playlistItemId!]);

              if (!mounted) return;

              await _jellyfinApiHelper.getItems(
                parentItem:
                    await _jellyfinApiHelper.getItemById(widget.item.parentId!),
                sortBy: "ParentIndexNumber,IndexNumber,SortName",
                includeItemTypes: "Audio",
                isGenres: false,
              );

              if (!mounted) return;

              if (widget.onDelete != null) widget.onDelete!();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.removedFromPlaylist),
              ));
            } catch (e) {
              errorSnackbar(e, context);
            }
            break;

          case SongListTileMenuItems.instantMix:
            await _audioServiceHelper.startInstantMixForItem(widget.item);

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.startingInstantMix),
            ));
            break;
          case SongListTileMenuItems.goToAlbum:

            if (! FinampSettingsHelper.finampSettings.isOffline) {
              // If online, get the album's BaseItemDto from the server.
              try {
                album =
                    await _jellyfinApiHelper.getItemById(widget.item.parentId!);
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
          case SongListTileMenuItems.removeFavourite:
            await setFavourite();
            break;
          case null:
            break;
        }
      },
      child: widget.isSong
          ? listTile
          : Dismissible(
              key: Key(widget.index.toString()),
              direction: FinampSettingsHelper.finampSettings.disableGesture
                  ? DismissDirection.none
                  : DismissDirection.horizontal,
              background: Container(
                color: Theme.of(context).colorScheme.secondary,
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
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
                await _audioServiceHelper.addQueueItems([widget.item]);

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
