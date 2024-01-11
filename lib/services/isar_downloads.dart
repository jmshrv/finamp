import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:collection/collection.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path_helper;
import 'package:rxdart/rxdart.dart';

import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import 'backgroundDownloaderStorage.dart';
import 'finamp_settings_helper.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';

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

    downloadStatusesStream = _downloadStatusesStreamController.stream
        .throttleTime(const Duration(seconds: 1),
            leading: false, trailing: true);
    offlineDeletesStream = _offlineDeletesStreamController.stream;
    downloadCountsStream = _downloadCountsStreamController.stream;

    updateDownloadCounts();

    FileDownloader().addTaskQueue(_downloadTaskQueue);

    FileDownloader().updates.listen((event) {
      if (event is TaskStatusUpdate) {
        _isar.writeTxnSync(() {
          DownloadItem? listener =
              _isar.downloadItems.getSync(int.parse(event.task.taskId));
          if (listener != null) {
            var newState = DownloadItemState.fromTaskStatus(event.status);
            if (!listener.state.isFinal) {
              if (event.status == TaskStatus.complete) {
                _downloadsLogger.fine("Downloaded ${listener.name}");
                String? extension;
                switch (event.mimeType) {
                  case "image/jpeg":
                    extension = ".jpg";
                  case "image/bmp":
                    extension = ".bmp";
                  case "image/png":
                    extension = ".png";
                  case "image/gif":
                    extension = ".gif";
                  case "image/webp":
                    extension = ".webp";
                }
                /*assert(
                    listener.file?.path == await event.task.filePath() ||
                        (extension != null &&
                            listener.file?.path.replaceFirst(
                                    RegExp(r'\.image$'), extension) ==
                                await event.task.filePath()),
                    "${listener.name} ${listener.path} ${listener.downloadLocationId} ${listener.downloadLocation} ${listener.file?.path} ${await event.task.filePath()} $extension");*/
                if (extension != null &&
                    listener.file!.path.endsWith(".image")) {
                  unawaited(File(listener.file!.path)
                      .rename(listener.file!.path
                          .replaceFirst(RegExp(r'\.image$'), extension))
                      .then((_) => null,
                          onError: (e) => GlobalSnackbar.error(e)));
                  listener.path = listener.path!
                      .replaceFirst(RegExp(r'\.image$'), extension);
                }
              }
              if (newState == DownloadItemState.failed) {
                _downloadsLogger.finer(
                    "Setting ${listener.name} failed due to update ${event.toJson().toString()}");
              }
              _updateItemState(listener, newState,
                  alwaysPut: event.status == TaskStatus.complete);
              if (event.exception is TaskFileSystemException ||
                  (event.exception?.description
                          .contains(RegExp(r'No space left on device')) ??
                      false)) {
                if (_allowDownloads) {
                  _allowDownloads = false;
                  GlobalSnackbar.message((scaffold) =>
                      AppLocalizations.of(scaffold)!.filesystemFull);
                }
              } else if (event.exception != null) {
                _downloadsLogger.warning(
                    "Exception ${event.exception} when downloading ${listener.name}");
              }
            } else {
              _downloadsLogger.info(
                  "Recieved status event ${event.status} for finalized download ${listener.name}.  Ignoring.");
            }
          } else {
            _downloadsLogger.severe(
                "Could not determine item for id ${event.task.taskId}, event:${event.toString()}");
          }
        });
      }
    });
  }

  final _downloadsLogger = Logger("IsarDownloads");
  final _jellyfinApiData = GetIt.instance<JellyfinApiHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _isar = GetIt.instance<Isar>();

  final _anchor =
      DownloadStub.fromId(id: "Anchor", type: DownloadItemType.anchor);
  final _downloadTaskQueue = IsarTaskQueue();
  late final _deleteBuffer = IsarDeleteBuffer(_syncDelete);
  late final _syncBuffer = IsarSyncBuffer(_syncDownload);

  // These track total downloads for the overview on the downloads screen
  final Map<DownloadItemState, int> downloadStatuses = {};
  late final Stream<Map<DownloadItemState, int>> downloadStatusesStream;
  final StreamController<Map<DownloadItemState, int>>
      _downloadStatusesStreamController = StreamController.broadcast();

  // These track total downloads for the overview on the downloads screen
  late final Stream<void> offlineDeletesStream;
  final StreamController<void> _offlineDeletesStreamController =
      StreamController.broadcast();

  // These track node counts for the overview on the downloads screen
  final Map<String, int> downloadCounts = {};
  late final Stream<Map<String, int>> downloadCountsStream;
  final StreamController<Map<String, int>> _downloadCountsStreamController =
      StreamController.broadcast();

  // This flag stops downloads when the file system fills
  bool _allowDownloads = true;
  bool get allowDownloads => _allowDownloads;

  // These cache downloaded metadata during _syncDownload
  Map<String, Future<DownloadStub>> _metadataCache = {};
  Map<String, Future<List<BaseItemDto>>> _childCache = {};

  /// Begin processing stored downloads/deletes.  This should only be called
  /// after background_downloader is fully set up.
  void startQueues() {
    unawaited(Future.sync(() async {
      try {
        await _deleteBuffer.executeDeletes();
        await _downloadTaskQueue.startQueue((ids) async {
          var items = _isar.downloadItems.getAllSync(ids);
          for (var item in items) {
            if (item != null) {
              // Unfortunately, if resumeFromBackground fails to complete an image
              // we cannot update its file extension.
              _updateItemState(item, DownloadItemState.complete);
            }
          }
        });
        await _syncBuffer.executeSyncs();
      } catch (e) {
        _downloadsLogger.severe(
            "Error $e while restarting download/delete queues on startup.");
      }
    }));
  }

  void updateDownloadCounts() {
    _isar.txnSync(() {
      downloadCounts["song"] = _isar.downloadItems
          .where()
          .typeEqualTo(DownloadItemType.song)
          .countSync();
      downloadCounts["image"] = _isar.downloadItems
          .where()
          .typeEqualTo(DownloadItemType.image)
          .countSync();
      downloadCounts["sync"] = _isar.isarTaskDatas
          .where()
          .typeEqualTo(IsarTaskDataType.syncNode)
          .or()
          .typeEqualTo(IsarTaskDataType.deleteNode)
          .countSync();
      _downloadCountsStreamController.add(downloadCounts);
    });
  }

  /// Get BaseItemDto from the given collection ID.  Tries local cache, then
  /// Isar, then requests data from jellyfin in a batch with other calls
  /// to this method.  Used within [_syncDownload].
  Future<DownloadStub?> _getCollectionInfo(String id) async {
    if (_metadataCache.containsKey(id)) {
      return _metadataCache[id];
    }
    Completer<DownloadStub> itemFetch = Completer();
    try {
      _metadataCache[id] = itemFetch.future;

      DownloadStub? item;
      item = _isar.downloadItems
          .getSync(DownloadStub.getHash(id, DownloadItemType.collection));
      item ??= await _jellyfinApiData.getItemByIdBatched(id).then((value) =>
          value == null
              ? null
              : DownloadStub.fromItem(
                  item: value, type: DownloadItemType.collection));
      itemFetch.complete(item);
      return itemFetch.future;
    } catch (e) {
      itemFetch.completeError(e);
      return itemFetch.future;
    }
  }

  Future<void> _childThrottle = Future.value();

  /// Get ordered child items for the given DownloadStub.  Tries local cache, then
  /// requests data from jellyfin.  This method throttles to three jellyfin calls
  /// per second across all invocations.  Used within [_syncDownload].
  Future<List<DownloadStub>> _getCollectionChildren(DownloadStub parent) async {
    DownloadItemType childType;
    BaseItemDtoType childFilter;
    String? fields;
    assert(parent.type == DownloadItemType.collection);
    switch (parent.baseItemType) {
      case BaseItemDtoType.playlist || BaseItemDtoType.album:
        childType = DownloadItemType.song;
        childFilter = BaseItemDtoType.song;
        fields = "${_jellyfinApiData.defaultFields},MediaSources";
      case BaseItemDtoType.artist ||
            BaseItemDtoType.genre ||
            BaseItemDtoType.library:
        childType = DownloadItemType.collection;
        childFilter = BaseItemDtoType.album;
      case _:
        throw StateError("Unknown collection type ${parent.baseItemType}");
    }
    var item = parent.baseItem!;

    if (_childCache.containsKey(item.id)) {
      var children = await _childCache[item.id]!;
      return children
          .map((e) => DownloadStub.fromItem(type: childType, item: e))
          .toList();
    }
    Completer<List<BaseItemDto>> itemFetch = Completer();
    // This prevents errors in itemFetch being reported as unhandled.
    // They are handled by original caller in rethrow.
    unawaited(itemFetch.future.then((_) => null, onError: (_) => null));
    try {
      _childCache[item.id] = itemFetch.future;
      var nextSlot = _childThrottle;
      _childThrottle = _childThrottle
          .then((value) => Future.delayed(const Duration(milliseconds: 300)));
      await nextSlot;
      var childItems = await _jellyfinApiData.getItems(
              parentItem: item,
              includeItemTypes: childFilter.idString,
              fields: fields) ??
          [];
      itemFetch.complete(childItems);
      return childItems
          .map((e) => DownloadStub.fromItem(type: childType, item: e))
          .toList();
    } catch (e) {
      itemFetch.completeError("replaced!");
      rethrow;
    }
  }

  Future<List<DownloadStub>> _getFinampCollectionChildren(
      DownloadStub parent) async {
    assert(parent.type == DownloadItemType.finampCollection);
    assert(parent.id == "Favorites");

    final childItems = await _jellyfinApiData.getItems(
          includeItemTypes: "Audio,MusicAlbum,Playlist",
          filters: "IsFavorite",
        ) ??
        [];
    // Artists use a different endpoint, so request those separately
    childItems.addAll(await _jellyfinApiData.getItems(
          includeItemTypes: "MusicArtist",
          filters: "IsFavorite",
        ) ??
        []);
    return childItems
        .map((e) => DownloadStub.fromItem(
            item: e,
            type: e.type == "Audio"
                ? DownloadItemType.song
                : DownloadItemType.collection))
        .toList();
  }

  /// Syncs a downloaded item with the latest data from the server, then recursively
  /// syncs children.  The item should already be present in Isar.  Items can be synced
  /// as required or info.  Info collections will only have info child nodes, and info
  /// songs will only have required nodes.  Info songs will not be downloaded.
  /// Image/anchor nodes always process as required, so this flag has no effect.  Nodes
  /// processed as info may be required via another parent, so children/files only needed
  /// for required nodes should be left in place, and will be handled by [_syncDelete]
  /// if necessary.  See [repairAllDownloads] for more information on the structure
  /// of the node graph and which children are allowable for each node type.
  Future<void> _syncDownload(DownloadStub parent, bool asRequired,
      Set<int> requireCompleted, Set<int> infoCompleted, String? viewId) async {
    if (parent.type == DownloadItemType.image ||
        parent.type == DownloadItemType.anchor) {
      asRequired = true; // Always download images, don't process twice.
    }
    if (parent.type == DownloadItemType.collection) {
      if (parent.baseItemType == BaseItemDtoType.playlist) {
        // Playlists show in all libraries, do not apply library info
        viewId = null;
      } else if (parent.baseItemType == BaseItemDtoType.library) {
        // Update view id for children of downloaded library
        viewId = parent.id;
      }
    }
    if (requireCompleted.contains(parent.isarId)) {
      return;
    } else if (infoCompleted.contains(parent.isarId) && !asRequired) {
      return;
    } else {
      if (asRequired) {
        requireCompleted.add(parent.isarId);
      } else {
        infoCompleted.add(parent.isarId);
      }
    }

    _downloadsLogger.finer(
        "Syncing ${parent.name} with required:$asRequired viewId:$viewId");

    //
    // Calculate needed children for item based on type and asRequired flag
    //
    bool updateChildren = true;
    Set<DownloadStub> requiredChildren = {};
    Set<DownloadStub> infoChildren = {};
    List<DownloadStub>? orderedChildItems;
    switch (parent.type) {
      case DownloadItemType.collection:
        var item = parent.baseItem!;
        if (item.blurHash != null) {
          infoChildren.add(
              DownloadStub.fromItem(type: DownloadItemType.image, item: item));
        }
        try {
          if (asRequired) {
            orderedChildItems = await _getCollectionChildren(parent);
            requiredChildren.addAll(orderedChildItems);
          }
          if (parent.baseItemType == BaseItemDtoType.album ||
              parent.baseItemType == BaseItemDtoType.playlist) {
            orderedChildItems ??= await _getCollectionChildren(parent);
            infoChildren.addAll(orderedChildItems);
          }
        } catch (e) {
          _downloadsLogger
              .info("Error downloading children for ${item.name}: $e");
          updateChildren = false;
        }
      case DownloadItemType.song:
        var item = parent.baseItem!;
        if (item.blurHash != null) {
          requiredChildren.add(
              DownloadStub.fromItem(type: DownloadItemType.image, item: item));
        }
        if (asRequired) {
          List<String> collectionIds = [];
          collectionIds.addAll(item.genreItems?.map((e) => e.id) ?? []);
          collectionIds.addAll(item.artistItems?.map((e) => e.id) ?? []);
          collectionIds.addAll(item.albumArtists?.map((e) => e.id) ?? []);
          if (item.albumId != null) {
            collectionIds.add(item.albumId!);
          }
          try {
            var collectionChildren =
                await Future.wait(collectionIds.map(_getCollectionInfo));
            infoChildren.addAll(collectionChildren.whereNotNull());
          } catch (e) {
            _downloadsLogger
                .info("Failed to download metadata for ${item.name}: $e");
            // TODO do somthing better than failing silently if we loose connection
            updateChildren = false;
          }
        }
      case DownloadItemType.image:
        break;
      case DownloadItemType.anchor:
        updateChildren = false;
      case DownloadItemType.finampCollection:
        try {
          if (asRequired) {
            orderedChildItems = await _getFinampCollectionChildren(parent);
            requiredChildren.addAll(orderedChildItems);
          }
        } catch (e) {
          _downloadsLogger.info(
              "Error downloading children for finampCollection ${parent.name}: $e");
          updateChildren = false;
        }
    }

    //
    // Update item with latest metadata and previously calculated children.
    // If calculating children previously failed, just fetch current children.
    //
    DownloadLocation? downloadLocation;
    DownloadItem? canonParent;
    if (updateChildren) {
      _isar.writeTxnSync(() {
        canonParent = _isar.downloadItems.getSync(parent.isarId);
        if (canonParent == null) {
          throw StateError("_syncDownload called on missing node ${parent.id}");
        }
        try {
          var newParent = canonParent!.copyWith(
              // We expect the parent baseItem to be more up to date as it recently came from
              // the server via the online UI or _getCollectionChildren.  It may also be from
              // Isar via _getCollectionInfo, in which case this is a no-op.
              item: parent.baseItem,
              viewId: viewId,
              orderedChildItems: orderedChildItems);
          if (newParent != null) {
            _isar.downloadItems.putSync(newParent);
            canonParent = newParent;
          }
        } catch (e) {
          _downloadsLogger.warning(e);
        }

        downloadLocation = canonParent!.downloadLocation;
        viewId ??= canonParent!.viewId;

        if (asRequired) {
          _updateChildren(canonParent!, true, requiredChildren);
          _updateChildren(canonParent!, false, infoChildren);
        } else if (canonParent!.type == DownloadItemType.song) {
          // For info only songs, we put image link into required so that we can delete
          // all info links in _syncDelete, so if not processing as required only
          // update that and ignore info links
          _updateChildren(canonParent!, true, requiredChildren);
        } else {
          _updateChildren(canonParent!, false, infoChildren);
        }
        _syncBuffer.addAll(requiredChildren,
            infoChildren.difference(requiredChildren), viewId);
      });
    } else {
      _isar.writeTxnSync(() {
        canonParent = _isar.downloadItems.getSync(parent.isarId);
        if (canonParent == null) {
          throw StateError("_syncDownload called on missing node ${parent.id}");
        }
        downloadLocation = canonParent!.downloadLocation;
        viewId ??= canonParent!.viewId;
        // Only children in links we would update should be gathered
        if (asRequired) {
          requiredChildren = (_isar.downloadItems
                  .filter()
                  .requiredBy((q) => q.isarIdEqualTo(parent.isarId))
                  .findAllSync())
              .toSet();
          // only the difference with requiredchildren is used, so don't bother
          // loading the overlapping items
          infoChildren = (_isar.downloadItems
                  .filter()
                  .infoFor((q) => q.isarIdEqualTo(parent.isarId))
                  .not()
                  .requiredBy((q) => q.isarIdEqualTo(parent.isarId))
                  .findAllSync())
              .toSet();
        } else if (parent.type == DownloadItemType.song) {
          requiredChildren = (_isar.downloadItems
                  .filter()
                  .requiredBy((q) => q.isarIdEqualTo(parent.isarId))
                  .findAllSync())
              .toSet();
        } else {
          infoChildren = (_isar.downloadItems
                  .filter()
                  .infoFor((q) => q.isarIdEqualTo(parent.isarId))
                  .findAllSync())
              .toSet();
        }
        _syncBuffer.addAll(requiredChildren,
            infoChildren.difference(requiredChildren), viewId);
      });
    }

    //
    // Download item files if needed
    //
    if (canonParent!.type.hasFiles && asRequired) {
      if (downloadLocation == null) {
        _downloadsLogger.severe(
            "could not download ${parent.id}, no download location found.");
      } else {
        await _initiateDownload(canonParent!, downloadLocation!);
      }
    }
  }

  /// This updates the children of an item to exactly match the given set.
  /// Children not currently present in Isar are added.  Unlinked items
  /// are added to delete buffer to later have [_syncDelete] run on them.
  /// links argument should be parent.info or parent.requires.
  /// Used within [_syncDownload].
  /// This should only be called inside an isar write transaction.
  void _updateChildren(
      DownloadItem parent, bool required, Set<DownloadStub> children) {
    IsarLinks<DownloadItem> links = required ? parent.requires : parent.info;

    var oldChildIds = (links.filter().isarIdProperty().findAllSync()).toSet();
    var newChildIds = children.map((e) => e.isarId).toSet();
    var childIdsToUnlink = oldChildIds.difference(newChildIds);
    var missingChildIds = newChildIds.difference(oldChildIds);
    var childrenToUnlink =
        (_isar.downloadItems.getAllSync(childIdsToUnlink.toList()))
            .whereNotNull()
            .toList();
    // anyOf filter allows all objects when given empty list, but we want no objects
    var childIdsToLink = (missingChildIds.isEmpty)
        ? <int>[]
        : _isar.downloadItems
            .where()
            .anyOf(missingChildIds, (q, int id) => q.isarIdEqualTo(id))
            .isarIdProperty()
            .findAllSync();
    // This is only used for IsarLink.update, which only cares about ID, so stubs are fine
    var childrenToLink = children
        .where((element) => childIdsToLink.contains(element.isarId))
        .map((e) => e.asItem(parent.downloadLocationId))
        .toList();
    var childrenToPutAndLink = children
        .where((element) =>
            missingChildIds.contains(element.isarId) &&
            !childIdsToLink.contains(element.isarId))
        .map((e) => e.asItem(parent.downloadLocationId))
        .toList();
    assert(childIdsToLink.length + childrenToPutAndLink.length ==
        missingChildIds.length);
    assert(
        missingChildIds.length + oldChildIds.length - childrenToUnlink.length ==
            children.length);
    _isar.downloadItems.putAllSync(childrenToPutAndLink);
    _deleteBuffer.addAll(childrenToUnlink.map((e) => e.isarId));
    if (missingChildIds.isNotEmpty || childrenToUnlink.isNotEmpty) {
      links.updateSync(
          link: childrenToLink + childrenToPutAndLink,
          unlink: childrenToUnlink);
      // Collection download state may need changing with different children
      return _syncItemState(parent);
    }
  }

  /// This processes a node for potential deletion based on incoming info and requires links.
  /// Required nodes will not be altered.  Info song nodes will have downloaded files
  /// deleted and info links cleared.  Other types of info node will have requires links
  /// cleared.  Nodes with no incoming links at all are deleted.  All unlinked children
  /// are added to delete buffer fro recursive sync deleting.  This method is intended to be
  /// used as a callback to [IsarDeleteBuffer.executeDeletes] and should not be called
  /// directly.
  Future<void> _syncDelete(int isarId) async {
    DownloadItem? canonItem;
    int requiredByCount = -1;
    int infoForCount = -1;
    _isar.txnSync(() {
      canonItem = _isar.downloadItems.getSync(isarId);
      requiredByCount = canonItem?.requiredBy.filter().countSync() ?? -1;
      infoForCount = canonItem?.infoFor.filter().countSync() ?? -1;
    });
    _downloadsLogger.finer("Sync deleting ${canonItem?.name ?? isarId}");
    if (canonItem == null ||
        requiredByCount > 0 ||
        canonItem!.type == DownloadItemType.anchor) {
      return;
    }
    // images should always be downloaded, even if they only have info links
    // This allows deleting all require links for collections but retaining associated images
    if (canonItem!.type == DownloadItemType.image && infoForCount > 0) {
      return;
    }

    if (canonItem!.type.hasFiles) {
      await _deleteDownload(canonItem!);
    }

    Set<int> childIds = {};
    _isar.writeTxnSync(() {
      DownloadItem? transactionItem =
          _isar.downloadItems.getSync(canonItem!.isarId);
      if (transactionItem == null) {
        return;
      }
      if (transactionItem.type.hasFiles) {
        if (transactionItem.state != DownloadItemState.notDownloaded) {
          _downloadsLogger.severe(
              "Could not delete ${transactionItem.name}, may still have files");
          return;
        }
      }
      infoForCount = transactionItem.infoFor.filter().countSync();
      requiredByCount = transactionItem.requiredBy.filter().countSync();
      if (requiredByCount != 0) {
        _downloadsLogger.severe(
            "Node ${transactionItem.id} became required during file deletion");
        return;
      }
      if (infoForCount > 0) {
        if (transactionItem.type == DownloadItemType.song) {
          // Non-required songs cannot have info links to collections, but they
          // can still require their images.
          childIds.addAll(
              transactionItem.info.filter().isarIdProperty().findAllSync());
          _deleteBuffer.addAll(childIds);
          transactionItem.info.resetSync();
        } else {
          childIds.addAll(
              transactionItem.requires.filter().isarIdProperty().findAllSync());
          _deleteBuffer.addAll(childIds);
          transactionItem.requires.resetSync();
        }
      } else {
        childIds.addAll(
            transactionItem.info.filter().isarIdProperty().findAllSync());
        childIds.addAll(
            transactionItem.requires.filter().isarIdProperty().findAllSync());
        _deleteBuffer.addAll(childIds);
        _isar.downloadItems.deleteSync(transactionItem.isarId);
      }
    });
  }

  // TODO use download groups to send notification when item fully downloaded?
  /// Triggers a persistent and independent download of the given item by linking
  /// it to the anchor as required and then syncing.
  Future<void> addDownload({
    required DownloadStub stub,
    required DownloadLocation downloadLocation,
    required String viewId,
  }) async {
    // Comment https://github.com/jmshrv/finamp/issues/134#issuecomment-1563441355
    // suggests this does not make a request and always returns failure
    /*if (downloadLocation.needsPermission) {
      if (await Permission.accessMediaLocation.isGranted) {
        _downloadsLogger.severe("Storage permission is not granted, exiting");
        return Future.error(
            "Storage permission is required for external storage");
      }
    }*/
    _isar.writeTxnSync(() {
      DownloadItem canonItem = _isar.downloadItems.getSync(stub.isarId) ??
          stub.asItem(downloadLocation.id);
      canonItem.downloadLocationId = downloadLocation.id;
      _isar.downloadItems.putSync(canonItem);
      var anchorItem = _anchor.asItem(null);
      // This may be the first download ever, so the anchor might not be present
      _isar.downloadItems.putSync(anchorItem);
      anchorItem.requires.updateSync(link: [canonItem]);
    });

    await resync(stub, viewId);
  }

  /// Removes the anchor link to an item and sync deletes it.  This will allow the
  /// item to be deleted but may not result in deletion actually occurring as the
  /// item may be required by other collections.
  Future<void> deleteDownload({required DownloadStub stub}) async {
    _isar.writeTxnSync(() {
      var anchorItem = _anchor.asItem(null);
      // This is required to trigger status recalculation
      _isar.downloadItems.putSync(anchorItem);
      _deleteBuffer.addAll([stub.isarId]);
      anchorItem.requires.updateSync(unlink: [stub.asItem(null)]);
    });
    try {
      await _deleteBuffer.executeDeletes();
      if (FinampSettingsHelper.finampSettings.isOffline) {
        _offlineDeletesStreamController.add(null);
      }
    } catch (error, stackTrace) {
      _downloadsLogger.severe("Isar failure $error", error, stackTrace);
      rethrow;
    }
  }

  /// Re-syncs every download node.
  Future<void> resyncAll() => resync(_anchor, null);

  /// Re-syncs the specified stub and all descendants.  For this to work correctly
  /// it is required that [_syncDownload] strictly follows the node graph hierarchy
  /// and only syncs children appropriate for an info node if reaching a node along
  /// an info link, even if children appropriate for a required node are present.
  Future<void> resync(DownloadStub stub, String? viewId) async {
    _allowDownloads = true;
    var requiredByCount = _isar.downloadItems
        .filter()
        .requires((q) => q.isarIdEqualTo(stub.isarId))
        .countSync();
    try {
      bool required = requiredByCount != 0;
      _downloadsLogger.info("Starting sync of ${stub.name}.");
      _isar.writeTxnSync(() {
        _syncBuffer.addAll(
            required ? [stub] : [], required ? [] : [stub], viewId);
      });
      await _syncBuffer.executeSyncs();
      _downloadsLogger.info("Moving to deletes for ${stub.name}.");
      _metadataCache = {};
      _childCache = {};
      await _deleteBuffer.executeDeletes();
      _downloadsLogger.info("Triggering enqueue for ${stub.name}.");
      unawaited(_downloadTaskQueue.executeSyncs());
      _downloadsLogger.info("Sync of ${stub.name} complete.");
    } catch (error, stackTrace) {
      _downloadsLogger.severe("Isar failure $error", error, stackTrace);
      rethrow;
    }
  }

  /// Ensures the given node is downloaded.  Called on all required nodes with files
  /// by [_syncDownload].  Items enqueued/downloading/failed are validated and cleaned
  /// up before re-initiating download if needed.
  Future<void> _initiateDownload(
      DownloadItem item, DownloadLocation downloadLocation) async {
    switch (item.state) {
      case DownloadItemState.complete:
        return;
      case DownloadItemState.notDownloaded:
        break;
      case DownloadItemState.enqueued: //fall through
      case DownloadItemState.downloading:
        if (await _downloadTaskQueue.validateQueued(item)) {
          return;
        }
        await _deleteDownload(item);
      case DownloadItemState.failed:
        await _deleteDownload(item);
    }

    switch (item.type) {
      case DownloadItemType.song:
        return _downloadSong(item, downloadLocation);
      case DownloadItemType.image:
        return _downloadImage(item, downloadLocation);
      case _:
        throw StateError("???");
    }
  }

  /// Removes unsafe characters from file names.  Used by [_downloadSong] and
  /// [_downloadImage] for human readable download locations.
  String? _filesystemSafe(String? unsafe) =>
      unsafe?.replaceAll(RegExp('[/?<>\\:*|"]'), "_");

  /// Creates a download task for the given song and adds it to the download queue.
  /// Also marks item as enqueued in isar.
  Future<void> _downloadSong(
      DownloadItem downloadItem, DownloadLocation downloadLocation) async {
    assert(downloadItem.type == DownloadItemType.song);
    var item = downloadItem.baseItem!;

    // Base URL shouldn't be null at this point (user has to be logged in
    // to get to the point where they can add downloads).
    String songUrl =
        "${_finampUserHelper.currentUser!.baseUrl}/Items/${item.id}/File";

    if (downloadItem.baseItem!.mediaSources == null &&
        FinampSettingsHelper.finampSettings.isOffline) {
      _isar.writeTxnSync(() {
        var canonItem = _isar.downloadItems.getSync(downloadItem.isarId);
        if (canonItem == null) {
          throw StateError(
              "Node missing while failing offline download for ${downloadItem.name}: $canonItem");
        }
        _updateItemState(canonItem, DownloadItemState.failed);
      });
    }
    // We try to always fetch the mediaSources when getting album/playlist, but sometimes
    // we download/sync individual songs and need to fetch playback info here.
    List<MediaSourceInfo>? mediaSources = downloadItem.baseItem!.mediaSources ??
        (await _jellyfinApiData.getPlaybackInfo(item.id));

    String fileName;
    String subDirectory;
    if (downloadLocation.useHumanReadableNames) {
      if (mediaSources == null) {
        _downloadsLogger.warning(
            "Media source info for ${item.id} returned null, filename may be weird.");
      }
      subDirectory =
          path_helper.join("finamp", _filesystemSafe(item.albumArtist));
      // We use a regex to filter out bad characters from song/album names.
      fileName = _filesystemSafe(
          "${item.album} - ${item.indexNumber ?? 0} - ${item.name}.${mediaSources?[0].container ?? 'song'}")!;
    } else {
      fileName = "${item.id}.${mediaSources?[0].container ?? 'song'}";
      subDirectory = "songs";
    }

    String? tokenHeader = _jellyfinApiData.getTokenHeader();

    if (downloadLocation.baseDirectory.needsPath) {
      subDirectory =
          path_helper.join(downloadLocation.currentPath, subDirectory);
    }

    _isar.writeTxnSync(() {
      DownloadItem? canonItem =
          _isar.downloadItems.getSync(downloadItem.isarId);
      if (canonItem == null) {
        _downloadsLogger.severe(
            "Download metadata ${downloadItem.id} missing after download starts");
        throw StateError("Could not save download task id");
      }
      canonItem.downloadLocationId = downloadLocation.id;
      canonItem.path = path_helper.join(subDirectory, fileName);
      if (canonItem.baseItem?.mediaSources == null && mediaSources != null) {
        var newBaseItem = canonItem.baseItem!;
        newBaseItem.mediaSources = mediaSources;
        canonItem = canonItem.copyWith(item: newBaseItem)!;
      }
      if (canonItem.state != DownloadItemState.notDownloaded) {
        _downloadsLogger.severe(
            "Song ${canonItem.name} changed state to ${canonItem.state} while initiating download.");
      } else {
        _updateItemState(canonItem, DownloadItemState.enqueued,
            alwaysPut: true);
      }

      _downloadTaskQueue.add(DownloadTask(
          taskId: downloadItem.isarId.toString(),
          url: songUrl,
          // requiresWifi will be set when enqueueing by IsarTaskQueue
          displayName: downloadItem.name,
          directory: subDirectory,
          baseDirectory: downloadLocation.baseDirectory.baseDirectory,
          retries: 3,
          headers: {
            if (tokenHeader != null) "X-Emby-Token": tokenHeader,
          },
          filename: fileName));
    });
  }

  /// Creates a download task for the given image and adds it to the download queue.
  /// Also marks item as enqueued in isar.
  Future<void> _downloadImage(
      DownloadItem downloadItem, DownloadLocation downloadLocation) async {
    assert(downloadItem.type == DownloadItemType.image);
    var item = downloadItem.baseItem!;

    String subDirectory;
    if (downloadLocation.useHumanReadableNames) {
      subDirectory =
          path_helper.join("finamp", _filesystemSafe(item.albumArtist));
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

    if (downloadLocation.baseDirectory.needsPath) {
      subDirectory =
          path_helper.join(downloadLocation.currentPath, subDirectory);
    }

    // We still use imageIds for filenames despite switching to blurhashes as
    // blurhashes can include characters that filesystems don't support
    final fileName = "${_filesystemSafe(item.imageId)!}.image";

    _isar.writeTxnSync(() {
      DownloadItem? canonItem =
          _isar.downloadItems.getSync(downloadItem.isarId);
      if (canonItem == null) {
        _downloadsLogger.severe(
            "Download metadata ${downloadItem.id} missing after download starts");
        throw StateError("Could not save download task id");
      }
      canonItem.downloadLocationId = downloadLocation.id;
      canonItem.path = path_helper.join(subDirectory, fileName);
      if (canonItem.state != DownloadItemState.notDownloaded) {
        _downloadsLogger.severe(
            "Image ${canonItem.name} changed state to ${canonItem.state} while initiating download.");
      } else {
        _updateItemState(canonItem, DownloadItemState.enqueued,
            alwaysPut: true);
      }

      _downloadTaskQueue.add(DownloadTask(
          taskId: downloadItem.isarId.toString(),
          url: imageUrl.toString(),
          // requiresWifi will be set when enqueueing by IsarTaskQueue
          displayName: downloadItem.name,
          baseDirectory: downloadLocation.baseDirectory.baseDirectory,
          retries: 3,
          directory: subDirectory,
          headers: {
            if (tokenHeader != null) "X-Emby-Token": tokenHeader,
          },
          filename: fileName));
    });
  }

  /// Removes any files associated with the item, cancels any pending downloads,
  /// and marks it as notDownloaded.  Used by [_syncDelete], as well as by
  /// [repairAllDownloads] and [_initiateDownload] to force a file into a known state.
  Future<void> _deleteDownload(DownloadItem item) async {
    assert(item.type.hasFiles);
    if (item.state == DownloadItemState.notDownloaded) {
      return;
    }

    await _downloadTaskQueue.remove(item);
    if (item.file != null) {
      try {
        await item.file!.delete();
      } on PathNotFoundException {
        _downloadsLogger.finer(
            "File ${item.file!.path} for ${item.name} missing during delete.");
      }
    }

    if (item.file != null && item.downloadLocation!.useHumanReadableNames) {
      Directory songDirectory = item.file!.parent;
      try {
        if (await songDirectory.list().isEmpty) {
          _downloadsLogger.info("${songDirectory.path} is empty, deleting");
          await songDirectory.delete();
        }
      } on PathNotFoundException {
        _downloadsLogger
            .finer("Directory ${songDirectory.path} missing during delete.");
      }
    }

    _isar.writeTxnSync(() {
      var transactionItem = _isar.downloadItems.getSync(item.isarId);
      if (transactionItem != null) {
        _updateItemState(transactionItem, DownloadItemState.notDownloaded);
      }
    });
  }

  /// Attempts to clean up any possible issues with downloads by removing stuck downloads,
  /// deleting node links that violate the node hierarchy, running [_syncDelete] on every node
  /// to clear out any orphans, and deleting any file in the internal download locations with
  /// no completed metadata node pointing to it.  See additional comment on the node hierarchy.
  Future<void> repairAllDownloads() async {
    // Step 1 - Remove invalid links and restore node hierarchy.
    _downloadsLogger.fine("Starting downloads repair step 1");
    // The node hierarchy is a limitation on what types of nodes can link to what
    // sorts of children.  It enforces a dependency graph with no loops which will
    // be completely deleted if the anchor is removed.  The type hierarchy is anchor->
    // non-album/playlist collection->album/playlist->song->image.  Items can only
    // link to types lower in the hierarchy, not ones higher or equal to themselves.
    // The only exception is songs, which can have info links to higher types but
    // only if the song is required.  To prevent this from allowing loops which include
    // require links, no type above songs in the hierarchy, namely collections, may have
    // any required children if they themselves are not required.  This exception
    // does allow for the formation of loops of info links, but the fact that participating
    // songs must be required means that the loops can always be cleaned up as songs
    // are deleted and prevents info dependency chains from propagating between
    // info only collections and songs to eventually require metadata on every item
    // the server has.
    _isar.writeTxnSync(() {
      List<
          (
            DownloadItemType,
            QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> Function(
                QueryBuilder<DownloadItem, DownloadItem, QFilterCondition>)?
          )> requireFilters = [
        (DownloadItemType.anchor, null),
        (DownloadItemType.finampCollection, null),
        (
          DownloadItemType.collection,
          (q) => q.allOf([BaseItemDtoType.album, BaseItemDtoType.playlist],
              (q, element) => q.not().baseItemTypeEqualTo(element))
        ),
        (
          DownloadItemType.collection,
          (q) => q.anyOf([BaseItemDtoType.album, BaseItemDtoType.playlist],
              (q, element) => q.baseItemTypeEqualTo(element))
        ),
        (DownloadItemType.song, null),
        (DownloadItemType.image, null),
      ];
      // Objects matching a require filter cannot require elements matching earlier filters or the current filter.
      // This enforces a strict object hierarchy with no possibility of loops.
      for (int i = 0; i < requireFilters.length; i++) {
        var items = _isar.downloadItems
            .where()
            .typeEqualTo(requireFilters[i].$1)
            .filter()
            .optional(
                requireFilters[i].$2 != null, (q) => requireFilters[i].$2!(q))
            .requires((q) => q.anyOf(
                requireFilters.slice(0, i + 1),
                (q, element) => q
                    .typeEqualTo(element.$1)
                    .optional(element.$2 != null, (q) => element.$2!(q))))
            .findAllSync();
        for (var item in items) {
          _downloadsLogger
              .severe("Unlinking invalid requires on node ${item.name}.");
          _downloadsLogger.severe(
              "Current children: ${item.requires.filter().findAllSync()}.");
          item.requires.resetSync();
        }
      }
      List<
          QueryBuilder<DownloadItem, DownloadItem, QAfterFilterCondition> Function(
              QueryBuilder<DownloadItem, DownloadItem,
                  QFilterCondition>)> infoFilters = [
        (q) => q
            .typeEqualTo(DownloadItemType.collection)
            .anyOf([BaseItemDtoType.album, BaseItemDtoType.playlist],
                (q, element) => q.baseItemTypeEqualTo(element))
            .not()
            .info((q) => q.not().group((q) => q
                .typeEqualTo(DownloadItemType.song)
                .or()
                .typeEqualTo(DownloadItemType.image))),
        (q) => q
            .typeEqualTo(DownloadItemType.song)
            .requiredByIsNotEmpty()
            .not()
            .info((q) => q.not().group((q) => q
                .typeEqualTo(DownloadItemType.collection)
                .or()
                .typeEqualTo(DownloadItemType.image))),
        (q) => q.not().info((q) => q.not().typeEqualTo(DownloadItemType.image)),
      ];
      // albums/playlist can require info on songs.  required songs can require info on
      // collections.  Anyone can require info on an image.
      // All other info links are disallowed.
      var badInfoItems = _isar.downloadItems
          .filter()
          .not()
          .anyOf(infoFilters, (q, element) => element(q))
          .findAllSync();
      for (var item in badInfoItems) {
        _downloadsLogger.severe("Unlinking invalid info on node ${item.name}.");
        _downloadsLogger
            .severe("Current children: ${item.info.filter().findAllSync()}.");
        item.info.resetSync();
      }
    });

    // Step 2 - Get all items into correct state matching filesystem and downloader.
    _downloadsLogger.fine("Starting downloads repair step 2");
    var itemsWithFiles = await _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .or()
        .typeEqualTo(DownloadItemType.image)
        .findAll();
    for (var item in itemsWithFiles) {
      switch (item.state) {
        case DownloadItemState.complete:
          await _verifyDownload(item);
        case DownloadItemState.notDownloaded:
          break;
        case DownloadItemState.enqueued: // fall through
        case DownloadItemState.downloading:
        case DownloadItemState.failed:
          await _deleteDownload(item);
      }
    }
    var itemsWithChildren = _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.collection)
        .findAllSync();
    _isar.writeTxnSync(() {
      for (var item in itemsWithChildren) {
        _syncItemState(item);
      }
    });

    // Step 3 - Resync all nodes from anchor to connect up all needed nodes
    _downloadsLogger.fine("Starting downloads repair step 3");
    await resyncAll();

    // Step 4 - Make sure there are no unanchored nodes in metadata.
    _downloadsLogger.fine("Starting downloads repair step 4");
    var allIds = _isar.downloadItems.where().isarIdProperty().findAllSync();
    for (var id in allIds) {
      await _syncDelete(id);
    }
    await _deleteBuffer.executeDeletes();

    // Step 5 - Make sure there are no orphan files in song directory.
    _downloadsLogger.fine("Starting downloads repair step 5");
    // This cleans internalSupport/images
    var imageFilePaths = Directory(path_helper.join(
            FinampSettingsHelper.finampSettings.internalSongDir.currentPath,
            "images"))
        .list()
        .handleError((e) =>
            _downloadsLogger.info("Error while cleaning image directories: $e"))
        .where((event) => event is File)
        .map((event) => path_helper.canonicalize(event.path));
    var filePaths = await imageFilePaths.toSet();
    // This cleans internalSupport/songs and internalDocuments/songs
    for (var songBasePath in FinampSettingsHelper
        .finampSettings.downloadLocationsMap.values
        .where((element) => !element.baseDirectory.needsPath)
        .map((e) => e.currentPath)) {
      var songFilePaths = Directory(path_helper.join(songBasePath, "songs"))
          .list()
          .handleError((e) => _downloadsLogger
              .info("Error while cleaning song directories: $e"))
          .where((event) => event is File)
          .map((event) => path_helper.canonicalize(event.path));
      filePaths.addAll(await songFilePaths.toSet());
    }
    for (var item in _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .or()
        .typeEqualTo(DownloadItemType.image)
        .filter()
        .stateEqualTo(DownloadItemState.complete)
        .findAllSync()) {
      if (item.file != null) {
        filePaths.remove(path_helper.canonicalize(item.file!.path));
      }
    }
    for (var filePath in filePaths) {
      _downloadsLogger.info("Deleting orphan file $filePath");
      try {
        await File(filePath).delete();
      } catch (e) {
        _downloadsLogger.info("Error while cleaning directories: $e");
      }
    }

    _downloadsLogger.fine("Downloads repair complete.");
  }

  /// Verify a download is complete and the associated file exists.  Update
  /// the item to be notDownloaded otherwise.  Used by [getSongDownload] and
  /// [getImageDownload].
  Future<bool> _verifyDownload(DownloadItem item) async {
    assert(item.type.hasFiles);
    if (item.state != DownloadItemState.complete) return false;
    if (await item.file?.exists() ?? false) return true;
    if (item.path != null) {
      for (var location
          in FinampSettingsHelper.finampSettings.downloadLocationsMap.values) {
        var path = path_helper.join(location.currentPath, item.path);
        if (await File(path).exists()) {
          _isar.writeTxnSync(() {
            var canonItem = _isar.downloadItems.getSync(item.isarId);
            canonItem!.downloadLocationId = location.id;
            _isar.downloadItems.putSync(canonItem);
          });
          _downloadsLogger.info(
              "${item.name} found in unexpected location ${location.name}");
          return true;
        }
      }
    }
    _isar.writeTxnSync(() {
      _updateItemState(item, DownloadItemState.notDownloaded);
    });
    _downloadsLogger.info(
        "${item.name} failed download verification, not located at ${item.file?.path}.");
    return false;
  }

  /// Migrates downloaded song metadata from Hive into Isar.  It first adds nodes
  /// for all images, then adds nodes for all songs and links them to their appropriate
  /// images.  Then nodes are added for all parents which link to their songs and
  /// images and are required by the anchor.  Finally, repairAllDownloads is run
  /// to fully download all metadata and clear up any issues.  This will fail if
  /// offline, but the node graph is still usable without this step and it can
  /// always be re-run later by the user.  Note that the existing hive metadata is
  /// not deleted by this migration, we just stop using it.
  Future<void> migrateFromHive() async {
    if (FinampSettingsHelper.finampSettings.downloadLocationsMap.values
        .where((element) =>
            element.baseDirectory == DownloadLocationType.internalSupport)
        .isEmpty) {
      final downloadLocation = await DownloadLocation.create(
        name: "Internal Storage",
        baseDirectory: DownloadLocationType.internalSupport,
      );
      FinampSettingsHelper.addDownloadLocation(downloadLocation);
    }
    await Future.wait([
      Hive.openBox<DownloadedParent>("DownloadedParents"),
      Hive.openBox<DownloadedSong>("DownloadedItems"),
      Hive.openBox<DownloadedImage>("DownloadedImages"),
    ]);
    _migrateImages();
    _migrateSongs();
    _migrateParents();
    unawaited(repairAllDownloads().then((value) => null, onError: (error) {
      _downloadsLogger
          .severe("Error $error in hive migration downloads repair.");
      GlobalSnackbar.show((scaffold) => SnackBar(
          content: Text(AppLocalizations.of(scaffold)!.runRepairWarning),
          duration: const Duration(seconds: 20)));
    }));
  }

  /// Substep 1 of [migrateFromHive].
  void _migrateImages() {
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
              FinampSettingsHelper.finampSettings.downloadLocationsMap.values
                  .where((element) =>
                      element.baseDirectory ==
                      DownloadLocationType.internalDocuments)
                  .first
                  .id)
          ? path_helper.join("songs", image.path)
          : image.path;
      isarItem.state = DownloadItemState.complete;
      nodes.add(isarItem);
      downloadStatuses[DownloadItemState.complete] =
          downloadStatuses[DownloadItemState.complete]! + 1;
    }

    _isar.writeTxnSync(() {
      _isar.downloadItems.putAllSync(nodes);
    });
  }

  /// Substep 2 of [migrateFromHive].
  void _migrateSongs() {
    final downloadedItemsBox = Hive.box<DownloadedSong>("DownloadedItems");

    List<DownloadItem> nodes = [];

    for (final song in downloadedItemsBox.values) {
      var baseItem = song.song;
      baseItem.mediaSources = [song.mediaSourceInfo];
      var isarItem =
          DownloadStub.fromItem(type: DownloadItemType.song, item: baseItem)
              .asItem(song.downloadLocationId);
      String? newPath;
      if (song.downloadLocationId == null) {
        for (MapEntry<String, DownloadLocation> entry in FinampSettingsHelper
            .finampSettings.downloadLocationsMap.entries) {
          if (song.path.contains(entry.value.currentPath)) {
            isarItem.downloadLocationId = entry.key;
            newPath =
                path_helper.relative(song.path, from: entry.value.currentPath);
            break;
          }
        }
        if (newPath == null) {
          _downloadsLogger
              .severe("Could not find ${song.path} during migration to isar.");
          continue;
        }
      } else if (song.downloadLocationId ==
          FinampSettingsHelper.finampSettings.downloadLocationsMap.values
              .where((element) =>
                  element.baseDirectory ==
                  DownloadLocationType.internalDocuments)
              .first
              .id) {
        newPath = path_helper.join("songs", song.path);
      } else {
        newPath = song.path;
      }
      isarItem.path = newPath;
      isarItem.state = DownloadItemState.complete;
      isarItem.viewId = song.viewId;
      nodes.add(isarItem);
      downloadStatuses[DownloadItemState.complete] =
          downloadStatuses[DownloadItemState.complete]! + 1;
    }

    _isar.writeTxnSync(() {
      _isar.downloadItems.putAllSync(nodes);
      for (var node in nodes) {
        if (node.baseItem?.blurHash != null) {
          var image = _isar.downloadItems.getSync(DownloadStub.getHash(
              node.baseItem!.blurHash!, DownloadItemType.image));
          if (image != null) {
            node.requires.updateSync(link: [image]);
          }
        }
      }
    });
  }

  /// Substep 3 of [migrateFromHive].
  void _migrateParents() {
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
              type: DownloadItemType.collection, item: parent.item)
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
      isarItem.state = DownloadItemState.complete;
      isarItem.viewId = parent.viewId;

      _isar.writeTxnSync(() {
        _isar.downloadItems.putSync(isarItem);
        var anchorItem = _anchor.asItem(null);
        _isar.downloadItems.putSync(anchorItem);
        anchorItem.requires.updateSync(link: [isarItem]);
        var existing = _isar.downloadItems
            .getAllSync(required.map((e) => e.isarId).toList());
        _isar.downloadItems
            .putAllSync(required.toSet().difference(existing.toSet()).toList());
        isarItem.requires.addAll(required);
        isarItem.requires.saveSync();
        isarItem.info.addAll(required);
        isarItem.info.saveSync();
      });
    }
  }

  /// Get all user-downloaded items.  Used to show items on downloads screen.
  Future<List<DownloadStub>> getUserDownloaded() => getVisibleChildren(_anchor);

  /// Get all non-image children of an item.  Used to show item children on
  /// downloads screen.
  Future<List<DownloadStub>> getVisibleChildren(DownloadStub stub) {
    return _isar.downloadItems
        .where()
        .typeNotEqualTo(DownloadItemType.image)
        .filter()
        .requiredBy((q) => q.isarIdEqualTo(stub.isarId))
        .findAll();
  }

  // This is for album/playlist screen
  /// Get all songs in a collection, ordered correctly.  Used to show songs on
  /// album/playlist screen.  Can return all songs in the album/playlist or
  /// just fully downloaded ones.
  Future<List<BaseItemDto>> getCollectionSongs(BaseItemDto item,
      {bool playable = true}) async {
    var stub =
        DownloadStub.fromItem(type: DownloadItemType.collection, item: item);
    assert(stub.baseItemType == BaseItemDtoType.playlist ||
        stub.baseItemType == BaseItemDtoType.album);

    var id = DownloadStub.getHash(item.id, DownloadItemType.collection);
    var query = _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .filter()
        .infoFor((q) => q.isarIdEqualTo(id))
        .optional(playable, (q) => q.stateEqualTo(DownloadItemState.complete));

    if (BaseItemDtoType.fromItem(item) == BaseItemDtoType.playlist) {
      List<DownloadItem> playlist = await query.findAll();
      var canonItem = await _isar.downloadItems.get(stub.isarId);
      if (canonItem?.orderedChildren == null) {
        return playlist.map((e) => e.baseItem).whereNotNull().toList();
      } else {
        Map<int, DownloadItem> childMap =
            Map.fromIterable(playlist, key: (e) => e.isarId);
        return canonItem!.orderedChildren!
            .map((e) => childMap[e]?.baseItem)
            .whereNotNull()
            .toList();
      }
    } else {
      var items = await query
          .sortByParentIndexNumber()
          .thenByBaseIndexNumber()
          .thenByName()
          .findAll();
      return items.map((e) => e.baseItem).whereNotNull().toList();
    }
  }

  /// Get all downloaded songs.  Used for songs tab on music screen.  Can have one
  /// or more filters applied:
  /// + nameFilter - only return songs containing nameFilter in their name, case insensitive.
  /// + relatedTo - only return songs which have relatedTo as their artist, album, or genre.
  /// + viewFilter - only return songs in the given library.
  Future<List<DownloadStub>> getAllSongs(
      {String? nameFilter,
      BaseItemDto? relatedTo,
      String? viewFilter,
      bool nullableViewFilters = true}) {
    return _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .filter()
        .stateEqualTo(DownloadItemState.complete)
        .optional(nameFilter != null,
            (q) => q.nameContains(nameFilter!, caseSensitive: false))
        .optional(
            relatedTo != null,
            (q) => q.info((q) => q.isarIdEqualTo(DownloadStub.getHash(
                relatedTo!.id, DownloadItemType.collection))))
        .optional(
            viewFilter != null,
            (q) => q.group((q) => q.viewIdEqualTo(viewFilter).optional(
                nullableViewFilters, (q) => q.or().viewIdEqualTo(null))))
        .findAll();
  }

  /// Get all downloaded collections.  Used for non-songs tabs on music screen and
  /// on artist/genre screens.  Can have one or more filters applied:
  /// + nameFilter - only return collections containing nameFilter in their name, case insensitive.
  /// + baseTypeFilter - only return collections of the given BaseItemDto type.
  /// + relatedTo - only return collections containing songs which have relatedTo as
  /// their artist, album, or genre.
  /// + fullyDownloaded - only return collections which are fully downloaded.  Artists/genres
  /// must be directly downloaded by the user for this to be true.
  /// + viewFilter - only return collections in the given library.
  /// + childViewFilter - only return collections with children in the given library.
  /// Useful for artists/genres, which may need to be shown in several libraries.
  Future<List<DownloadStub>> getAllCollections(
      {String? nameFilter,
      BaseItemDtoType? baseTypeFilter,
      BaseItemDto? relatedTo,
      bool fullyDownloaded = false,
      String? viewFilter,
      String? childViewFilter,
      bool nullableViewFilters = true}) {
    return _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.collection)
        .filter()
        .optional(nameFilter != null,
            (q) => q.nameContains(nameFilter!, caseSensitive: false))
        .optional(baseTypeFilter != null,
            (q) => q.baseItemTypeEqualTo(baseTypeFilter!))
        .optional(
            relatedTo != null,
            (q) => q.infoFor((q) => q.info((q) => q.isarIdEqualTo(
                DownloadStub.getHash(
                    relatedTo!.id, DownloadItemType.collection)))))
        .optional(fullyDownloaded,
            (q) => q.not().stateEqualTo(DownloadItemState.notDownloaded))
        .optional(
            viewFilter != null,
            (q) => q.group((q) => q.viewIdEqualTo(viewFilter).optional(
                nullableViewFilters, (q) => q.or().viewIdEqualTo(null))))
        .optional(
            childViewFilter != null,
            (q) => q.infoFor((q) => q.group((q) => q
                .viewIdEqualTo(childViewFilter)
                .optional(
                    nullableViewFilters, (q) => q.or().viewIdEqualTo(null)))))
        .findAll();
  }

  /// Get information about a downloaded song by BaseItemDto or id.
  Future<DownloadStub?> getSongInfo({BaseItemDto? item, String? id}) {
    assert((item == null) != (id == null));
    return _isar.downloadItems
        .get(DownloadStub.getHash(id ?? item!.id, DownloadItemType.song));
  }

  /// Get information about a downloaded collection by BaseItemDto or id.
  Future<DownloadStub?> getCollectionInfo({BaseItemDto? item, String? id}) {
    assert((item == null) != (id == null));
    return _isar.downloadItems
        .get(DownloadStub.getHash(id ?? item!.id, DownloadItemType.collection));
  }

  /// Get a song's DownloadItem by BaseItemDto or id.  This method performs file
  /// verification and should only be used when the downloaded file is actually
  /// needed, such as when building MediaItems.  Otherwise, [getSongInfo] should
  /// be used instead.
  Future<DownloadItem?> getSongDownload({BaseItemDto? item, String? id}) {
    assert((item == null) != (id == null));
    return _getDownloadByID(id ?? item!.id, DownloadItemType.song);
  }

  /// Get an image's DownloadItem by BaseItemDto or id.  This method performs file
  /// verification and should only be used when the downloaded file is actually
  /// needed, such as when building ImageProviders.
  Future<DownloadItem?> getImageDownload(
      {BaseItemDto? item, String? blurHash}) {
    assert((item?.blurHash == null) != (blurHash == null));
    return _getDownloadByID(
        blurHash ?? item!.blurHash!, DownloadItemType.image);
  }

  /// Get a downloadItem with verified files by id.
  Future<DownloadItem?> _getDownloadByID(
      String id, DownloadItemType type) async {
    assert(type.hasFiles);
    var item = _isar.downloadItems.getSync(DownloadStub.getHash(id, type));
    if (item != null && await _verifyDownload(item)) {
      return item;
    }
    return null;
  }

  /// Returns a stream of the list of downloads of a give state. Used to display
  /// active/failed/enqueued downloads on the active downloads screen.
  Stream<List<DownloadStub>> getDownloadList(DownloadItemState? state) {
    return _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .or()
        .typeEqualTo(DownloadItemType.image)
        .filter()
        .optional(state != null, (q) => q.stateEqualTo(state!))
        .watch(fireImmediately: true);
  }

  /// Updates the state of a DownloadItem and inserts into Isar.  If the state changed,
  /// the downloads status stream is updated and any parent items that may have changed
  /// state are recalculated.
  /// This should only be called inside an isar write transaction.
  void _updateItemState(DownloadItem item, DownloadItemState newState,
      {bool alwaysPut = false}) {
    if (item.state == newState) {
      if (alwaysPut) {
        _isar.downloadItems.putSync(item);
      }
    } else {
      if (item.type.hasFiles) {
        downloadStatuses[item.state] = downloadStatuses[item.state]! - 1;
        downloadStatuses[newState] = downloadStatuses[newState]! + 1;
        _downloadStatusesStreamController.add(downloadStatuses);
      }
      item.state = newState;
      _isar.downloadItems.putSync(item);
      List<DownloadItem> parents = _isar.downloadItems
          .filter()
          .group((q) => q
              .requires((q) => q.isarIdEqualTo(item.isarId))
              .or()
              .info((q) => q.isarIdEqualTo(item.isarId)))
          .not()
          .typeEqualTo(DownloadItemType.song)
          .findAllSync();
      for (var parent in parents) {
        _syncItemState(parent);
      }
    }
  }

  /// Syncs the download state of a collection based on the states of its children.
  /// Non-required artists/genres may have unknown non-downloaded children and thus
  /// are always considered not downloaded.
  /// This should only be called inside an isar write transaction.
  void _syncItemState(DownloadItem item) {
    if (item.type.hasFiles) return;
    Set<DownloadItemState> childStates = {};
    if (item.baseItemType == BaseItemDtoType.album ||
        item.baseItemType == BaseItemDtoType.playlist) {
      // Use full list of songs in info links for album/playlist
      childStates.addAll(
          item.info.filter().distinctByState().stateProperty().findAllSync());
    } else {
      // Non-required artists/genres have unknown children and should never be considered downloaded.
      if (item.requiredBy.filter().countSync() == 0) {
        return _updateItemState(item, DownloadItemState.notDownloaded);
      }
      childStates.addAll(item.requires.filter().stateProperty().findAllSync());
      // add dependency on image in info links
      childStates.addAll(
          item.info.filter().distinctByState().stateProperty().findAllSync());
    }
    if (childStates.contains(DownloadItemState.enqueued) ||
        childStates.contains(DownloadItemState.downloading)) {
      return _updateItemState(item, DownloadItemState.downloading);
    } else if (childStates.contains(DownloadItemState.failed)) {
      return _updateItemState(item, DownloadItemState.failed);
    } else if (childStates.contains(DownloadItemState.notDownloaded)) {
      return _updateItemState(item, DownloadItemState.notDownloaded);
    } else {
      return _updateItemState(item, DownloadItemState.complete);
    }
  }

  /// Returns the size of a download by recursivly calculating the size of all
  /// required children.  Used to display item sizes on downloads screen.
  Future<int> getFileSize(DownloadStub item) async {
    var canonItem = await _isar.downloadItems.get(item.isarId);
    if (canonItem == null) return 0;
    return _getFileSize(canonItem, {});
  }

  /// Recursive subcomponent of [getFileSize].
  Future<int> _getFileSize(
      DownloadItem item, Set<DownloadStub> completed) async {
    if (completed.contains(item)) {
      return 0;
    } else {
      completed.add(item);
    }
    int size = 0;
    var children = item.requires.filter().findAllSync();
    for (var child in children) {
      size += await _getFileSize(child, completed);
    }
    if (item.type == DownloadItemType.song &&
        item.state == DownloadItemState.complete) {
      size += item.baseItem?.mediaSources?[0].size ?? 0;
    }
    if (item.type == DownloadItemType.image &&
        item.state == DownloadItemState.complete) {
      var statSize =
          await item.file?.stat().then((value) => value.size).catchError((e) {
                _downloadsLogger.fine(
                    "No file for image ${item.name} when calculating size.");
                return 0;
              }) ??
              0;
      size += statSize;
    }

    return size;
  }

  late final _anchorProvider = StreamProvider(
      (ref) => _isar.downloadItems.watchObjectLazy(_anchor.isarId));

  /// Provider for the download state of an item.  This is whether the items associated
  /// files, or its children's file in the case of a collection, are missing, downloading
  /// or completely downloaded.  Useful for showing download status indicators
  /// on songs and albums.
  final stateProvider = StreamProvider.family
      .autoDispose<DownloadItemState?, DownloadStub>((ref, stub) {
    assert(stub.type != DownloadItemType.image &&
        stub.type != DownloadItemType.anchor);
    final isar = GetIt.instance<Isar>();
    return isar.downloadItems
        .watchObject(stub.isarId, fireImmediately: true)
        .map((event) => event?.state)
        .distinct();
  });

  /// Provider for the download status of an item.  See [getStatus] for details.
  /// This provider relies on the fact that [_syncDownload] always re-inserts
  /// processed items into Isar to know when to re-check status.
  late final statusProvider = StreamProvider.family
      .autoDispose<DownloadItemStatus, (DownloadStub, int?)>((ref, record) {
    var (stub, childCount) = record;
    assert(stub.type != DownloadItemType.image &&
        stub.type != DownloadItemType.anchor);
    // Refresh on addDownload/removeDownload as well as state change
    ref.watch(_anchorProvider);
    return _isar.downloadItems
        .watchObjectLazy(stub.isarId, fireImmediately: true)
        .map((event) {
      return getStatus(stub, childCount);
    }).distinct();
  });

  /// Returns the download status of an item.  This is whether the associated item
  /// is directly required by the user, transitively required via a containing collection,
  /// or not required to be downloaded at all.  Useful for determining whether to show
  /// download or delete buttons for an item.  The argument "children" is used
  /// while determining if an item is likely outdated compared to the server.  If this
  /// argument is not null and does not match the amount of children the item has in Isar,
  /// or if the item is neither fully downloaded nor actively downloading, then the item is
  /// considered to be outdated.
  DownloadItemStatus getStatus(DownloadStub stub, int? children) {
    assert(stub.type != DownloadItemType.image &&
        stub.type != DownloadItemType.anchor);
    var item = _isar.downloadItems.getSync(stub.isarId);
    if (item == null) return DownloadItemStatus.notNeeded;
    if (item.state == DownloadItemState.notDownloaded &&
        item.requiredBy.filter().countSync() == 0) {
      return DownloadItemStatus.notNeeded;
    }
    int childCount;
    if (stub.baseItemType == BaseItemDtoType.album ||
        stub.baseItemType == BaseItemDtoType.playlist) {
      // albums/playlists get marked as incidentally required if all info children
      // are required.  Use info links to calculate child count for this case
      childCount = item.info
          .filter()
          .not()
          .typeEqualTo(DownloadItemType.image)
          .countSync();
    } else {
      childCount = item.requires
          .filter()
          .not()
          .typeEqualTo(DownloadItemType.image)
          .countSync();
    }
    var outdated = (children != null && childCount != children) ||
        item.state == DownloadItemState.failed ||
        item.state == DownloadItemState.notDownloaded;
    if (item.requiredBy.filter().isarIdEqualTo(_anchor.isarId).countSync() >
        0) {
      return outdated
          ? DownloadItemStatus.requiredOutdated
          : DownloadItemStatus.required;
    } else {
      return outdated
          ? DownloadItemStatus.incidentalOutdated
          : DownloadItemStatus.incidental;
    }
  }
}
