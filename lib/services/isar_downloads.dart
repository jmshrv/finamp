import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path_helper;

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';

class IsarDownloads {
  IsarDownloads();

  final _downloadsLogger = Logger("IsarDownloads");
  
  final _jellyfinApiData = GetIt.instance<JellyfinApiHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _isar = GetIt.instance<Isar>();

  // Make sure the parent and all children are in the metadata collection,
  // and downloaded.  This may be called with a download stub.
  Future<void> syncDownload(
      DownloadedItem parent, List<DownloadedItem> completed, DownloadLocation downloadLocation) async {

    if (completed.contains(parent)) {
      return;
    } else {
      completed.add(parent);
    }

    Set<DownloadedItem> children = {};
    switch (parent.type) {
      case DownloadedItemType.album || DownloadedItemType.playlist:
        var item = parent.baseItem!;
        if (item.blurHash != null) {
          children.add(DownloadedItem.fromItem(
              type: DownloadedItemType.image,
              item: item));
        }
        List<BaseItemDto>? items = await _jellyfinApiData.getItems(
                isGenres: false, parentItem: item) ??
            [];
        for (var child in items) {
          children.add(DownloadedItem.fromItem(
              type: DownloadedItemType.song, item: child));
        }
      case DownloadedItemType.song:
        var item = parent.baseItem!;
        if (item.blurHash != null) {
          children.add(DownloadedItem.fromItem(
              type: DownloadedItemType.image,
              item: item));
        }
      case _:
        break;
    }

    // oldChildren: outdated linked children
    // existingChildren: new children already in database
    // missingChildren: children to be added to database + links
    // exccesschildren: children to be removed from links
    // otherChildren: children to be added to links that are already in database
    // addedChildren: all children to be added to links
    Set<DownloadedItem> excessChildren = {};
    await _isar.writeTxn(() async {
      DownloadedItem canonParent =
          await _isar.downloadedItems.get(parent.isarId) ?? parent;
      await _isar.downloadedItems.put(canonParent);
      var oldChildren = (await canonParent.requires.filter().findAll()).toSet();
      var nullableExistingChildren = (await _isar.downloadedItems
          .getAll(children.map((e) => e.isarId).toList())).toSet();
      nullableExistingChildren.remove(null);
      var existingChildren = nullableExistingChildren.cast<DownloadedItem>();
      var missingChildren = children.difference(existingChildren);
      excessChildren = oldChildren.difference(children);
      var otherChildren = existingChildren.difference(oldChildren);
      var addedChildren = missingChildren.union(otherChildren);
      await _isar.downloadedItems.putAll(missingChildren.toList());
      await canonParent.requires.update(link: addedChildren, unlink: excessChildren);
    });

    await initiateDownload(parent, downloadLocation);

    for (var child in children) {
      await syncDownload(child, completed, downloadLocation);
    }
    for (var child in excessChildren) {
      await syncDelete(child,true);
    }
  }

  // This function may be called with a download stub
  Future<void> syncDelete(DownloadedItem item, bool recurse) async {
    DownloadedItem? canonItem = await _isar.downloadedItems.get(item.isarId);
    if (canonItem==null || canonItem.requiredBy.isNotEmpty){
      return;
    }
    await _deleteDownload(canonItem);

    Set<DownloadedItem> children = {};
    await _isar.writeTxn(() async {
      DownloadedItem? transactionItem = await _isar.downloadedItems.get(canonItem.isarId);
      if (transactionItem == null){
        return;
      }
      children = (await transactionItem.requires.filter().findAll()).toSet();
      await _isar.downloadedItems.delete(transactionItem.isarId);
    });

    if (recurse){
      for (var child in children) {
        await syncDelete(child,true);
      }
    }
  }

  // TODO add top level item to attach these to.
  // TODO add syncDelete top method
  Future<void> syncItem({
    required BaseItemDto item,
    required DownloadedItemType type,
    required DownloadLocation downloadLocation,
  }) async {

    if (downloadLocation.deletable) {
      if (!await Permission.storage.request().isGranted) {
        _downloadsLogger.severe("Storage permission is not granted, exiting");
        return Future.error(
            "Storage permission is required for external storage");
      }
    }

    return syncDownload(
            DownloadedItem.fromItem(type: type, item: item), [], downloadLocation)
        .onError((error, stackTrace) {
      _downloadsLogger.severe("Isar failure $error", error, stackTrace);
      throw error!;
    });
  }

