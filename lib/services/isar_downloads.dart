import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path_helper;

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import 'download_update_stream.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';

final downloadStatusProvider =
    StreamProvider.family<DownloadItemState, DownloadStub>((ref, stub) {
  final isar = GetIt.instance<Isar>();
  return isar.downloadItems
      .watchObject(stub.isarId, fireImmediately: true)
      .map((event) => event?.state ?? DownloadItemState.notDownloaded);
});

class IsarDownloads {
  IsarDownloads() {
    _downloadUpdateStream.stream.listen((event) {
      _isar.writeTxn(() async {
        List<DownloadItem> listeners = await _isar.downloadItems
            .filter()
            .downloadIdEqualTo(event.id)
            .findAll();
        for (var listener in listeners) {
          switch (event.status) {
            case DownloadTaskStatus.undefined:
              listener.state = DownloadItemState.failed;
            case DownloadTaskStatus.enqueued:
              listener.state = DownloadItemState.downloading;
            case DownloadTaskStatus.running:
              listener.state = DownloadItemState.downloading;
            case DownloadTaskStatus.complete:
              listener.state = DownloadItemState.complete;
            case DownloadTaskStatus.failed:
              listener.state = DownloadItemState.failed;
            case DownloadTaskStatus.canceled:
              listener.state = DownloadItemState.failed;
            case DownloadTaskStatus.paused:
              listener.state = DownloadItemState.paused;
          }
        }
        await _isar.downloadItems.putAll(listeners);
      });

      //TODO propogate up to set parent download state to downloading/failed/complete
    });
  }

  final _downloadsLogger = Logger("IsarDownloads");

  final _jellyfinApiData = GetIt.instance<JellyfinApiHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _isar = GetIt.instance<Isar>();
  final _downloadUpdateStream = GetIt.instance<DownloadUpdateStream>();

  final _anchor =
      DownloadStub.fromId(id: "Anchor", type: DownloadItemType.anchor);

  Future<List<DownloadStub>> _getCollectionInfo(List<String> ids) async {
    List<DownloadItem?> downloadItems = [];
    List<DownloadItem?> infoItems = [];
    List<DownloadStub> output = [];
    List<String> idsToQuery = [];
    await _isar.txn(() async {
      downloadItems = await _isar.downloadItems.getAll(ids
          .map((e) =>
              DownloadStub.getHash(e, DownloadItemType.collectionDownload))
          .toList());
      infoItems = await _isar.downloadItems.getAll(ids
          .map((e) => DownloadStub.getHash(e, DownloadItemType.collectionInfo))
          .toList());
    });
    for (int i = 0; i < ids.length; i++) {
      if (infoItems[i] != null) {
        output.add(infoItems[i]!);
      } else if (downloadItems[i]?.baseItem != null) {
        output.add(DownloadStub.fromItem(
            type: DownloadItemType.collectionInfo,
            item: downloadItems[i]!.baseItem!));
      } else {
        idsToQuery.add(ids[i]);
      }
    }
    if (idsToQuery.isNotEmpty) {
      // TODO error handling so we can keep syncing other items
      List<BaseItemDto> items =
          await _jellyfinApiData.getItems(itemIds: idsToQuery) ?? [];
      output.addAll(items.map((e) => DownloadStub.fromItem(
          type: DownloadItemType.collectionInfo, item: e)));
    }
    return output;
  }

