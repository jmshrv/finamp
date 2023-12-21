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
import 'package:mini_music_visualizer/mini_music_visualizer.dart';

import '../../screens/add_to_playlist_screen.dart';
import '../../screens/album_screen.dart';
import '../../services/audio_service_helper.dart';
import '../../services/downloads_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/media_state_stream.dart';
import '../../services/process_artist.dart';
import '../album_image.dart';
import '../error_snackbar.dart';
import '../favourite_button.dart';
import '../print_duration.dart';
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
    this.childrenFuture,

    /// Index of the song in whatever parent this widget is in. Used to start
    /// the audio service at a certain index, such as when selecting the middle
    /// song in an album.
    this.indexFuture,
    this.parentItem,
    this.isSong = false,
    this.showArtists = true,
    this.onRemoveFromList,
    this.showPlayCount = false,

    /// Whether this widget is being displayed in a playlist. If true, will show
    /// the remove from playlist button.
    this.isInPlaylist = false,
    this.isOnArtistScreen = false,
  }) : super(key: key);

  final jellyfin_models.BaseItemDto item;
  final Future<List<jellyfin_models.BaseItemDto>?>? childrenFuture;
  final Future<int>? indexFuture;
  final bool isSong;
  final jellyfin_models.BaseItemDto? parentItem;
  final bool showArtists;
  final VoidCallback? onRemoveFromList;
  final bool showPlayCount;
  final bool isInPlaylist;
  final bool isOnArtistScreen;

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

    int index = 0;
    List<jellyfin_models.BaseItemDto>? children;
    var indexAndSongsFuture = Future.wait<void>([
      widget.indexFuture?.then((value) => index = value) ?? Future.value(),
      widget.childrenFuture?.then((value) => children = value) ?? Future.value()
    ]);

    final listTile = StreamBuilder<MediaItem?>(
        stream: _audioHandler.mediaItem,
        builder: (context, snapshot) {
          // I think past me did this check directly from the JSON for
          // performance. It works for now, apologies if you're debugging it
          // years in the future.
          final isCurrentlyPlaying = snapshot.data?.extras?["itemJson"]["Id"] ==
                  widget.item.id &&
              snapshot.data?.extras?["itemJson"]["AlbumId"] == widget.parentItem?.id;

          return ListTile(
            leading: AlbumImage(item: widget.item),
            title: RichText(
              text: TextSpan(
                children: [
                  // third condition checks if the item is viewed from its album (instead of e.g. a playlist)
                  // same horrible check as in canGoToAlbum in GestureDetector below
                  if (widget.item.indexNumber != null &&
                      !widget.isSong &&
                      widget.item.albumId == widget.parentItem?.id)
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
                        item: widget.item,
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
                    ),
                  if (widget.showPlayCount)
                    TextSpan(
                      text: AppLocalizations.of(context)!
                          .playCountInline(widget.item.userData?.playCount ?? 0),
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCurrentlyPlaying)
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
          );
        });

    return GestureDetector(
      onLongPressStart: (details) async {
        Feedback.forLongPress(context);
        showModalSongMenu(
            context: context,
            item: widget.item,
            isInPlaylist: widget.isInPlaylist,
            onRemoveFromList: widget.onRemoveFromList,
            parentId: widget.parentItem?.id);
      },
      onTap: () {
        indexAndSongsFuture.then((_) {
          if (children != null) {
            // start linear playback of album from the given index
            _queueService.startPlayback(
              items: children!,
              source: QueueItemSource(
                type: widget.isInPlaylist
                    ? QueueItemSourceType.playlist :
                    widget.isOnArtistScreen ? QueueItemSourceType.artist
                    : QueueItemSourceType.album,
                name: QueueItemSourceName(
                    type: QueueItemSourceNameType.preTranslated,
                    pretranslatedName: ((widget.isInPlaylist ||
                                widget.isOnArtistScreen)
                            ? widget.parentItem?.name
                            : widget.item.album) ??
                        AppLocalizations.of(context)!.placeholderSource),
                id: widget.parentItem?.id ?? "",
                item: widget.parentItem,
              ),
              order: FinampPlaybackOrder.linear,
              startingIndex: index,
            );
          } else {
            _audioServiceHelper.startInstantMixForItem(widget.item);
          }
        });
      },
      child: widget.isSong
          ? listTile
          : Dismissible(
              key: Key(widget.indexFuture.toString()),
              direction: FinampSettingsHelper.finampSettings.disableGesture
                  ? DismissDirection.none
                  : DismissDirection.horizontal,
              background: Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
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
                            child: Icon(
                              Icons.queue_music,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
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
                        id: widget.parentItem?.id ?? "",
                        item: widget.parentItem,
                      ));

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
