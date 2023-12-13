import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/AlbumScreen/song_menu.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:finamp/models/finamp_models.dart';
import '../../services/audio_service_helper.dart';
import '../../services/current_album_image_provider.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/downloads_helper.dart';
import '../../services/player_screen_theme_provider.dart';
import '../../services/process_artist.dart';
import '../../services/music_player_background_task.dart';
import '../../screens/album_screen.dart';
import '../../screens/add_to_playlist_screen.dart';
import '../PlayerScreen/album_chip.dart';
import '../PlayerScreen/artist_chip.dart';
import '../favourite_button.dart';
import '../album_image.dart';
import '../print_duration.dart';
import '../error_snackbar.dart';
import 'downloaded_indicator.dart';

enum SongListTileMenuItems {
  addToQueue,
  playNext,
  addToNextUp,
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
    this.parentName,
    this.isSong = false,
    this.showArtists = true,
    this.onDelete,

    /// Whether this widget is being displayed in a playlist. If true, will show
    /// the remove from playlist button.
    this.isInPlaylist = false,
  }) : super(key: key);

  final jellyfin_models.BaseItemDto item;
  final List<jellyfin_models.BaseItemDto>? children;
  final int? index;
  final bool isSong;
  final String? parentId;
  final String? parentName;
  final bool showArtists;
  final VoidCallback? onDelete;
  final bool isInPlaylist;

  @override
  State<SongListTile> createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile>
    with SingleTickerProviderStateMixin {
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _queueService = GetIt.instance<QueueService>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  bool songMenuFullSize = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final listTile = ListTile(
      leading: AlbumImage(item: widget.item),
      title: StreamBuilder<MediaItem?>(
        stream: _audioHandler.mediaItem,
        builder: (context, snapshot) {
          return RichText(
            text: TextSpan(
              children: [
                // third condition checks if the item is viewed from its album (instead of e.g. a playlist)
                // same horrible check as in canGoToAlbum in GestureDetector below
                if (widget.item.indexNumber != null &&
                    !widget.isSong &&
                    widget.item.albumId == widget.parentId)
                  TextSpan(
                      text: "${widget.item.indexNumber}. ",
                      style: TextStyle(color: Theme.of(context).disabledColor)),
                TextSpan(
                  text: widget.item.name ??
                      AppLocalizations.of(context)!.unknownName,
                  style: TextStyle(
                    color: snapshot.data?.extras?["itemJson"]["Id"] ==
                                widget.item.id &&
                            snapshot.data?.extras?["itemJson"]["AlbumId"] ==
                                widget.parentId
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                ),
              ],
              style: Theme.of(context).textTheme.titleMedium,
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
                  item: widget.item,
                  size: Theme.of(context).textTheme.bodyMedium!.fontSize! + 3,
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
      trailing: FavoriteButton(
        item: widget.item,
        onlyIfFav: true,
      ),
      onTap: () {
        if (widget.children != null) {
          // start linear playback of album from the given index
          _queueService.startPlayback(
            items: widget.children!,
            source: QueueItemSource(
              type: widget.isInPlaylist
                  ? QueueItemSourceType.playlist
                  : QueueItemSourceType.album,
              name: QueueItemSourceName(
                  type: QueueItemSourceNameType.preTranslated,
                  pretranslatedName: (widget.isInPlaylist
                          ? widget.parentName
                          : widget.item.album) ??
                      AppLocalizations.of(context)!.placeholderSource),
              id: widget.parentId ?? "",
              item: widget.item,
            ),
            order: FinampPlaybackOrder.linear,
            startingIndex: widget.index ?? 0,
          );
        } else {
          _audioServiceHelper.startInstantMixForItem(widget.item);
        }
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
        //    its metadata. This function also checks if widget.item.parentId is
        //    null.
        final canGoToAlbum = widget.item.albumId != widget.parentId &&
            isAlbumDownloadedIfOffline(widget.item.parentId);

        showModalSongMenu(context, widget.item, widget.isInPlaylist,
            canGoToAlbum, widget.onDelete, widget.parentId);
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
                await _queueService.addToNextUp(
                    items: [widget.item],
                    source: QueueItemSource(
                        type: QueueItemSourceType.unknown,
                        name: QueueItemSourceName(
                            type: QueueItemSourceNameType.preTranslated,
                            pretranslatedName:
                                AppLocalizations.of(context)!.queue),
                        id: widget.parentId!));

                if (!mounted) return false;

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(AppLocalizations.of(context)!
                      .confirmAddToNextUp("track")),
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
bool isAlbumDownloadedIfOffline(String? albumId) {
  if (albumId == null) {
    return false;
  } else if (FinampSettingsHelper.finampSettings.isOffline) {
    final downloadsHelper = GetIt.instance<DownloadsHelper>();
    return downloadsHelper.isAlbumDownloaded(albumId);
  } else {
    return true;
  }
}
