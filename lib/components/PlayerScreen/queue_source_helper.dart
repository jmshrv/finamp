import 'dart:async';

import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/screens/album_screen.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/screens/music_screen.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/downloads_service.dart';
import '../../services/jellyfin_api_helper.dart';
import '../confirmation_prompt_dialog.dart';

void navigateToSource(BuildContext context, QueueItemSource source) {
  switch (source.type) {
    case QueueItemSourceType.album:
    case QueueItemSourceType.nextUpAlbum:
      Navigator.of(context)
          .pushNamed(AlbumScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.artist:
    case QueueItemSourceType.nextUpArtist:
      Navigator.of(context)
          .pushNamed(ArtistScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.genre:
      Navigator.of(context)
          .pushNamed(ArtistScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.playlist:
    case QueueItemSourceType.nextUpPlaylist:
      Navigator.of(context)
          .pushNamed(AlbumScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.albumMix:
      Navigator.of(context)
          .pushNamed(AlbumScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.artistMix:
      Navigator.of(context)
          .pushNamed(ArtistScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.allSongs:
      Navigator.of(context).pushNamed(MusicScreen.routeName,
          arguments: FinampSettingsHelper.finampSettings.showTabs.entries
              .where((element) => element.value == true)
              .map((e) => e.key)
              .toList()
              .indexOf(TabContentType.songs));
      break;
    case QueueItemSourceType.nextUp:
      break;
    case QueueItemSourceType.formerNextUp:
      break;
    case QueueItemSourceType.unknown:
      break;
    case QueueItemSourceType.favorites:
    case QueueItemSourceType.songMix:
    case QueueItemSourceType.filteredList:
    case QueueItemSourceType.downloads:
    default:
      FeedbackHelper.feedback(FeedbackType.warning);
      GlobalSnackbar.message(
        (scaffold) => "Not implemented yet.",
      );
  }
}

Future<bool> removeFromPlaylist(BuildContext context, BaseItemDto item,
    BaseItemDto parent, String playlistItemId,
    {required bool confirm}) async {
  bool isConfirmed = !confirm;
  if (confirm) {
    await showDialog(
      context: context,
      builder: (context) => ConfirmationPromptDialog(
        promptText: AppLocalizations.of(context)!.removeFromPlaylistPrompt(
            item.name ?? "item", parent.name ?? "playlist"),
        confirmButtonText:
            AppLocalizations.of(context)!.removeFromPlaylistConfirm,
        abortButtonText: AppLocalizations.of(context)!.genericCancel,
        onConfirmed: () {
          isConfirmed = true;
        },
        onAborted: () {
          isConfirmed = false;
        },
      ),
    );
  }
  if (isConfirmed) {
    try {
      await GetIt.instance<JellyfinApiHelper>().removeItemsFromPlaylist(
          playlistId: parent.id, entryIds: [playlistItemId]);

      // re-sync playlist to delete removed item if not required anymore
      final downloadsService = GetIt.instance<DownloadsService>();
      unawaited(downloadsService.resync(
          DownloadStub.fromItem(
              type: DownloadItemType.collection, item: parent),
          null,
          keepSlow: true));

      playlistRemovalsCache.add(parent.id + playlistItemId);

      GlobalSnackbar.message(
          (context) => AppLocalizations.of(context)!.removedFromPlaylist,
          isConfirmation: true);
      return true;
    } catch (err) {
      GlobalSnackbar.error(err);
      return false;
    }
  }
  return false;
}

Future<bool> addItemToPlaylist(
    BuildContext context, BaseItemDto item, BaseItemDto parent) async {
  //TODO request server to return the new playlist item id
  await GetIt.instance<JellyfinApiHelper>()
      .addItemstoPlaylist(playlistId: parent.id, ids: [item.id]);

  // re-sync playlist to download added item if needed
  final downloadsService = GetIt.instance<DownloadsService>();
  unawaited(downloadsService.resync(
      DownloadStub.fromItem(type: DownloadItemType.collection, item: parent),
      null,
      keepSlow: true));

  GlobalSnackbar.message(
      (scaffold) => AppLocalizations.of(context)!.confirmAddedToPlaylist,
      isConfirmation: true);
  return true;
}

// Removed playlist items will persist in queue with playlist source.  Store removed items
// to hide remove from playlist prompt on those items.
final Set<String> playlistRemovalsCache = {};

bool queueItemInPlaylist(FinampQueueItem? queueItem) {
  if (queueItem == null) {
    return false;
  }
  final baseItem = queueItem.baseItem;
  return [QueueItemSourceType.playlist, QueueItemSourceType.nextUpPlaylist]
          .contains(queueItem.source.type) &&
      baseItem?.playlistItemId != null &&
      !playlistRemovalsCache
          .contains(queueItem.source.id + (baseItem?.playlistItemId ?? ""));
}
