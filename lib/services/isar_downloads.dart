import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:collection/collection.dart';
import 'package:finamp/components/error_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path_helper;

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import 'finamp_settings_helper.dart';
import 'finamp_user_helper.dart';
import 'get_internal_song_dir.dart';
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
    for (var state in DownloadItemState.values) {
      downloadStatuses[state] = _isar.downloadItems
          .where()
          .typeEqualTo(DownloadItemType.song)
          .or()
          .typeEqualTo(DownloadItemType.image)
          .filter()
          .stateEqualTo(state)
          .countSync();
    }
    downloadStatusesStream = _downloadStatusesStreamController
        .stream; // TODO maybe watch isar object instead?

    _downloadTaskQueue.maxConcurrent = 30; // no more than 5 tasks active at any one time
    _downloadTaskQueue.minInterval = const Duration(milliseconds: 100);  // Do not add more than 10 downloads per second
    FileDownloader().addTaskQueue(_downloadTaskQueue);

    // TODO use database instead of listener?
    FileDownloader().updates.listen((event) {
      if (event is TaskStatusUpdate) {
        _isar.writeTxn(() async {
          List<DownloadItem> listeners = await _isar.downloadItems
              .where()
              .isarIdEqualTo(int.parse(event.task.taskId))
              .findAll();
          for (var listener in listeners) {
            var newState = DownloadItemState.fromTaskStatus(event.status);
            await _updateItemState(listener, newState);
            if (event.status == TaskStatus.complete) {
              _downloadsLogger.fine("Downloaded ${listener.name}");
            }
            if(event.status == TaskStatus.failed && event.exception is TaskFileSystemException){
              if(_allowDownloads){
                _allowDownloads=false;
                globalErrorStream.add(event.exception);
              }
            }
          }
          if (listeners.isEmpty) {
            _downloadsLogger.severe(
                "Could not determine item for id ${event.task.taskId}, event:${event.toString()}");
          }
          await _isar.downloadItems.putAll(listeners);
        });
        _downloadStatusesStreamController.add(downloadStatuses);
      }
    });
  }

  final _downloadsLogger = Logger("IsarDownloads");

  final _jellyfinApiData = GetIt.instance<JellyfinApiHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _isar = GetIt.instance<Isar>();

  final _anchor =
      DownloadStub.fromId(id: "Anchor", type: DownloadItemType.anchor);
  final _downloadTaskQueue = MemoryTaskQueue();

  final Map<DownloadItemState, int> downloadStatuses = {};
  late final Stream<Map<DownloadItemState, int>> downloadStatusesStream;
  final StreamController<Map<DownloadItemState, int>>
      _downloadStatusesStreamController = StreamController.broadcast();

  bool _allowDownloads=true;

  Map<String, Future<Map<String, DownloadStub>>> _metadataCache = {};

  // TODO I believe this is still basically synchronous.  Fix or simplify.
  // Need _syncDownload to launch children in parallel for this to run in parallel
  // Do that just that with this cache?
  // Or do that + additional request batching?
  // Or simplify code to remove complicated future structure and keep synchronous.
  Future<List<DownloadStub>> _getCollectionInfo(List<String> ids) async {
    List<Future<DownloadStub?>> output = [];
    Map<String, DownloadStub> itemMap = {};
    Completer<Map<String, DownloadStub>> itemFetch = Completer();
    try {
      List<String> unmappedIds = [];
      for (String id in ids) {
        if (_metadataCache.containsKey(id)) {
          output.add(_metadataCache[id]!.then((value) => value[id]));
        } else {
          _metadataCache[id] = itemFetch.future;
          output.add(itemFetch.future.then((value) => value[id]));
          unmappedIds.add(id);
        }
      }

      List<DownloadItem?> downloadItems = [];
      List<DownloadItem?> infoItems = [];

      List<String> idsToQuery = [];
      if (unmappedIds.isNotEmpty) {
        await _isar.txn(() async {
          downloadItems = await _isar.downloadItems.getAll(unmappedIds
              .map((e) =>
                  DownloadStub.getHash(e, DownloadItemType.collectionDownload))
              .toList());
          infoItems = await _isar.downloadItems.getAll(unmappedIds
              .map((e) =>
                  DownloadStub.getHash(e, DownloadItemType.collectionInfo))
              .toList());
        });
        for (int i = 0; i < unmappedIds.length; i++) {
          if (infoItems[i] != null) {
            itemMap[unmappedIds[i]] = infoItems[i]!;
          } else if (downloadItems[i]?.baseItem != null) {
            itemMap[unmappedIds[i]] = DownloadStub.fromItem(
                type: DownloadItemType.collectionInfo,
                item: downloadItems[i]!.baseItem!);
          } else {
            idsToQuery.add(unmappedIds[i]);
          }
        }
      }
      if (idsToQuery.isNotEmpty) {
        List<BaseItemDto> items =
            await _jellyfinApiData.getItems(itemIds: idsToQuery) ?? [];
        itemMap.addEntries(items.map((e) => MapEntry(
            e.id,
            DownloadStub.fromItem(
                type: DownloadItemType.collectionInfo, item: e))));
      }
      itemFetch.complete(itemMap);
    } catch (e) {
      _downloadsLogger.info("Error downloading metadata: $e");
      itemFetch.completeError("Error downloading metadata: $e");
    }
    return Future.wait(output).then((value) => value.whereNotNull().toList());
  }

  // Make sure the parent and all children are in the metadata collection,
  // and downloaded.
  // TODO add comment warning about require loops
  Future<void> _syncDownload(
      DownloadStub parent, List<DownloadStub> completed) async {
    if (completed.contains(parent)) {
      return;
    } else {
      completed.add(parent);
    }
    // Throttle sync speed to preserve responsiveness and limit server load
    await Future.delayed(const Duration(milliseconds: 20));
    _downloadsLogger.finer("Syncing ${parent.name}");

    bool updateChildren = true;
    Set<DownloadStub> children = {};
    List<BaseItemDto>? childItems;
    switch (parent.type) {
      case DownloadItemType.collectionDownload:
        DownloadItemType childType;
        BaseItemDtoType childFilter;
        switch (parent.baseItemType) {
          case BaseItemDtoType.playlist: // fall through
          case BaseItemDtoType.album:
            childType = DownloadItemType.song;
            childFilter = BaseItemDtoType.song;
          case BaseItemDtoType.artist: // fall through
          case BaseItemDtoType.genre:
            childType = DownloadItemType.collectionDownload;
            childFilter = BaseItemDtoType.album;
          case BaseItemDtoType.song:
          case BaseItemDtoType.unknown:
            throw StateError(
                "Impossible typing: ${parent.type} and ${parent.baseItemType}");
        }
        var item = parent.baseItem!;
        if (item.blurHash != null) {
          children.add(
              DownloadStub.fromItem(type: DownloadItemType.image, item: item));
        }
        try {
          childItems = await _jellyfinApiData.getItems(
                  parentItem: item, includeItemTypes: childFilter.idString) ??
              [];
          for (var child in childItems) {
            children.add(DownloadStub.fromItem(type: childType, item: child));
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
          var collectionChildren = await _getCollectionInfo(collectionIds);
          children.addAll(collectionChildren);
        } catch (_) {
          _downloadsLogger.info("Failed to download metadata for ${item.name}");
          updateChildren = false;
        }
      case DownloadItemType.image:
        break;
      case DownloadItemType.anchor:
        updateChildren = false;
      case DownloadItemType.collectionInfo:
        var item = parent.baseItem!;
        if (item.blurHash != null) {
          children.add(
              DownloadStub.fromItem(type: DownloadItemType.image, item: item));
        }
    }

    //if (updateChildren) {
    //  _downloadsLogger.finest(
    //      "Updating children of ${parent.name} to ${children.map((e) => e.name)}");
    //}

    Set<DownloadItem> childrenToUnlink = {};
    DownloadLocation? downloadLocation;
    if (updateChildren) {
      //TODO update core item with latest?
      await _isar.writeTxn(() async {
        DownloadItem? canonParent =
            await _isar.downloadItems.get(parent.isarId);
        if (canonParent == null) {
          throw StateError("_syncDownload called on missing node ${parent.id}");
        }
        if (parent.baseItemType == BaseItemDtoType.playlist) {
          canonParent.orderedChildren = childItems
              ?.map((e) => DownloadStub.getHash(e.id, DownloadItemType.song))
              .toList();
          await _isar.downloadItems.put(canonParent);
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
        if (childrenToLink.length != oldChildren.length ||
            childrenToUnlink.isNotEmpty) {
          await _syncItemState(canonParent);
        }
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

    if (parent.type.hasFiles) {
      if (downloadLocation == null) {
        _downloadsLogger.severe(
            "could not download ${parent.id}, no download location found.");
      } else {
        await _initiateDownload(parent, downloadLocation!);
      }
    }

    for (var child in children) {
      await _syncDownload(child, completed);
    }
    for (var child in childrenToUnlink) {
      await _syncDelete(child.isarId);
    }
  }

  Future<void> _syncDelete(int isarId) async {
    DownloadItem? canonItem = await _isar.downloadItems.get(isarId);
    _downloadsLogger.finer("Sync deleting ${canonItem?.name ?? isarId}");
    if (canonItem == null ||
        canonItem.requiredBy.isNotEmpty ||
        canonItem.type == DownloadItemType.anchor) {
      return;
    }

    if (canonItem.type.hasFiles) {
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
      await _syncDelete(child.isarId);
    }
  }

  // TODO use download groups to send notification when item fully downloaded?
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

    _allowDownloads=true;

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
    }).then((_) => _metadataCache = {});
  }

  Future<void> deleteDownload({required DownloadStub stub}) async {
    await _isar.writeTxn(() async {
      var anchorItem = _anchor.asItem(null);
      await _isar.downloadItems.put(anchorItem);
      await anchorItem.requires.update(unlink: [stub.asItem(null)]);
    });

    return _syncDelete(stub.isarId).onError((error, stackTrace) {
      _downloadsLogger.severe("Isar failure $error", error, stackTrace);
      throw error!;
    });
  }

  Future<void> resyncAll() async {
    _allowDownloads=true;
    return _syncDownload(_anchor, []).onError((error, stackTrace) {
      _downloadsLogger.severe("Isar failure $error", error, stackTrace);
      throw error!;
    }).then((_) => _metadataCache = {});
  }

  Future<void> _initiateDownload(
      DownloadStub item, DownloadLocation downloadLocation) async {
    DownloadItem? canonItem = await _isar.downloadItems.get(item.isarId);
    if (canonItem == null) {
      _downloadsLogger.severe(
          "Download metadata ${item.id} missing before download starts");
      return;
    }

    if (!item.type.hasFiles || !_allowDownloads) {
      return;
    }

    switch (canonItem.state) {
      case DownloadItemState.complete:
        return;
      case DownloadItemState.notDownloaded:
        break;
      case DownloadItemState.enqueued: //fall through
      case DownloadItemState.downloading:
        var activeTasks = await FileDownloader().allTaskIds();
        if (activeTasks.contains(canonItem.isarId.toString())) {
          return;
        }
        await _deleteDownload(canonItem);
      case DownloadItemState.failed:
        // TODO don't retry failed unless we specifically want to?
        await _deleteDownload(canonItem);
    }

    // Refresh canonItem due to possible changes
    canonItem = await _isar.downloadItems.get(item.isarId);
    if (canonItem == null ||
        canonItem.state != DownloadItemState.notDownloaded) {
      throw StateError(
          "Bad state beginning download for ${item.name}: $canonItem");
    }

    //if (FinampSettingsHelper.finampSettings.isOffline){
    //  _downloadsLogger.info("Aborting download of ${item.name}, we are offline.");
    //  return;
    //}

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
    // TODO allow alternate download locations
    downloadLocation = FinampSettingsHelper.finampSettings.internalSongDir;
    var item = downloadItem.baseItem!;

    // Base URL shouldn't be null at this point (user has to be logged in
    // to get to the point where they can add downloads).
    String songUrl =
        "${_finampUserHelper.currentUser!.baseUrl}/Items/${item.id}/File";

    List<MediaSourceInfo>? mediaSourceInfo =
        await _jellyfinApiData.getPlaybackInfo(item.id);

    String fileName;
    String subDirectory;
    if (downloadLocation.useHumanReadableNames) {
      if (mediaSourceInfo == null) {
        _downloadsLogger.warning(
            "Media source info for ${item.id} returned null, filename may be weird.");
      }
      subDirectory = path_helper.join("finamp", item.albumArtist);
      // We use a regex to filter out bad characters from song/album names.
      fileName =
          "${item.album?.replaceAll(RegExp('[/?<>\\:*|"]'), "_")} - ${item.indexNumber ?? 0} - ${item.name?.replaceAll(RegExp('[/?<>\\:*|"]'), "_")}.${mediaSourceInfo?[0].container}";
    } else {
      fileName = "${item.id}.${mediaSourceInfo?[0].container}";
      subDirectory = "songs";
    }

    String? tokenHeader = _jellyfinApiData.getTokenHeader();

    // TODO allow pausing?  When to resume?
    BaseDirectory;
    _downloadTaskQueue.add(DownloadTask(
        taskId: downloadItem.isarId.toString(),
        url: songUrl,
        displayName: downloadItem.name,
        headers: {
          if (tokenHeader != null) "X-Emby-Token": tokenHeader,
        },
        filename: fileName));

    await _isar.writeTxn(() async {
      DownloadItem? canonItem =
          await _isar.downloadItems.get(downloadItem.isarId);
      if (canonItem == null) {
        _downloadsLogger.severe(
            "Download metadata ${downloadItem.id} missing after download starts");
        throw StateError("Could not save download task id");
      }
      canonItem.downloadLocationId = downloadLocation.id;
      canonItem.path = path_helper.join(subDirectory, fileName);
      canonItem.mediaSourceInfo = mediaSourceInfo![0];
      await _isar.downloadItems.put(canonItem);
    });
  }

  Future<void> _downloadImage(
      DownloadItem downloadItem, DownloadLocation downloadLocation) async {
    assert(downloadItem.type == DownloadItemType.image);
    // TODO allow alternate download locations
    downloadLocation = FinampSettingsHelper.finampSettings.internalSongDir;
    var item = downloadItem.baseItem!;

    String subDirectory;
    if (downloadLocation.useHumanReadableNames) {
      subDirectory = path_helper.join("finamp", item.albumArtist);
    } else {
      subDirectory = "images";
    }

    final imageUrl = _jellyfinApiData.getImageUrl(
      item: item,
      // Download original file
      quality: null,
      format: null,
    );
    final tokenHeader = _jellyfinApiData.getTokenHeader();

    // We still use imageIds for filenames despite switching to blurhashes as
    // blurhashes can include characters that filesystems don't support
    final fileName = item.imageId;

    BaseDirectory;
    _downloadTaskQueue.add(DownloadTask(
        taskId: downloadItem.isarId.toString(),
        url: imageUrl.toString(),
        displayName: downloadItem.name,
        directory: subDirectory,
        headers: {
          if (tokenHeader != null) "X-Emby-Token": tokenHeader,
        },
        filename: fileName));

    await _isar.writeTxn(() async {
      DownloadItem? canonItem =
          await _isar.downloadItems.get(downloadItem.isarId);
      if (canonItem == null) {
        _downloadsLogger.severe(
            "Download metadata ${downloadItem.id} missing after download starts");
        throw StateError("Could not save download task id");
      }
      canonItem.downloadLocationId = downloadLocation.id;
      canonItem.path = path_helper.join(subDirectory, fileName);
      await _isar.downloadItems.put(canonItem);
    });
  }

  Future<void> _deleteDownload(DownloadItem item) async {
    assert(item.type.hasFiles);
    if (item.state == DownloadItemState.notDownloaded) {
      return;
    }

    await FileDownloader().cancelTaskWithId(item.isarId.toString());
    if (item.downloadLocation != null) {
      try {
        await item.file.delete();
      } on PathNotFoundException {
        _downloadsLogger.finer(
            "File ${item.file.path} for ${item.name} missing during delete.");
      }
    }

    if (item.downloadLocation != null &&
        item.downloadLocation!.useHumanReadableNames) {
      Directory songDirectory = item.file.parent;
      if (await songDirectory.list().isEmpty) {
        _downloadsLogger.info("${songDirectory.path} is empty, deleting");
        try {
          await songDirectory.delete();
        } on PathNotFoundException {
          _downloadsLogger
              .finer("Directory ${songDirectory.path} missing during delete.");
        }
      }
    }

    await _isar.writeTxn(() async {
      var transactionItem = await _isar.downloadItems.get(item.isarId);
      await _updateItemState(transactionItem!, DownloadItemState.notDownloaded);
      await _isar.downloadItems.put(transactionItem);
    });
  }

  // TODO add clear download metadata option in settings?  Add some option to clear all links in settings??
  // or maybe clear all links but add warning to user about deletes occuring if server connection fails
  // or maybe provide list of nodes to be deleted to user and ask for delete confirmation?
  Future<void> repairAllDownloads() async {
    //TODO add more error checking so that one very broken item can't block general repairs.
    // Step 1 - Get all items into correct state matching filesystem and downloader.
    _downloadsLogger.fine("Starting downloads repair step 1");
    var itemsWithFiles = await _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .or()
        .typeEqualTo(DownloadItemType.image)
        .findAll();
    for (var item in itemsWithFiles) {
      switch (item.state) {
        case DownloadItemState.complete:
          await verifyDownload(item);
        case DownloadItemState.notDownloaded:
          break;
        case DownloadItemState.enqueued: // fall through
        case DownloadItemState.downloading:
          var activeTasks = await FileDownloader().allTaskIds();
          if (activeTasks.contains(item.isarId.toString())) {
            break;
          }
          await _deleteDownload(item);
        case DownloadItemState.failed:
          await _deleteDownload(item);
      }
    }
    var itemsWithChildren = await _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.collectionDownload)
        .findAll();
    await _isar.writeTxn(() async {
      for (var item in itemsWithChildren) {
        await _syncItemState(item);
      }
    });

    // Step 2 - Make sure all items are linked up to correct children.
    _downloadsLogger.fine("Starting downloads repair step 2");
    List<
        (
          DownloadItemType,
          QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> Function(
              QueryBuilder<DownloadItem, DownloadItem, QFilterCondition>)?
        )> filters = [
      (DownloadItemType.anchor, null),
      (
        DownloadItemType.collectionDownload,
        (q) => q.allOf([BaseItemDtoType.album, BaseItemDtoType.playlist],
            (q, element) => q.not().baseItemTypeEqualTo(element))
      ),
      (
        DownloadItemType.collectionDownload,
        (q) => q.anyOf([BaseItemDtoType.album, BaseItemDtoType.playlist],
            (q, element) => q.baseItemTypeEqualTo(element))
      ),
      (DownloadItemType.song, null),
      (DownloadItemType.collectionInfo, null),
      (DownloadItemType.image, null),
    ];
    // Objects matching a filter cannot require elements matching earlier filters or the current filter.
    // This enforces a strict object hierarchy with no possibility of loops.
    for (int i = 0; i < filters.length; i++) {
      var items = await _isar.downloadItems
          .where()
          .typeEqualTo(filters[i].$1)
          .filter()
          .optional(filters[i].$2 != null, (q) => filters[i].$2!(q))
          .requires((q) => q.anyOf(
              filters.slice(0, i + 1),
              (q, element) => q
                  .typeEqualTo(element.$1)
                  .optional(element.$2 != null, (q) => element.$2!(q))))
          .findAll();
      for (var item in items) {
        _downloadsLogger.severe("Unlinking invalid node ${item.name}.");
        //await item.requires.reset();
      }
    }
    await resyncAll();

    // Step 3 - Make sure there are no unanchored nodes in metadata.
    _downloadsLogger.fine("Starting downloads repair step 3");
    var allIds = await _isar.downloadItems.where().isarIdProperty().findAll();
    for (var id in allIds) {
      await _syncDelete(id);
    }

    // Step 4 - Make sure there are no orphan files in song directory.
    _downloadsLogger.fine("Starting downloads repair step 4");
    final internalSongDir = (await getInternalSongDir()).path;
    var songFilePaths = Directory(path_helper.join(internalSongDir, "songs"))
        .list()
        .handleError((e) =>
            _downloadsLogger.info("Error while cleaning directories: $e"))
        .where((event) => event is File)
        .map((event) => path_helper.normalize(event.path));
    var imageFilePaths = Directory(path_helper.join(internalSongDir, "images"))
        .list()
        .handleError((e) =>
            _downloadsLogger.info("Error while cleaning directories: $e"))
        .where((event) => event is File)
        .map((event) => path_helper.normalize(event.path));
    var filePaths =
        await songFilePaths.toList() + await imageFilePaths.toList();
    for (var item in await _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .or()
        .typeEqualTo(DownloadItemType.image)
        .findAll()) {
      filePaths.remove(path_helper.normalize(item.file.path));
    }
    for (var filePath in filePaths) {
      _downloadsLogger.info("Deleting orphan file $filePath");
      try {
        await File(filePath).delete();
      } catch (e) {
        _downloadsLogger.info("Error while cleaning directories: $e");
      }
    }
  }

  // TODO turn into or wrap around resync function that just checks tasklist and file state and updates item appropriatly.
  // unify with download repair in some way
  Future<bool> verifyDownload(DownloadItem item) async {
    if (!item.type.hasFiles) return true;
    if (item.state != DownloadItemState.complete) return false;
    if (item.downloadLocation != null && await item.file.exists()) return true;
    await FinampSettingsHelper.resetDefaultDownloadLocation();
    if (item.downloadLocation != null && await item.file.exists()) return true;
    await _isar.writeTxn(() async {
      await _updateItemState(item, DownloadItemState.notDownloaded);
      await _isar.downloadItems.put(item);
    });
    _downloadsLogger.info(
        "${item.name} failed download verification, not located at ${item.file.path}.");
    return false;
    // TODO add external storage stuff
  }

  // - first go through boxes and create nodes for all downloaded images/songs
  // then go through all downloaded parents and create anchor-attached nodes, and stitch to children/image.
  // then run standard verify all command - if it fails due to networking the
  // TODO make synchronous?  Should be slightly faster.
  Future<void> migrateFromHive() async {
    await FinampSettingsHelper.resetDefaultDownloadLocation();
    await Future.wait([
      Hive.openBox<DownloadedParent>("DownloadedParents"),
      Hive.openBox<DownloadedSong>("DownloadedItems"),
      Hive.openBox<DownloadedImage>("DownloadedImages"),
    ]);
    await _migrateImages();
    await _migrateSongs();
    await _migrateParents();
    try {
      await repairAllDownloads();
    } catch (error) {
      _downloadsLogger
          .severe("Error $error in hive migration downloads repair.");
      // TODO this should still be fine, the user can re-run verify manually later.
      // TODO we should display this somehow.
    }
    //TODO decide if we want to delete metadata here
  }

  Future<void> _migrateImages() async {
    final downloadedItemsBox = Hive.box<DownloadedSong>("DownloadedItems");
    final downloadedParentsBox =
        Hive.box<DownloadedParent>("DownloadedParents");
    final downloadedImagesBox = Hive.box<DownloadedImage>("DownloadedImages");

    List<DownloadItem> nodes = [];

    for (final image in downloadedImagesBox.values) {
      BaseItemDto baseItem;
      var hiveSong = downloadedItemsBox.get(image.requiredBy.first);
      if (hiveSong != null) {
        baseItem = hiveSong.song;
      } else {
        var hiveParent = downloadedParentsBox.get(image.requiredBy.first);
        if (hiveParent != null) {
          baseItem = hiveParent.item;
        } else {
          _downloadsLogger.severe(
              "Could not find item associated with image during migration to isar.");
          continue;
        }
      }

      var isarItem =
          DownloadStub.fromItem(type: DownloadItemType.image, item: baseItem)
              .asItem(image.downloadLocationId);
      isarItem.path = (image.downloadLocationId ==
              FinampSettingsHelper.finampSettings.internalSongDir.id)
          ? path_helper.join("songs", image.path)
          : image.path;
      isarItem.state = DownloadItemState.complete;
      nodes.add(isarItem);
      downloadStatuses[DownloadItemState.complete] =
          downloadStatuses[DownloadItemState.complete]! + 1;
    }

    await _isar.writeTxn(() async {
      await _isar.downloadItems.putAll(nodes);
    });
  }

  Future<void> _migrateSongs() async {
    final downloadedItemsBox = Hive.box<DownloadedSong>("DownloadedItems");

    List<DownloadItem> nodes = [];

    for (final song in downloadedItemsBox.values) {
      var isarItem =
          DownloadStub.fromItem(type: DownloadItemType.song, item: song.song)
              .asItem(song.downloadLocationId);
      String? newPath;
      if (song.downloadLocationId == null) {
        for (MapEntry<String, DownloadLocation> entry in FinampSettingsHelper
            .finampSettings.downloadLocationsMap.entries) {
          if (song.path.contains(entry.value.path)) {
            isarItem.downloadLocationId = entry.key;
            newPath = path_helper.relative(song.path, from: entry.value.path);
            break;
          }
        }
        if (newPath == null) {
          _downloadsLogger
              .severe("Could not find ${song.path} during migration to isar.");
          continue;
        }
      } else if (song.downloadLocationId ==
          FinampSettingsHelper.finampSettings.internalSongDir.id) {
        newPath = path_helper.join("songs", song.path);
      } else {
        newPath = song.path;
      }
      isarItem.path = newPath;
      isarItem.mediaSourceInfo = song.mediaSourceInfo;
      isarItem.state = DownloadItemState.complete;
      nodes.add(isarItem);
      downloadStatuses[DownloadItemState.complete] =
          downloadStatuses[DownloadItemState.complete]! + 1;
    }

    await _isar.writeTxn(() async {
      await _isar.downloadItems.putAll(nodes);
      for (var node in nodes) {
        if (node.baseItem?.blurHash != null) {
          var image = await _isar.downloadItems.get(DownloadStub.getHash(
              node.baseItem!.blurHash!, DownloadItemType.image));
          if (image != null) {
            await node.requires.update(link: [image]);
          }
        }
      }
    });
  }

  Future<void> _migrateParents() async {
    final downloadedParentsBox =
        Hive.box<DownloadedParent>("DownloadedParents");
    final downloadedItemsBox = Hive.box<DownloadedSong>("DownloadedItems");

    for (final parent in downloadedParentsBox.values) {
      var songId = parent.downloadedChildren.values.firstOrNull?.id;
      if (songId == null) {
        _downloadsLogger.severe(
            "Could not find item associated with parent during migration to isar.");
        continue;
      }
      var song = downloadedItemsBox.get(songId);
      if (song == null) {
        _downloadsLogger.severe(
            "Could not find item associated with parent during migration to isar.");
        continue;
      }
      var isarItem = DownloadStub.fromItem(
              type: DownloadItemType.collectionDownload, item: parent.item)
          .asItem(song.downloadLocationId);
      List<DownloadItem> required = parent.downloadedChildren.values
          .map((e) =>
              DownloadStub.fromItem(type: DownloadItemType.song, item: e)
                  .asItem(song.downloadLocationId))
          .toList();
      isarItem.orderedChildren = required.map((e) => e.isarId).toList();
      required.add(
          DownloadStub.fromItem(type: DownloadItemType.image, item: parent.item)
              .asItem(song.downloadLocationId));
      required.add(DownloadStub.fromItem(
              type: DownloadItemType.collectionInfo, item: parent.item)
          .asItem(song.downloadLocationId));
      isarItem.state = DownloadItemState.complete;

      await _isar.writeTxn(() async {
        await _isar.downloadItems.put(isarItem);
        var anchorItem = _anchor.asItem(null);
        await _isar.downloadItems.put(anchorItem);
        await anchorItem.requires.update(link: [isarItem]);
        var existing = await _isar.downloadItems
            .getAll(required.map((e) => e.isarId).toList());
        await _isar.downloadItems
            .putAll(required.toSet().difference(existing.toSet()).toList());
        isarItem.requires.addAll(required);
        await isarItem.requires.save();
      });
    }
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

  // TODO refactor into async?
  // TODO show downloading/failed songs as well as complete?
  List<DownloadItem> getCollectionSongs(BaseItemDto item) {
    var infoId = DownloadStub.getHash(item.id, DownloadItemType.collectionInfo);
    var downloadId =
        DownloadStub.getHash(item.id, DownloadItemType.collectionDownload);

    var query = _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .filter()
        .group((q) => q
            .requires((q) => q.isarIdEqualTo(infoId))
            .or()
            .requiredBy((q) => q.isarIdEqualTo(downloadId)))
        .stateEqualTo(DownloadItemState.complete);
    if (BaseItemDtoType.fromItem(item) == BaseItemDtoType.playlist) {
      List<DownloadItem> playlist = query.findAllSync();
      var canonItem = _isar.downloadItems.getSync(
          DownloadStub.getHash(item.id, DownloadItemType.collectionDownload));
      if (canonItem?.orderedChildren == null) {
        return playlist;
      } else {
        Map<int, DownloadItem> childMap =
            Map.fromIterable(playlist, key: (e) => e.isarId);
        return canonItem!.orderedChildren!
            .map((e) => childMap[e])
            .whereNotNull()
            .toList();
      }
    } else {
      return query
          .sortByParentIndexNumber()
          .thenByBaseIndexNumber()
          .thenByName()
          .findAllSync();
    }
  }

  // TODO decide if we want to show all songs or just properly downloaded ones
  List<DownloadItem> getAllSongs({String? nameFilter}) => _getAll(
      DownloadItemType.song,
      DownloadItemState.complete,
      nameFilter,
      null,
      null);

  // TODO decide if we want all possible collections or just hard-downloaded ones.
  List<DownloadItem> getAllCollections(
          {String? nameFilter,
          BaseItemDtoType? baseTypeFilter,
          BaseItemDto? relatedTo}) =>
      _getAll(DownloadItemType.collectionInfo, null, nameFilter, baseTypeFilter,
          relatedTo);

  // TODO make async
  List<DownloadItem> _getAll(DownloadItemType type, DownloadItemState? state,
      String? nameFilter, BaseItemDtoType? baseType, BaseItemDto? relatedTo) {
    return _isar.downloadItems
        .where()
        .typeEqualTo(type)
        .filter()
        .optional(state != null, (q) => q.stateEqualTo(state!))
        .optional(nameFilter != null,
            (q) => q.nameContains(nameFilter!, caseSensitive: false))
        .optional(baseType != null, (q) => q.baseItemTypeEqualTo(baseType!))
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
  // Use getCollectionDownload for download buttons, getMetadataDownload elsewhere
  DownloadItem? getCollectionDownload(BaseItemDto item) => getDownload(
      DownloadStub.fromItem(type: DownloadItemType.collectionInfo, item: item));
  DownloadItem? getDownload(DownloadStub stub) {
    // TODO add verify download here, remove verify method.  add check method to avoid calling this for status.
    // or maybe make verification a flag?
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

  int getDownloadCount({DownloadItemType? type, DownloadItemState? state}) {
    return _isar.downloadItems
        .where()
        .optional(type != null, (q) => q.typeEqualTo(type!))
        .filter()
        .optional(state != null, (q) => q.stateEqualTo(state!))
        .countSync();
  }

  Future<List<DownloadItem>> getDownloadList({DownloadItemType? type, DownloadItemState? state}) {
    return _isar.downloadItems
        .where()
        .optional(type != null, (q) => q.typeEqualTo(type!))
        .filter()
        .optional(state != null, (q) => q.stateEqualTo(state!))
        .findAll();
  }

  // This should only be called inside an isar write transaction
  Future<void> _updateItemState(
      DownloadItem item, DownloadItemState newState) async {
    if (item.state != newState) {
      if (item.type.hasFiles) {
        downloadStatuses[item.state] = downloadStatuses[item.state]! - 1;
        downloadStatuses[newState] = downloadStatuses[newState]! + 1;
      }
      item.state = newState;
      await _isar.downloadItems.put(item);
      for (var parent in await item.requiredBy.filter().findAll()) {
        await _syncItemState(parent);
      }
    }
  }

  // This should only be called inside an isar write transaction
  Future<void> _syncItemState(DownloadItem item) async {
    if (item.type.hasFiles) return;
    var children = await item.requires.filter().findAll();
    if (children
        .any((element) => element.state == DownloadItemState.notDownloaded)) {
      await _updateItemState(item, DownloadItemState.notDownloaded);
    } else if (children
        .any((element) => element.state == DownloadItemState.failed)) {
      await _updateItemState(item, DownloadItemState.failed);
    } else if (children
        .any((element) => element.state != DownloadItemState.complete)) {
      await _updateItemState(item, DownloadItemState.downloading);
    } else {
      await _updateItemState(item, DownloadItemState.complete);
    }
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
    if (item.type == DownloadItemType.song &&
        item.state == DownloadItemState.complete) {
      size += item.mediaSourceInfo?.size ?? 0;
    }
    if (item.type == DownloadItemType.image &&
        item.downloadLocation != null &&
        item.state == DownloadItemState.complete) {
      var statSize =
          await item.file.stat().then((value) => value.size).catchError((e) {
        _downloadsLogger
            .fine("No file for image ${item.name} when calculating size.");
        return 0;
      });
      size += statSize;
    }

    return size;
  }
}