  // Make sure the parent and all children are in the metadata collection,
  // and downloaded.
  Future<void> _syncDownload(
      DownloadStub parent, List<DownloadStub> completed) async {
    if (completed.contains(parent)) {
      return;
    } else {
      completed.add(parent);
    }

    bool updateChildren = true;
    Set<DownloadStub> children = {};
    switch (parent.type) {
      case DownloadItemType.collectionDownload:
        var item = parent.baseItem!;
        if (item.blurHash != null) {
          children.add(
              DownloadStub.fromItem(type: DownloadItemType.image, item: item));
        }
        List<BaseItemDto>? items = await _jellyfinApiData.getItems(
                // TODO error handling so we can keep syncing other items
                parentItem: item) ??
            [];
        for (var child in items) {
          children.add(
              DownloadStub.fromItem(type: DownloadItemType.song, item: child));
        }
        // TODO remove unless we start storing orders here
        // Make sure playlists are accounted for if doing so - songs don't backlink them
        children.add(DownloadStub.fromItem(
            type: DownloadItemType.collectionInfo, item: item));
      case DownloadItemType.song:
        var item = parent.baseItem!;
        if (item.blurHash != null) {
          children.add(
              DownloadStub.fromItem(type: DownloadItemType.image, item: item));
        }
        List<String> collectionIds = [];
        collectionIds.addAll(item.genreItems?.map((e) => e.id) ?? []);
        collectionIds.addAll(item.artistItems?.map((e) => e.id) ?? []);
        collectionIds.addAll(item.albumArtists?.map((e) => e.id) ?? []);
        if (item.albumId != null) {
          collectionIds.add(item.albumId!);
        }
        children.addAll(await _getCollectionInfo(collectionIds));
      case DownloadItemType.image:
        break;
      case DownloadItemType.anchor:
        updateChildren = false;
      case DownloadItemType.favorites:
        throw UnimplementedError(parent.toString());
      case DownloadItemType.collectionInfo:
        var item = parent.baseItem!;
        if (item.blurHash != null) {
          children.add(
              DownloadStub.fromItem(type: DownloadItemType.image, item: item));
        }
    }

    // oldChildren: outdated linked children
    // existingChildren: new children already in database
    // missingChildren: children to be added to database + links
    // exccessChildren: children to be removed from links
    // otherChildren: children to be added to links that are already in database
    // addedChildren: all children to be added to links
    Set<DownloadItem> excessChildren = {};
    DownloadLocation? downloadLocation;
    if (updateChildren) {
      //TODO update core item with latest
      await _isar.writeTxn(() async {
        // TODO clean up this mess
        // We don't need up-to-date item to run update
        // It should be fine to delete and re-add.
        // Use query language to filter
        // Overwriting item doesn't affect links.
        DownloadItem? canonParent =
            await _isar.downloadItems.get(parent.isarId);
        if (canonParent == null) {
          throw StateError(
              "_syncDownload ccalled on missing node ${parent.id}");
        }
        downloadLocation = canonParent.downloadLocation;

        var oldChildren =
            (await canonParent.requires.filter().findAll()).toSet();
        var nullableExistingChildren = (await _isar.downloadItems
                .getAll(children.map((e) => e.isarId).toList()))
            .toSet();
        nullableExistingChildren.remove(null);
        var existingChildren = nullableExistingChildren.cast<DownloadItem>();
        var missingChildren = children
            .difference(existingChildren)
            .map((e) => e.asItem(downloadLocation?.id))
            .toSet();
        excessChildren = oldChildren.difference(children);
        var otherChildren = existingChildren.difference(oldChildren);
        var addedChildren = missingChildren.union(otherChildren);
        await _isar.downloadItems.putAll(missingChildren.toList());
        await canonParent.requires
            .update(link: addedChildren, unlink: excessChildren);
      });
    } else {
      await _isar.txn(() async {
        downloadLocation =
            (await _isar.downloadItems.get(parent.isarId))?.downloadLocation;
        children = (await _isar.downloadItems
                .filter()
                .requiredBy((q) => q.isarIdEqualTo(parent.isarId))
                .findAll())
            .toSet();
      });
    }

    if (downloadLocation == null) {
      _downloadsLogger.severe(
          "could not download ${parent.id}, no download location found.");
    } else {
      await _initiateDownload(parent, downloadLocation!);
    }

    for (var child in children) {
      await _syncDownload(child, completed);
    }
    for (var child in excessChildren) {
      await _syncDelete(child);
    }
  }

