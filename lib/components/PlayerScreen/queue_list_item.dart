import 'package:finamp/components/AlbumScreen/song_list_tile.dart';
import 'package:finamp/components/AlbumScreen/song_menu.dart';
import 'package:finamp/components/album_image.dart';
import 'package:finamp/components/error_snackbar.dart';
import 'package:finamp/screens/add_to_playlist_screen.dart';
import 'package:finamp/screens/album_screen.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/downloads_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/process_artist.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:finamp/services/queue_service.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';

class QueueListItem extends StatefulWidget {
  final FinampQueueItem item;
  final int listIndex;
  final int actualIndex;
  final int indexOffset;
  final List<FinampQueueItem> subqueue;
  final bool isCurrentTrack;
  final bool isPreviousTrack;
  final bool allowReorder;
  final void Function() onTap;

  const QueueListItem({
    Key? key,
    required this.item,
    required this.listIndex,
    required this.actualIndex,
    required this.indexOffset,
    required this.subqueue,
    required this.onTap,
    this.allowReorder = true,
    this.isCurrentTrack = false,
    this.isPreviousTrack = false,
  }) : super(key: key);
  @override
  State<QueueListItem> createState() => _QueueListItemState();
}

class _QueueListItemState extends State<QueueListItem>
    with AutomaticKeepAliveClientMixin {
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _queueService = GetIt.instance<QueueService>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    jellyfin_models.BaseItemDto baseItem = jellyfin_models.BaseItemDto.fromJson(
        widget.item.item.extras?["itemJson"]);

    return Dismissible(
      key: Key(widget.item.id),
      onDismissed: (direction) async {
        Vibrate.feedback(FeedbackType.impact);
        await _queueService.removeAtOffset(widget.indexOffset);
        setState(() {});
      },
      child: GestureDetector(
          onLongPressStart: (details) => showModalSongMenu(
              context: context,
              item: baseItem,
              parentId: widget.item.source.id),
          child: Opacity(
            opacity: widget.isPreviousTrack ? 0.8 : 1.0,
            child: Card(
                color: const Color.fromRGBO(255, 255, 255, 0.075),
                elevation: 0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  visualDensity: VisualDensity.standard,
                  minVerticalPadding: 0.0,
                  horizontalTitleGap: 10.0,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 0.0),
                  tileColor: widget.isCurrentTrack
                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
                      : null,
                  leading: AlbumImage(
                    item: widget.item.item.extras?["itemJson"] == null
                        ? null
                        : jellyfin_models.BaseItemDto.fromJson(
                            widget.item.item.extras?["itemJson"]),
                    borderRadius: BorderRadius.zero,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          widget.item.item.title,
                          style: widget.isCurrentTrack
                              ? TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                  fontFamily: 'Lexend Deca',
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis)
                              : null,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          processArtist(widget.item.item.artist, context),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!,
                              fontSize: 13,
                              fontFamily: 'Lexend Deca',
                              fontWeight: FontWeight.w300,
                              overflow: TextOverflow.ellipsis),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.only(right: 6.0),
                    width: widget.allowReorder
                        ? 72.0
                        : 42.0, //TODO make this responsive
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.item.item.duration?.inMinutes.toString()}:${((widget.item.item.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        if (widget.allowReorder)
                          ReorderableDragStartListener(
                            index: widget.listIndex,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0, left: 6.0),
                              child: Icon(
                                TablerIcons.grip_horizontal,
                                color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
                                size: 28.0,
                                weight: 1.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  onTap: widget.onTap,
                )),
          )),
    );
  }

  void showSongMenu(LongPressStartDetails? details) async {
    final canGoToAlbum = _isAlbumDownloadedIfOffline(
        jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.extras?["itemJson"])
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
                    widget.item.item.extras?["itemJson"])
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
        await _queueService.addToQueue(
            items: [
              jellyfin_models.BaseItemDto.fromJson(
                  widget.item.item.extras?["itemJson"])
            ],
            source: QueueItemSource(
                type: QueueItemSourceType.unknown,
                name: QueueItemSourceName(
                    type: QueueItemSourceNameType.preTranslated,
                    pretranslatedName: AppLocalizations.of(context)!.queue),
                id: widget.item.source.id));

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.addedToQueue),
        ));
        break;

      case SongListTileMenuItems.playNext:
        await _queueService.addNext(items: [
          jellyfin_models.BaseItemDto.fromJson(
              widget.item.item.extras?["itemJson"])
        ]);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.confirmPlayNext("track")),
        ));
        break;

      case SongListTileMenuItems.addToNextUp:
        await _queueService.addToNextUp(items: [
          jellyfin_models.BaseItemDto.fromJson(
              widget.item.item.extras?["itemJson"])
        ]);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(AppLocalizations.of(context)!.confirmAddToNextUp("track")),
        ));
        break;

      case SongListTileMenuItems.addToPlaylist:
        Navigator.of(context).pushNamed(AddToPlaylistScreen.routeName,
            arguments: jellyfin_models.BaseItemDto.fromJson(
                    widget.item.item.extras?["itemJson"])
                .id);
        break;

      case SongListTileMenuItems.instantMix:
        await _audioServiceHelper.startInstantMixForItem(
            jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.extras?["itemJson"]));

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
                      widget.item.item.extras?["itemJson"])
                  .parentId!)!
              .item;
        } else {
          // If online, get the album's BaseItemDto from the server.
          try {
            album = await _jellyfinApiHelper.getItemById(
                jellyfin_models.BaseItemDto.fromJson(
                        widget.item.item.extras?["itemJson"])
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
                widget.item.item.extras?["itemJson"])
            .userData!
            .isFavorite = !jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.extras?["itemJson"])
            .userData!
            .isFavorite;
      });

      // Since we flipped the favourite state already, we can use the flipped
      // state to decide which API call to make
      final newUserData = jellyfin_models.BaseItemDto.fromJson(
                  widget.item.item.extras?["itemJson"])
              .userData!
              .isFavorite
          ? await _jellyfinApiHelper.addFavourite(
              jellyfin_models.BaseItemDto.fromJson(
                      widget.item.item.extras?["itemJson"])
                  .id)
          : await _jellyfinApiHelper.removeFavourite(
              jellyfin_models.BaseItemDto.fromJson(
                      widget.item.item.extras?["itemJson"])
                  .id);

      if (!mounted) return;

      setState(() {
        jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.extras?["itemJson"])
            .userData = newUserData;
      });
    } catch (e) {
      setState(() {
        jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.extras?["itemJson"])
            .userData!
            .isFavorite = !jellyfin_models.BaseItemDto.fromJson(
                widget.item.item.extras?["itemJson"])
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
