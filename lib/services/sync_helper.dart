import 'dart:collection';

import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:finamp/services/downloads_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:logging/logging.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';

class SyncState {
  final Set<String> toAdd;
  final Set<String> toRemove;
  final Set<String> toUpdate;
  final Map<String, BaseItemDto> addItemCache;

  SyncState(this.toAdd, this.toRemove, this.toUpdate, this.addItemCache);
}

class DownloadsSyncHelper {
  final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  final JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final FinampUserHelper _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final Logger logger;

  DownloadsSyncHelper(this.logger);

  void sync(BaseItemDto parentObject, List<BaseItemDto> items) async {
    var syncState = _getSyncState(parentObject.id, items);

    logger.info("Items to be added ${syncState.toAdd}");
    logger.info("Items to be removed ${syncState.toRemove}");
    logger.info("Items with no change ${syncState.toUpdate}");

    await _removeDownloadedItems(parentObject.id, syncState.toRemove);
    await _downloadItems(parentObject, syncState);
  }

  Future<void> _downloadItems(BaseItemDto parentObject, SyncState syncState) async {
    DownloadLocation location = FinampSettingsHelper.finampSettings.downloadLocationsMap.values.first;
    for (String itemToAdd in syncState.toAdd) {
      BaseItemDto? item = syncState.addItemCache.remove(itemToAdd);
      if (item != null) {
        await downloadsHelper.addDownloads(
          items: [item],
          parent: parentObject,
          useHumanReadableNames: location.useHumanReadableNames,
          downloadLocation: location,
          viewId: _finampUserHelper.currentUser!.currentViewId!,
        );
      }
    }
  }

  Future<void> _removeDownloadedItems(String playlistParentId, Set<String> idsToRemove) async {
    var itemsToRemove = idsToRemove.toList();
    await downloadsHelper.deleteDownloadChildren(
        jellyfinItemIds: itemsToRemove,
        deletedFor: itemsToRemove.isEmpty ? null : playlistParentId);

    final downloadParent = downloadsHelper.getDownloadedParent(playlistParentId);
    if (downloadParent != null && downloadParent.downloadedChildren.isEmpty) {
      // only remove parent if there are no children left
      await downloadsHelper.deleteDownloadParent(deletedFor: playlistParentId);
    }
    await downloadsHelper.removeChildFromParent(parentId: playlistParentId, childIds: idsToRemove.toList());
  }

  SyncState _getSyncState(String playlistParentId, List<BaseItemDto> existingPlaylistItems) {
    List<DownloadedSong> downloadedSongs = downloadsHelper.downloadedItems.toList();
    Map<String, DownloadedSong> downloadedSongsCache = HashMap();
    Map<String, BaseItemDto> playlistItems = HashMap();
    for (BaseItemDto item in existingPlaylistItems) {
      // songs actively in playlist
      playlistItems.putIfAbsent(item.id, () => item);
    }

    for (DownloadedSong downloadedSong in downloadedSongs) {
      if (downloadedSong.mediaSourceInfo.id != null &&
          downloadedSong.requiredBy.contains(playlistParentId)) {
        // songs actively downloaded
        downloadedSongsCache.putIfAbsent(downloadedSong.mediaSourceInfo.id!, () => downloadedSong);
      }
    }

    Set<String> playlistIds = playlistItems.keys.toSet();
    Set<String> downloadedIds = downloadedSongsCache.keys.toSet();
    return SyncState(
        playlistIds.difference(downloadedIds),
        downloadedIds.difference(playlistIds),
        playlistIds.intersection(downloadedIds),
        playlistItems);
  }
}