  Future<void> _syncDelete(DownloadStub item) async {
    DownloadItem? canonItem = await _isar.downloadItems.get(item.isarId);
    if (canonItem == null ||
        canonItem.requiredBy.isNotEmpty ||
        canonItem.type == DownloadItemType.anchor) {
      return;
    }

    if (item.type.hasFiles) {
      await _deleteDownload(canonItem);
    }

    Set<DownloadItem> children = {};
    await _isar.writeTxn(() async {
      DownloadItem? transactionItem =
          await _isar.downloadItems.get(canonItem.isarId);
      if (transactionItem == null) {
        return;
      }
      children = (await transactionItem.requires.filter().findAll()).toSet();
      if (transactionItem.type == DownloadItemType.image ||
          transactionItem.type == DownloadItemType.song) {
        if (transactionItem.state != DownloadItemState.notDownloaded) {
          _downloadsLogger.severe(
              "Could not delete ${transactionItem.id}, may still have files");
          throw StateError(
              "Could not delete ${transactionItem.id}, may still have files");
        }
      }
      await _isar.downloadItems.delete(transactionItem.isarId);
    });

    // TODO consolidate deletes until after all syncs to prevent extra download in special circumstances?
    for (var child in children) {
      await _syncDelete(child);
    }
  }

  Future<void> addDownload({
    required DownloadStub stub,
    required DownloadLocation downloadLocation,
  }) async {
    if (downloadLocation.deletable) {
      if (!await Permission.storage.request().isGranted) {
        _downloadsLogger.severe("Storage permission is not granted, exiting");
        return Future.error(
            "Storage permission is required for external storage");
      }
    }

    await _isar.writeTxn(() async {
      DownloadItem canonItem = await _isar.downloadItems.get(stub.isarId) ??
          stub.asItem(downloadLocation.id);
      canonItem.downloadLocationId = downloadLocation.id;
      await _isar.downloadItems.put(canonItem);
      var anchorItem = _anchor.asItem(null);
      await _isar.downloadItems.put(anchorItem);
      await anchorItem.requires.update(link: [canonItem]);
    });

    return _syncDownload(stub, []).onError((error, stackTrace) {
      _downloadsLogger.severe("Isar failure $error", error, stackTrace);
      throw error!;
    });
  }

  Future<void> deleteDownload({required DownloadStub stub}) async {
    await _isar.writeTxn(() async {
      var anchorItem = _anchor.asItem(null);
      await _isar.downloadItems.put(anchorItem);
      await anchorItem.requires.update(unlink: [stub.asItem(null)]);
    });

    return _syncDelete(stub).onError((error, stackTrace) {
      _downloadsLogger.severe("Isar failure $error", error, stackTrace);
      throw error!;
    });
  }

  Future<void> resyncAll() async {
    return _syncDownload(_anchor, []).onError((error, stackTrace) {
      _downloadsLogger.severe("Isar failure $error", error, stackTrace);
      throw error!;
    });
  }

  Future<void> _initiateDownload(
      DownloadStub item, DownloadLocation downloadLocation) async {
    DownloadItem? canonItem = await _isar.downloadItems.get(item.isarId);
    if (canonItem == null) {
      _downloadsLogger.severe(
          "Download metadata ${item.id} missing before download starts");
      return;
    }

    if (!item.type.hasFiles) {
      return;
    }

    switch (canonItem.state) {
      case DownloadItemState.complete:
        return; // TODO maybe run verify here?
      case DownloadItemState.notDownloaded:
        break;
      case DownloadItemState.downloading:
        return; //TODO figure out what to do here - see if it failed somehow?  Check task status
      case DownloadItemState.failed:
        await _deleteDownload(canonItem);
      case DownloadItemState.deleting:
        _downloadsLogger.info(
            "Could not download item ${item.id}, it is currently being deleted.");
        // TODO get out of this state if error while deleting somehow - during full cleanup sweep?
        return;
      case DownloadItemState.paused:
      // TODO: I have no idea what to do about this.
    }
    switch (canonItem.type) {
      case DownloadItemType.song:
        return _downloadSong(canonItem, downloadLocation);
      case DownloadItemType.image:
        return _downloadImage(canonItem, downloadLocation);
      case _:
        throw StateError("???");
    }
  }