  // This function may be called with a download stub
  Future<void> initiateDownload(DownloadedItem item, DownloadLocation downloadLocation) async {
    DownloadedItem? canonItem = await _isar.downloadedItems.get(item.isarId);
    if (canonItem==null){
      _downloadsLogger.severe("Download metadata ${item.id} missing before download starts");
      return;
    }
    switch(canonItem.state){
      case DownloadedItemState.complete: return;
      case DownloadedItemState.notDownloaded: break;
      case DownloadedItemState.downloading: return;//TODO figure out what to do here - see if it failed somehow?
      case DownloadedItemState.failed: await _deleteDownload(canonItem);
      case DownloadedItemState.deleting:
        _downloadsLogger.info("Could not download item ${item.id}, it is currently being deleted.");
        // TODO get out of this state if error while deleting
        return;
    }
    switch (canonItem.type){
      case DownloadedItemType.song:
        return _downloadSong(canonItem ,downloadLocation);
      case DownloadedItemType.image:
        return _downloadImage(canonItem ,downloadLocation);
      case _ : return;
    }
  }

  Future<void> _downloadSong(DownloadedItem downloadItem, DownloadLocation downloadLocation) async {
    assert(downloadItem.type == DownloadedItemType.song);
    bool useHumanReadableNames = downloadLocation.useHumanReadableNames;
    var item = downloadItem.baseItem!;

    // Base URL shouldn't be null at this point (user has to be logged in
    // to get to the point where they can add downloads).
    String songUrl =
        "${_finampUserHelper.currentUser!.baseUrl}/Items/${item.id}/File";

    List<MediaSourceInfo>? mediaSourceInfo =
    await _jellyfinApiData.getPlaybackInfo(item.id);

    String fileName;
    Directory downloadDir = await _getDownloadDirectory(
      item: item,
      downloadBaseDir: Directory(downloadLocation.path),
      useHumanReadableNames: useHumanReadableNames,
    );
    if (useHumanReadableNames) {
      if (mediaSourceInfo == null) {
        _downloadsLogger.warning(
            "Media source info for ${item.id} returned null, filename may be weird.");
      }
      // We use a regex to filter out bad characters from song/album names.
      fileName =
      "${item.album?.replaceAll(RegExp('[/?<>\\:*|"]'), "_")} - ${item.indexNumber ?? 0} - ${item.name?.replaceAll(RegExp('[/?<>\\:*|"]'), "_")}.${mediaSourceInfo?[0].container}";
    } else {
      fileName = "${item.id}.${mediaSourceInfo?[0].container}";
      downloadDir = Directory(downloadLocation.path);
    }

    String? tokenHeader = _jellyfinApiData.getTokenHeader();

    String? songDownloadId = await FlutterDownloader.enqueue(
      url: songUrl,
      savedDir: downloadDir.path,
      headers: {
        if (tokenHeader != null) "X-Emby-Token": tokenHeader,
      },
      fileName: fileName,
      openFileFromNotification: false,
      showNotification: false,
    );

    if (songDownloadId == null) {
      _downloadsLogger.severe(
          "Adding download for ${item.id} failed! downloadId is null. This only really happens if something goes horribly wrong with flutter_downloader's platform interface. This should never happen...");
    }

    await _isar.writeTxn(() async {
      DownloadedItem? canonItem = await _isar.downloadedItems.get(downloadItem.isarId);
      if (canonItem==null){
        _downloadsLogger.severe("Download metadata ${downloadItem.id} missing after download starts");
        throw StateError("Could not save download task id");
      }
      canonItem.downloadId = songDownloadId!;
      canonItem.downloadLocationId = downloadLocation.id;
      canonItem.path = path_helper.relative(
          path_helper.join(downloadDir.path, fileName),
          from: downloadLocation.path);
      canonItem.mediaSourceInfo = mediaSourceInfo![0];
      canonItem.state = DownloadedItemState.downloading;
      await _isar.downloadedItems.put(canonItem);
    });
  }

