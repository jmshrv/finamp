import 'dart:collection';

import 'package:finamp/components/AlbumScreen/download_dialog.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  final List<BaseItemDto> addItemCache;

  SyncState(this.toAdd, this.toRemove, this.toUpdate, this.addItemCache);
}

class DownloadsSyncHelper {
  final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  final JellyfinApiHelper jellyfinApiHelper =
      GetIt.instance<JellyfinApiHelper>();
  final FinampUserHelper _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final Logger logger;

  DownloadsSyncHelper(this.logger);

  void sync(BuildContext context, BaseItemDto parentObject,
      List<BaseItemDto> items) async {
    var syncState = _getSyncState(parentObject.id, items);

    logger.info("Items to be added ${syncState.toAdd}");
    logger.info("Items to be removed ${syncState.toRemove}");
    logger.info("Items with no change ${syncState.toUpdate}");

    await _removeDownloadedItems(parentObject.id, syncState.toRemove);
    await _downloadItems(context, parentObject, syncState);
  }

  Future<void> _downloadItems(BuildContext context, BaseItemDto parentObject,
      SyncState syncState) async {
    final List<BaseItemDto> itemsToDownload = [];

    // we include update items in case any items have been orphaned
    for (String itemToAdd in {...syncState.toAdd, ...syncState.toUpdate}) {
      final cacheIndex = syncState.addItemCache
          .indexWhere((element) => element.id == itemToAdd);
      BaseItemDto? item;
      if (cacheIndex != -1) {
        item = syncState.addItemCache.removeAt(cacheIndex);
      }
      if (item != null) {
        itemsToDownload.add(item);
      }
    }

    final selectedDownloadLocation = FinampSettingsHelper
                .finampSettings.downloadLocationsMap.values.length >
            1
        ? await showDialog<DownloadLocation>(
            context: context,
            builder: (context) => DownloadDialog(
              parents: [parentObject],
              // getItems returns null so we have to null check
              // each element
              items: [itemsToDownload],
              viewId: _finampUserHelper.currentUser!.currentViewId!,
            ),
          )
        : FinampSettingsHelper.finampSettings.downloadLocationsMap.values.first;

    if (itemsToDownload.isNotEmpty && selectedDownloadLocation != null) {
      await downloadsHelper.addDownloads(
        items: itemsToDownload,
        parent: parentObject,
        useHumanReadableNames: selectedDownloadLocation.useHumanReadableNames,
        downloadLocation: selectedDownloadLocation,
        viewId: _finampUserHelper.currentUser!.currentViewId!,
      );
    } else {
      logger.warning("No items to download for parent: ${parentObject.id}");
    }
  }

  Future<void> _removeDownloadedItems(
      String playlistParentId, Set<String> idsToRemove) async {
    var itemsToRemove = idsToRemove.toList();
    await downloadsHelper.deleteDownloadChildren(
        jellyfinItemIds: itemsToRemove,
        deletedFor: itemsToRemove.isEmpty ? null : playlistParentId);

    final downloadParent =
        downloadsHelper.getDownloadedParent(playlistParentId);
    if (downloadParent != null && downloadParent.downloadedChildren.isEmpty) {
      // only remove parent if there are no children left
      await downloadsHelper.deleteDownloadParent(deletedFor: playlistParentId);
    }
    await downloadsHelper.removeChildFromParent(
        parentId: playlistParentId, childIds: idsToRemove.toList());
  }

  SyncState _getSyncState(
      String playlistParentId, List<BaseItemDto> existingPlaylistItems) {
    List<DownloadedSong> downloadedSongs =
        downloadsHelper.downloadedItems.toList();
    List<DownloadedSong> downloadedSongsCache = [];
    List<BaseItemDto> playlistItems = [];
    for (BaseItemDto item in existingPlaylistItems) {
      // songs actively in playlist
      logger.info("Song in playlist id ${item.id} name ${item.name}");
      // playlistItems.putIfAbsent(item.id, () => item);
      if (playlistItems.indexWhere((element) => element.id == item.id) == -1) {
        playlistItems.add(item);
      }
    }

    for (DownloadedSong downloadedSong in downloadedSongs) {
      if (downloadedSong.mediaSourceInfo.id != null &&
          downloadedSong.requiredBy.contains(playlistParentId)) {
        // songs actively downloaded
        logger.info(
            "Downloaded song playlist id ${downloadedSong.mediaSourceInfo.id} name ${downloadedSong.mediaSourceInfo.name} requiredBy ${downloadedSong.requiredBy.toString()}");
        // downloadedSongsCache.putIfAbsent(downloadedSong.mediaSourceInfo.id!, () => downloadedSong);
        if (downloadedSongsCache.indexWhere((element) =>
                element.mediaSourceInfo.id ==
                downloadedSong.mediaSourceInfo.id) ==
            -1) {
          downloadedSongsCache.add(downloadedSong);
        }
      }
    }

    Set<String> playlistIds = playlistItems.map((e) => e.id).toSet();
    Set<String> downloadedIds =
        downloadedSongsCache.map((e) => e.mediaSourceInfo.id!).toSet();
    return SyncState(
        playlistIds.difference(downloadedIds),
        downloadedIds.difference(playlistIds),
        playlistIds.intersection(downloadedIds),
        playlistItems);
  }
}
