import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart' as jellyfin_models;
import '../album_image.dart';
import '../../services/process_artist.dart';

import 'package:finamp/components/AlbumScreen/song_list_tile.dart';
import 'package:finamp/components/error_snackbar.dart';
import 'package:finamp/screens/add_to_playlist_screen.dart';
import 'package:finamp/screens/album_screen.dart';
import 'package:finamp/services/downloads_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart' hide ReorderableList;

class PlaybackHistoryListTile extends StatefulWidget {
  PlaybackHistoryListTile({
    super.key,
    required this.actualIndex,
    required this.item,
    required this.audioServiceHelper,
    required this.onTap,
  });

  final int actualIndex;
  final HistoryItem item;
  final AudioServiceHelper audioServiceHelper;
  late void Function() onTap;

  final _queueService = GetIt.instance<QueueService>();
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  State<PlaybackHistoryListTile> createState() => _PlaybackHistoryListTileState();
}

class _PlaybackHistoryListTileState extends State<PlaybackHistoryListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onLongPressStart: (details) => showSongMenu(details),
          child: Card(
              margin: EdgeInsets.all(0.0),
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                visualDensity: VisualDensity.standard,
                minVerticalPadding: 0.0,
                horizontalTitleGap: 10.0,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                leading: AlbumImage(
                  item: widget.item.item.item.extras?["itemJson"] == null
                      ? null
                      : jellyfin_models.BaseItemDto.fromJson(
                          widget.item.item.item.extras?["itemJson"]),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        widget.item.item.item.title ??
                            AppLocalizations.of(context)!.unknownName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        processArtist(widget.item.item.item.artist, context),
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontFamily: 'Lexend Deca',
                            fontWeight: FontWeight.w300,
                            overflow: TextOverflow.ellipsis),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // subtitle: Container(
                //   alignment: Alignment.centerLeft,
                //   height: 40.5, // has to be above a certain value to get rid of vertical padding
                //   child: Padding(
                //     padding: const EdgeInsets.only(bottom: 2.0),
                //     child: Text(
                //       processArtist(widget.item.item.item.artist, context),
                //       style: const TextStyle(
                //           color: Colors.white70,
                //           fontSize: 13,
                //           fontFamily: 'Lexend Deca',
                //           fontWeight: FontWeight.w300,
                //           overflow: TextOverflow.ellipsis),
                //       overflow: TextOverflow.ellipsis,
                //     ),
                //   ),
                // ),
                trailing: Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(right: 8.0),
                  padding: const EdgeInsets.only(right: 6.0),
                  // width: widget.allowReorder ? 145.0 : 115.0,
                  width: 35.0,
                  height: 50.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.item.item.item.duration?.inMinutes.toString()}:${((widget.item.item.item.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: widget.onTap,
              )));
    
  }

  void showSongMenu(LongPressStartDetails? details) async {
    final canGoToAlbum = _isAlbumDownloadedIfOffline(
        jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.item.extras?["itemJson"])
            .parentId);

    // Some options are disabled in offline mode
    final isOffline = FinampSettingsHelper.finampSettings.isOffline;

    final screenSize = MediaQuery.of(context).size;

    Feedback.forLongPress(context);

    final selection = await showMenu<SongListTileMenuItems>(
      context: context,
      position: details != null
          ? RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              screenSize.width - details.globalPosition.dx,
              screenSize.height - details.globalPosition.dy,
            )
          : RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 50.0,
              MediaQuery.of(context).size.height - 50.0, 0.0, 0.0),
      items: [
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
            leading: const Icon(TablerIcons.hourglass_low),
            title: Text(AppLocalizations.of(context)!.playNext),
          ),
        ),
        PopupMenuItem<SongListTileMenuItems>(
          value: SongListTileMenuItems.addToNextUp,
          child: ListTile(
            leading: const Icon(TablerIcons.hourglass_high),
            title: Text(AppLocalizations.of(context)!.addToNextUp),
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
        jellyfin_models.BaseItemDto.fromJson(
                    widget.item.item.item.extras?["itemJson"])
                .userData!
                .isFavorite
            ? PopupMenuItem<SongListTileMenuItems>(
                value: SongListTileMenuItems.removeFavourite,
                child: ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: Text(AppLocalizations.of(context)!.removeFavourite),
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
        await widget._queueService.addToQueue(
            jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.item.extras?["itemJson"]),
            QueueItemSource(
                type: QueueItemSourceType.unknown,
                name: QueueItemSourceName(type: QueueItemSourceNameType.preTranslated, pretranslatedName: AppLocalizations.of(context)!.queue),
                id: widget.item.item.source.id));

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.addedToQueue),
        ));
        break;

      case SongListTileMenuItems.playNext:
        await widget._queueService.addNext(items: [jellyfin_models.BaseItemDto.fromJson(
            widget.item.item.item.extras?["itemJson"])]);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.confirmPlayNext("track")),
        ));
        break;

      case SongListTileMenuItems.addToNextUp:
        await widget._queueService.addToNextUp(items: [jellyfin_models.BaseItemDto.fromJson(
            widget.item.item.item.extras?["itemJson"])]);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.confirmAddToNextUp("track")),
        ));
        break;

      case SongListTileMenuItems.addToPlaylist:
        Navigator.of(context).pushNamed(AddToPlaylistScreen.routeName,
            arguments: jellyfin_models.BaseItemDto.fromJson(
                    widget.item.item.item.extras?["itemJson"])
                .id);
        break;

      case SongListTileMenuItems.instantMix:
        await widget._audioServiceHelper.startInstantMixForItem(
            jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.item.extras?["itemJson"]));

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.startingInstantMix),
        ));
        break;
      case SongListTileMenuItems.goToAlbum:
        late jellyfin_models.BaseItemDto album;
        if (FinampSettingsHelper.finampSettings.isOffline) {
          // If offline, load the album's BaseItemDto from DownloadHelper.
          final downloadsHelper = GetIt.instance<DownloadsHelper>();

          // downloadedParent won't be null here since the menu item already
          // checks if the DownloadedParent exists.
          album = downloadsHelper
              .getDownloadedParent(jellyfin_models.BaseItemDto.fromJson(
                      widget.item.item.item.extras?["itemJson"])
                  .parentId!)!
              .item;
        } else {
          // If online, get the album's BaseItemDto from the server.
          try {
            album = await widget._jellyfinApiHelper.getItemById(
                jellyfin_models.BaseItemDto.fromJson(
                        widget.item.item.item.extras?["itemJson"])
                    .parentId!);
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
  }

  Future<void> setFavourite() async {
    try {
      // We switch the widget state before actually doing the request to
      // make the app feel faster (without, there is a delay from the
      // user adding the favourite and the icon showing)
      setState(() {
        jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.item.extras?["itemJson"])
            .userData!
            .isFavorite = !jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.item.extras?["itemJson"])
            .userData!
            .isFavorite;
      });

      // Since we flipped the favourite state already, we can use the flipped
      // state to decide which API call to make
      final newUserData = jellyfin_models.BaseItemDto.fromJson(
                  widget.item.item.item.extras?["itemJson"])
              .userData!
              .isFavorite
          ? await widget._jellyfinApiHelper.addFavourite(
              jellyfin_models.BaseItemDto.fromJson(
                      widget.item.item.item.extras?["itemJson"])
                  .id)
          : await widget._jellyfinApiHelper.removeFavourite(
              jellyfin_models.BaseItemDto.fromJson(
                      widget.item.item.item.extras?["itemJson"])
                  .id);

      if (!mounted) return;

      setState(() {
        jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.item.extras?["itemJson"])
            .userData = newUserData;
      });
    } catch (e) {
      setState(() {
        jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.item.extras?["itemJson"])
            .userData!
            .isFavorite = !jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.item.extras?["itemJson"])
            .userData!
            .isFavorite;
      });
      errorSnackbar(e, context);
    }
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