  Future<void> _downloadImage(DownloadedItem downloadItem, DownloadLocation downloadLocation) async {
    assert(downloadItem.type == DownloadedItemType.image);
    var item = downloadItem.baseItem!;
    bool useHumanReadableNames = downloadLocation.useHumanReadableNames;

    final downloadDir = await _getDownloadDirectory(
      item: item,
      downloadBaseDir: Directory(downloadLocation.path),
      useHumanReadableNames: useHumanReadableNames,
    );

    final imageUrl = _jellyfinApiData.getImageUrl(
      item: item,
      // Download original file
      quality: null,
      format: null,
    );
    final tokenHeader = _jellyfinApiData.getTokenHeader();
    final relativePath =
    path_helper.relative(downloadDir.path, from: downloadLocation.path);

    // We still use imageIds for filenames despite switching to blurhashes as
    // blurhashes can include characters that filesystems don't support
    final fileName = item.imageId;

    final imageDownloadId = await FlutterDownloader.enqueue(
      url: imageUrl.toString(),
      savedDir: downloadDir.path,
      headers: {
        if (tokenHeader != null) "X-Emby-Token": tokenHeader,
      },
      fileName: fileName,
      openFileFromNotification: false,
      showNotification: false,
    );

    if (imageDownloadId == null) {
      _downloadsLogger.severe(
          "Adding image download for ${item.blurHash} failed! downloadId is null. This only really happens if something goes horribly wrong with flutter_downloader's platform interface. This should never happen...");
    }

    await _isar.writeTxn(() async {
      DownloadedItem? canonItem = await _isar.downloadedItems.get(downloadItem.isarId);
      if (canonItem==null){
        _downloadsLogger.severe("Download metadata ${downloadItem.id} missing after download starts");
        throw StateError("Could not save download task id");
      }
      canonItem.downloadId = imageDownloadId!;
      canonItem.downloadLocationId = downloadLocation.id;
      canonItem.path = path_helper.join(relativePath, fileName);
      canonItem.state = DownloadedItemState.downloading;
      await _isar.downloadedItems.put(canonItem);
    });
  }

  Future<void> _deleteDownload(DownloadedItem item) async {
    if (item.state == DownloadedItemState.notDownloaded || item.state == DownloadedItemState.deleting){
      // TODO find out what happens if we delete somthing already deleted
      return;
    }

    await _isar.writeTxn(() async {
      item.state = DownloadedItemState.deleting;
      await _isar.downloadedItems.put(item);
    });

    await FlutterDownloader.remove(
      taskId: item.downloadId!,
      shouldDeleteContent: true,
    );

    if (item.downloadLocation != null && item.downloadLocation!.useHumanReadableNames) {
      // We use the parent here since downloadedSong.path still includes
      // the filename. We assume that downloadedSong.path is not null,
      // as if downloadedSong.useHumanReadableNames is true, the path
      // would have been set at some point.
      Directory songDirectory = item.file.parent;
      // Loop through each directory and check if it's empty. If it is, delete the directory.
      if (await songDirectory.list().isEmpty) {
        _downloadsLogger.info("${songDirectory.path} is empty, deleting");
        await songDirectory.delete();
      }
    }

    await _isar.writeTxn(() async {
      item.state = DownloadedItemState.notDownloaded;
      await _isar.downloadedItems.put(item);
    });
  }

  // TODO add listener to download events
  // marks items as downloaded or failed when complete
  // include way to mark parent as downloaded if all children complete and non-download type.

  // TODO design accessing API, begin moving widgets.

  /// Get the download directory for the given item. Will create the directory
  /// if it doesn't exist.
  Future<Directory> _getDownloadDirectory({
    required BaseItemDto item,
    required Directory downloadBaseDir,
    required bool useHumanReadableNames,
  }) async {
    late Directory directory;

    if (useHumanReadableNames) {
      directory =
          Directory(path_helper.join(downloadBaseDir.path, item.albumArtist));
    } else {
      directory = Directory(downloadBaseDir.path);
    }

    if (!await directory.exists()) {
      await directory.create();
    }

    return directory;
  }
}