  Future<void> _downloadSong(
      DownloadItem downloadItem, DownloadLocation downloadLocation) async {
    assert(downloadItem.type == DownloadItemType.song);
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
      DownloadItem? canonItem =
          await _isar.downloadItems.get(downloadItem.isarId);
      if (canonItem == null) {
        _downloadsLogger.severe(
            "Download metadata ${downloadItem.id} missing after download starts");
        throw StateError("Could not save download task id");
      }
      canonItem.downloadId = songDownloadId!;
      canonItem.downloadLocationId = downloadLocation.id;
      canonItem.path = path_helper.relative(
          path_helper.join(downloadDir.path, fileName),
          from: downloadLocation.path);
      canonItem.mediaSourceInfo = mediaSourceInfo![0];
      canonItem.state = DownloadItemState.downloading;
      await _isar.downloadItems.put(canonItem);
    });
  }

  Future<void> _downloadImage(
      DownloadItem downloadItem, DownloadLocation downloadLocation) async {
    assert(downloadItem.type == DownloadItemType.image);
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
      DownloadItem? canonItem =
          await _isar.downloadItems.get(downloadItem.isarId);
      if (canonItem == null) {
        _downloadsLogger.severe(
            "Download metadata ${downloadItem.id} missing after download starts");
        throw StateError("Could not save download task id");
      }
      canonItem.downloadId = imageDownloadId!;
      canonItem.downloadLocationId = downloadLocation.id;
      canonItem.path = path_helper.join(relativePath, fileName);
      canonItem.state = DownloadItemState.downloading;
      await _isar.downloadItems.put(canonItem);
    });
  }

  Future<void> _deleteDownload(DownloadItem item) async {
    assert(item.type.hasFiles);
    if (item.state == DownloadItemState.notDownloaded ||
        item.state == DownloadItemState.deleting) {
      // TODO find out what happens if we delete somthing already deleted
      return;
    }

    await _isar.writeTxn(() async {
      item.state = DownloadItemState.deleting;
      await _isar.downloadItems.put(item);
    });

    await FlutterDownloader.remove(
      taskId: item.downloadId!,
      shouldDeleteContent: true,
    );

    if (item.downloadLocation != null &&
        item.downloadLocation!.useHumanReadableNames) {
      Directory songDirectory = item.file.parent;
      if (await songDirectory.list().isEmpty) {
        _downloadsLogger.info("${songDirectory.path} is empty, deleting");
        await songDirectory.delete();
      }
    }

    // TODO verify files are actually gone?

    await _isar.writeTxn(() async {
      // TODO reverify we are in deleting state
      item.state = DownloadItemState.notDownloaded;
      item.downloadId = null;
      await _isar.downloadItems.put(item);
    });
  }

  Future<bool> verifyDownload(DownloadStub stub) async {
    return true; // TODO implement
  }

  // TODO add listener to download events - currently irregular, probably a flutter_downloader thing.
  // TODO - include way to mark parent as downloaded if all children complete and non-download type.

  // TODO design accessing API, begin moving widgets.
  // need to analyze existing accessors more.
  // need item watcher for download/download status buttons- check how they do delete vs. sync
  // need some way to get list of items by type
  // need to get exact song/image items

  // TODO think about downloader migration

  // TODO add sync all method that syncs anchor

  // TODO add verify downloads method
  // does whatever happens in download helper to verify downloads working
  // runs syncDelete on every item in collection
  // checks for orphaned files and cleans them up.

  // TODO add migration method
  // - first go through boxes and create nodes for all downloaded images/songs
  // then go through all downloaded parents and create anchor-attached nodes - maybe delay recursive sync.
  // then run full sync from anchor to connect up all nodes - maybe fine to refresh all metadata?
  //      maybe we should delay until app started?  and then trigger standard full sync task to stitch everything?
  // then run delete check across all downloaded items - standards download verify as trigerable from settings or something?
  // then delete box content, marking migration finished - can we do this before full sync finishes?

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

  List<DownloadItem> getUserDownloaded() => getAllChildren(_anchor);

  List<DownloadItem> getAllChildren(DownloadStub stub) {
    return _isar.downloadItems
        .filter()
        .requiredBy((q) => q.isarIdEqualTo(stub.isarId))
        .findAllSync();
  }

  // TODO figure out what to do about sort order
  // TODO try to make this one query?
  List<DownloadItem> getCollectionSongs(BaseItemDto item) {
    _downloadsLogger.severe("Getting songs for ${item.name}");
    var metadata1 = _isar.downloadItems.getSync(
        DownloadStub.fromItem(type: DownloadItemType.collectionInfo, item: item)
            .isarId);
    var metadata2 = _isar.downloadItems.getSync(
        DownloadStub.fromItem(type: DownloadItemType.collectionDownload, item: item)
            .isarId);
    if (metadata1==null && metadata2==null) return [];
    QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> subQuery(QueryBuilder<DownloadItem, DownloadItem, QFilterCondition> q) {
      if (metadata2 == null){
        return q.requires((q) => q.isarIdEqualTo(metadata1!.isarId));
      } else if (metadata1 == null){
        return q.requiredBy((q) => q.isarIdEqualTo(metadata2!.isarId));
      } else {
        return q.requires((q) => q.isarIdEqualTo(metadata1!.isarId)).or().requiredBy((q) => q.isarIdEqualTo(metadata2!.isarId));
      }

    }
      return _isar.downloadItems
          .filter().group(subQuery)
          .typeEqualTo(DownloadItemType.song)
          .stateEqualTo(DownloadItemState.complete)
          .findAllSync();
  }

  Future<List<DownloadItem>> getAllSongs({int? limit}) {
    var query = _isar.downloadItems
        .filter()
        .typeEqualTo(DownloadItemType.song)
        .stateEqualTo(DownloadItemState.complete);
    if (limit == null) {
      return query.findAll();
    } else {
      return query.limit(limit).findAll();
    }
  }

  // TODO decide if we want all possible collections or just hard-downloaded ones.
  Future<List<DownloadItem>> getAllCollections() {
    return _isar.downloadItems
        .filter()
        .typeEqualTo(DownloadItemType.collectionInfo)
        .findAll();
  }

  DownloadItem? getImageDownload(BaseItemDto item) => getDownload(
      DownloadStub.fromItem(type: DownloadItemType.image, item: item));
  DownloadItem? getSongDownload(BaseItemDto item) => getDownload(
      DownloadStub.fromItem(type: DownloadItemType.song, item: item));
  DownloadItem? getMetadataDownload(BaseItemDto item) => getDownload(
      DownloadStub.fromItem(type: DownloadItemType.collectionInfo, item: item));
  DownloadItem? getDownload(DownloadStub stub) {
    var item = _isar.downloadItems.getSync(stub.isarId);
    if ((item?.type.hasFiles ?? true) &&
        item?.state != DownloadItemState.complete) {
      return null;
    }
    return item;
  }

  DownloadItem? getAlbumDownloadFromSong(BaseItemDto song) {
    if (song.albumId == null) return null;
    return _isar.downloadItems.getSync(
        DownloadStub.getHash(song.albumId!, DownloadItemType.collectionInfo));
  }

  int getDownloadCount(DownloadItemType type) {
    return _isar.downloadItems.filter().typeEqualTo(type).countSync();
  }
}
