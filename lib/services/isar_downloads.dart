import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path_helper;

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import 'download_update_stream.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';

final downloadStatusProvider = StreamProvider.family
    .autoDispose<DownloadItemState, DownloadStub>((ref, stub) {
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
        // TODO save off playlist order info somehow.  Should be present in parentIndexnumber, or call with sort option.
        try {
          List<BaseItemDto> items =
              await _jellyfinApiData.getItems(parentItem: item) ?? [];
          for (var child in items) {
            // TODO allow non-song children.  This might let us download and update entire libraries or other stuff.
            // TODO this gets a song/album mix when run for artist/genre.  Filter it in some way.
            // TODO do we want artist -> songs or artist -> albums -> songs
            children.add(DownloadStub.fromItem(
                type: DownloadItemType.song, item: child));
          }
        } catch (e) {
          _downloadsLogger.info("Error downloading children: $e");
          updateChildren = false;
        }
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
        try {
          children.addAll(await _getCollectionInfo(collectionIds));
        } catch (e) {
          _downloadsLogger.info("Error downloading metadata: $e");
          updateChildren = false;
        }
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

    Set<DownloadItem> childrenToUnlink = {};
    DownloadLocation? downloadLocation;
    if (updateChildren) {
      //TODO update core item with latest?
      // TODO update child ordering once determined
      await _isar.writeTxn(() async {
        DownloadItem? canonParent =
            await _isar.downloadItems.get(parent.isarId);
        if (canonParent == null) {
          throw StateError("_syncDownload called on missing node ${parent.id}");
        }
        downloadLocation = canonParent.downloadLocation;

        var oldChildren = await canonParent.requires.filter().findAll();
        // anyOf filter allows all objects when given empty list, but we want no objects
        var childrenToLink = (children.isEmpty)
            ? <DownloadItem>[]
            : await _isar.downloadItems
                .where()
                .anyOf(children.map((e) => e.isarId),
                    (q, int id) => q.isarIdEqualTo(id))
                .findAll();
        var childrenToPutAndLink = children
            .difference(childrenToLink.toSet())
            .map((e) => e.asItem(downloadLocation?.id));
        childrenToUnlink = oldChildren.toSet().difference(children);
        assert((childrenToLink + childrenToPutAndLink.toList()).length ==
            children.length);
        await _isar.downloadItems.putAll(childrenToPutAndLink.toList());
        await canonParent.requires.update(
            link: childrenToLink + childrenToPutAndLink.toList(),
            unlink: childrenToUnlink);
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
    for (var child in childrenToUnlink) {
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
        return;
      case DownloadItemState.notDownloaded:
        break;
      case DownloadItemState.downloading:
        return; //TODO run update from taskstatus, recurse if changed
      case DownloadItemState.failed:
        await _deleteDownload(canonItem);
      case DownloadItemState.deleting:
        // If items get stuck in this state, repairAllDownloads/verifyDownload should fix it.
        _downloadsLogger.info(
            "Could not download item ${item.id}, it is currently being deleted.");
        return;
      case DownloadItemState.paused:
      // TODO: I have no idea what to do about this.  Rectify in cleanup sweep?
    }

    //TODO verify we don't have a downloadID if proceeding - may need to refetch because it may have updated.

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
      var transactionItem = await _isar.downloadItems.get(item.isarId);
      if (transactionItem?.state != DownloadItemState.deleting) {
        return;
      }
      transactionItem!.state = DownloadItemState.notDownloaded;
      transactionItem.downloadId = null;
      await _isar.downloadItems.put(transactionItem);
    });
  }

  Future<void> repairAllDownloads() async {
    // TODO for all completed, run verifyDownload
    await resyncAll();
    // TODO for all global run _syncdelete
    // TODO get all files in internal directory into list
    // for all global
    //    remove files from list
    // delete all files we couldn't link to metadata
  }

  Future<bool> verifyDownload(DownloadItem item) async {
    return true; // TODO do whatever happens in download helper to verify downloads working
    // Definetly need to resync status to flutter_downloader's taskstatus/actual file presence.
  }

  // TODO need some sort of stream so that musicScreen updates as downloads come in.

  // - first go through boxes and create nodes for all downloaded images/songs
  // then go through all downloaded parents and create anchor-attached nodes, and stitch to children/image.
  // then run standard verify all command - if it fails due to networking the
  Future<void> migrateFromHive() async {
    await _migrateImages();
    await _migrateSongs();
    await _migrateParents();
    try {
      await repairAllDownloads();
    } catch (error) {
      _downloadsLogger.severe("Error $error in hive migration downloads repair.");
      // TODO this should still be fine, the user can re-run verify manually later.
      // TODO we should display this somehow.
    }
    //TODO decide if we want to delete metadata here
  }

  Future<void> _migrateImages() async {
    final downloadedItemsBox = Hive.box<DownloadedSong>("DownloadedItems");
    final downloadedParentsBox = Hive.box<DownloadedParent>("DownloadedParents");
    final downloadedImagesBox = Hive.box<DownloadedImage>("DownloadedImages");

    List<DownloadItem> nodes = [];

    for (final image in downloadedImagesBox.values) {
      BaseItemDto baseItem;
      var hiveSong = downloadedItemsBox.get(image.requiredBy.first);
      if (hiveSong != null) {
        baseItem = hiveSong.song;
      }else{
        var hiveParent = downloadedParentsBox.get(image.requiredBy.first);
        if (hiveParent != null) {
          baseItem = hiveParent.item;
        }else{
          _downloadsLogger.severe("Could not find item associated with image during migration to isar.");
          continue;
        }
      }

      var isarItem = DownloadStub.fromItem(type: DownloadItemType.image, item: baseItem).asItem(image.downloadLocationId);
      isarItem.downloadId = image.downloadId;
      isarItem.path = image.path;
      isarItem.state = DownloadItemState.downloading;
      nodes.add(isarItem);
    }

    await _isar.writeTxn(() async {
      await _isar.downloadItems.putAll(nodes);
    });
  }

  Future<void> _migrateSongs() async {
    final downloadedItemsBox = Hive.box<DownloadedSong>("DownloadedItems");

    List<DownloadItem> nodes = [];

    for (final song in downloadedItemsBox.values) {
      var isarItem = DownloadStub.fromItem(type: DownloadItemType.song, item: song.song).asItem(song.downloadLocationId);
      isarItem.downloadId = song.downloadId;
      isarItem.path = path_helper.relative(
          song.file.path,
          from: song.downloadLocation?.path);
      isarItem.state = DownloadItemState.downloading;
      nodes.add(isarItem);
    }

    await _isar.writeTxn(() async {
      await _isar.downloadItems.putAll(nodes);
    });
  }

  Future<void> _migrateParents() async {
    final downloadedParentsBox = Hive.box<DownloadedParent>("DownloadedParents");
    final downloadedItemsBox = Hive.box<DownloadedSong>("DownloadedItems");

    for (final parent in downloadedParentsBox.values) {
      var songId = parent.downloadedChildren.values.firstOrNull?.id;
      if (songId == null){
        _downloadsLogger.severe("Could not find item associated with parent during migration to isar.");
        continue;
      }
      var song = downloadedItemsBox.get(songId);
      if (song == null){
        _downloadsLogger.severe("Could not find item associated with parent during migration to isar.");
        continue;
      }
      var isarItem = DownloadStub.fromItem(type: DownloadItemType.collectionDownload, item: parent.item).asItem(song.downloadLocationId);

      await _isar.writeTxn(() async {
        await _isar.downloadItems.put(isarItem);
        var anchorItem = _anchor.asItem(null);
        await _isar.downloadItems.put(anchorItem);
        await anchorItem.requires.update(link: [isarItem]);
        isarItem.requires.addAll(parent.downloadedChildren.values.map((e) => DownloadStub.fromItem(type: DownloadItemType.song, item: e).asItem(song.downloadLocationId)));
        isarItem.requires.add(DownloadStub.fromItem(type: DownloadItemType.image, item: parent.item).asItem(song.downloadLocationId));
        await isarItem.requires.save();
      });
    }
  }

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

  List<DownloadItem> getUserDownloaded() => getVisibleChildren(_anchor);

  List<DownloadItem> getVisibleChildren(DownloadStub stub) {
    return _isar.downloadItems
        .where()
        .typeNotEqualTo(DownloadItemType.collectionInfo)
        .filter()
        .requiredBy((q) => q.isarIdEqualTo(stub.isarId))
        .not()
        .typeEqualTo(DownloadItemType.image)
        .findAllSync();
  }

  // TODO figure out what to do about sort order for playlists
  // TODO refactor into async?
  // TODO show downloading/failed songs as well as complete?
  List<DownloadItem> getCollectionSongs(BaseItemDto item) {
    var infoId = DownloadStub.getHash(item.id, DownloadItemType.collectionInfo);
    var downloadId =
        DownloadStub.getHash(item.id, DownloadItemType.collectionDownload);

    return _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .filter()
        .group((q) => q
            .requires((q) => q.isarIdEqualTo(infoId))
            .or()
            .requiredBy((q) => q.isarIdEqualTo(downloadId)))
        .stateEqualTo(DownloadItemState.complete)
        .sortByBaseIndexNumber()
        .thenByName()
        .findAllSync();
  }

  List<DownloadItem> getAllSongs(
          {String? nameFilter, BaseItemDto? relatedTo}) =>
      _getAll(DownloadItemType.song, DownloadItemState.complete, nameFilter,
          null, relatedTo);

  // TODO decide if we want all possible collections or just hard-downloaded ones.
  List<DownloadItem> getAllCollections(
          {String? nameFilter,
          String? baseTypeFilter,
          BaseItemDto? relatedTo}) =>
      _getAll(DownloadItemType.collectionInfo, null, nameFilter, baseTypeFilter,
          relatedTo);

  // TODO make async
  List<DownloadItem> _getAll(DownloadItemType type, DownloadItemState? state,
      String? nameFilter, String? baseType, BaseItemDto? relatedTo) {
    _downloadsLogger.severe("$type $state $nameFilter $baseType");
    return _isar.downloadItems
        .where()
        .typeEqualTo(type)
        .filter()
        .optional(state != null, (q) => q.stateEqualTo(state!))
        .optional(nameFilter != null,
            (q) => q.nameContains(nameFilter!, caseSensitive: false))
        .optional(baseType != null, (q) => q.baseItemtypeEqualTo(baseType))
        .optional(
            relatedTo != null,
            (q) => q.requiredBy((q) => q.requires((q) => q.isarIdEqualTo(
                DownloadStub.getHash(
                    relatedTo!.id, DownloadItemType.collectionInfo)))))
        .findAllSync();
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
    return _isar.downloadItems.where().typeEqualTo(type).countSync();
  }

  Future<int> getFileSize(DownloadStub item) async {
    var canonItem = await _isar.downloadItems.get(item.isarId);
    if (canonItem == null) return 0;
    return _getFileSize(canonItem, []);
  }

  Future<int> _getFileSize(
      DownloadItem item, List<DownloadStub> completed) async {
    if (completed.contains(item)) {
      return 0;
    } else {
      completed.add(item);
    }
    int size = 0;
    for (var child in item.requires.toList()) {
      size += await _getFileSize(child, completed);
    }
    if (item.type == DownloadItemType.song) {
      size += item.mediaSourceInfo?.size ?? 0;
    }
    if (item.type == DownloadItemType.image && item.downloadLocation != null) {
      var stat = await item.file.stat();
      size += stat.size;
    }

    return size;
  }
}
