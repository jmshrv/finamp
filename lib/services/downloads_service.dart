import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:collection/collection.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
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
import 'downloads_service_backend.dart';
import 'finamp_settings_helper.dart';

const isarDatabaseName = "finamp_db.isar";
const repairStepTrackingName = "repairStep";

class DownloadsService {
  final _downloadsLogger = Logger("downloadsService");
  final _isar = GetIt.instance<Isar>();

  final _anchor = DownloadStub.fromId(
      id: "Anchor", type: DownloadItemType.anchor, name: null);
  late final downloadTaskQueue = IsarTaskQueue(this);
  late final deleteBuffer = DownloadsDeleteService(this);
  late final syncBuffer = DownloadsSyncService(this);

  // These track total downloads for the overview on the downloads screen
  final Map<DownloadItemState, int> downloadStatuses = {};
  late final Stream<Map<DownloadItemState, int>> downloadStatusesStream;
  final StreamController<Map<DownloadItemState, int>>
      _downloadStatusesStreamController = StreamController.broadcast();

  // This triggers refresh of music/artist screens on item deletion
  late final Stream<void> offlineDeletesStream;
  final StreamController<void> _offlineDeletesStreamController =
      StreamController.broadcast();

  // These track node counts for the overview on the downloads screen
  final Map<String, int> downloadCounts = {repairStepTrackingName: 0};
  late final Stream<Map<String, int>> downloadCountsStream;
  final StreamController<Map<String, int>> _downloadCountsStreamController =
      StreamController.broadcast();

  // Private flags/counters used to calculate public sync/download flags
  bool _fileSystemFull = false;
  bool _showConnectionMessage = true;
  int _consecutiveConnectionErrors = 0;
  bool _connectionMessageShown = false;
  bool _userDeleteRunning = false;

  //
  // Flags for controlling sync/downloads
  //

  /// Run sync at full speed in response to a user request as opposed to running
  /// at ~1/3 speed when autosyncing/autoresuming at startup.
  bool fullSpeedSync = false;

  /// Sync every item completely to ensure everything is completly up-to-date.  Otherwise,
  /// albums/songs/images with a state of complete will be assumed to remain unchanged
  /// and the sync will skip them, assuming prefer quick sync setting is true.
  bool forceFullSync = false;

  /// Causes the sync queue to stop processing new items
  bool get allowSyncs =>
      !_fileSystemFull &&
      _consecutiveConnectionErrors < 10 &&
      !_userDeleteRunning;

  /// Track app background time to trigger startup queue sync if app is in background
  /// for more than 5 hours, even if there is no full restart
  DateTime? _appPauseTime;

  /// Causes the downloads queue to stop processing new items
  bool get allowDownloads => allowSyncs && !syncBuffer.isRunning;

  //
  // Providers
  //

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

  late final infoForAnchorProvider =
      StreamProvider.family.autoDispose<bool, DownloadStub>((ref, stub) {
    assert(stub.type != DownloadItemType.image &&
        stub.type != DownloadItemType.anchor);
    // Refresh on addDownload/removeDownload as well as state change
    ref.watch(_anchorProvider);
    return _isar.downloadItems
        .watchObjectLazy(stub.isarId, fireImmediately: true)
        .map((event) {
      return _isar.downloadItems
              .where()
              .isarIdEqualTo(_anchor.isarId)
              .filter()
              .info((q) => q.isarIdEqualTo(stub.isarId))
              .countSync() >
          0;
    }).distinct();
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

  /// Provider for the actual download item associated with a stub.  This is used
  /// inside the downloads screen.
  final itemProvider = StreamProvider.family
      .autoDispose<DownloadItem?, DownloadStub>((ref, stub) {
    assert(stub.type != DownloadItemType.image &&
        stub.type != DownloadItemType.anchor);
    final isar = GetIt.instance<Isar>();
    return isar.downloadItems.watchObject(stub.isarId, fireImmediately: true);
  });

  /// Constructs the service.  startQueues should also be called to complete initialization.
  DownloadsService() {
    // Initialize downloadStatuses dict with actual counts of items in isar with
    // that state.  Calls to updateItemState will keep this up to date as the
    // state of an item is changed.
    for (var state in DownloadItemState.values) {
      downloadStatuses[state] = _isar.downloadItems
          .where()
          .optional(
              state != DownloadItemState.syncFailed,
              (q) => q
                  .typeEqualTo(DownloadItemType.song)
                  .or()
                  .typeEqualTo(DownloadItemType.image))
          .filter()
          .stateEqualTo(state)
          .countSync();
    }

    downloadStatusesStream = _downloadStatusesStreamController.stream
        .throttleTime(const Duration(milliseconds: 200),
            leading: false, trailing: true);
    offlineDeletesStream = _offlineDeletesStreamController.stream;
    downloadCountsStream = _downloadCountsStreamController.stream;

    updateDownloadCounts();

    FileDownloader().addTaskQueue(downloadTaskQueue);

    // This handler is called every time background_downloader emits a status update.
    // It updates the DownloadItem in isar to the matching DownloadItemState.
    // Updates for items which are already complete/failed are assumed to be coming
    // in out of order and are ignored.  Failed items may be moved to enqueued instead
    // of failed depending on the exception.
    FileDownloader().updates.listen((event) {
      if (event is TaskStatusUpdate) {
        _isar.writeTxnSync(() {
          DownloadItem? listener =
              _isar.downloadItems.getSync(int.parse(event.task.taskId));
          if (listener != null) {
            var newState = DownloadItemState.fromTaskStatus(event.status);
            if (!listener.state.isFinal) {
              // Completed images have their extension updated if possible.  Songs
              // should already have extensions when enqueued.  Extensions only serve
              // to help the user with viewing files stored in custom download locations, so
              // it does not matter if this update does not take place.
              if (event.status == TaskStatus.complete) {
                resetConnectionErrors();
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
                Future.sync(() async {
                  assert(
                      listener.file?.path == await event.task.filePath() ||
                          (extension != null &&
                              listener.file?.path.replaceFirst(
                                      RegExp(r'\.image$'), extension) ==
                                  await event.task.filePath()),
                      "${listener.name} ${listener.path} ${listener.fileDownloadLocation?.baseDirectory} ${listener.file?.path} ${await event.task.filePath()} $extension");
                });
                if (extension != null &&
                    listener.file!.path.endsWith(".image")) {
                  // Do not wait for file move to complete to prevent slowing isar write
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
                if (event.exception is TaskFileSystemException ||
                    (event.exception?.description
                            .contains(RegExp(r'No space left on device')) ??
                        false)) {
                  // Retry items that failed from a full filesystem once the user
                  // cleans it up and restarts/resyncs
                  newState = DownloadItemState.enqueued;
                  if (!_fileSystemFull) {
                    _fileSystemFull = true;
                    GlobalSnackbar.message((scaffold) =>
                        AppLocalizations.of(scaffold)!.filesystemFull);
                  }
                } else if (event.exception is TaskConnectionException) {
                  // Retry items with connection errors
                  newState = DownloadItemState.enqueued;
                  incrementConnectionErrors(weight: 2);
                } else if (event.exception != null) {
                  _downloadsLogger.warning(
                      "Exception ${event.exception} when downloading ${listener.name}");
                } else {
                  _downloadsLogger.warning(
                      "Received failed download task ${event.toJson()}");
                }
              }

              // Canceled items are expected to have their status updated by the
              // canceling code.  Cancelled items not handled and left in downloading
              // will be moved back to enqueued on next app restart or sync.
              if (event.status != TaskStatus.canceled) {
                updateItemState(listener, newState,
                    alwaysPut: event.status == TaskStatus.complete);
              }
            } else {
              _downloadsLogger.info(
                  "Received status event ${event.status} for finalized download ${listener.name}.  Ignoring.");
            }
          } else {
            _downloadsLogger.severe(
                "Could not determine item for id ${event.task.taskId}, event:${event.toString()}");
          }
        });
      }
    });

    // Sometimes we temporarily lose connection while the screen is locked.
    // Try to restart downloads when the user begins interacting again
    AppLifecycleListener(onRestart: () {
      _downloadsLogger
          .info("App returning from background, restarting downloads.");
      // If app is in background for more than 5 hours, treat it like a restart
      // and potentially resync all items
      if (FinampSettingsHelper.finampSettings.resyncOnStartup &&
          _appPauseTime != null &&
          DateTime.now().difference(_appPauseTime!).inHours > 5) {
        _isar.writeTxnSync(() {
          syncBuffer.addAll([_anchor.isarId], [], null);
        });
      }
      _appPauseTime = null;
      restartDownloads();
    }, onHide: () {
      _showConnectionMessage = false;
    }, onShow: () {
      _showConnectionMessage = true;
    }, onPause: () {
      _downloadsLogger.info("App is being paused by OS.");
      _appPauseTime = DateTime.now();
    });

    FileDownloader().requireWiFi(
        FinampSettingsHelper.finampSettings.requireWifiForDownloads
            ? RequireWiFi.forAllTasks
            : RequireWiFi.forNoTasks);

    bool oldOffline = FinampSettingsHelper.finampSettings.isOffline;
    bool oldRequireWifi =
        FinampSettingsHelper.finampSettings.requireWifiForDownloads;
    FinampSettingsHelper.finampSettingsListener.addListener(() {
      var newOffline = FinampSettingsHelper.finampSettings.isOffline;
      var newRequireWifi =
          FinampSettingsHelper.finampSettings.requireWifiForDownloads;
      if (oldOffline && !newOffline) {
        restartDownloads();
      }
      if (oldRequireWifi != newRequireWifi) {
        FileDownloader().requireWiFi(
            newRequireWifi ? RequireWiFi.forAllTasks : RequireWiFi.forNoTasks);
      }
      oldOffline = newOffline;
      oldRequireWifi = newRequireWifi;
    });
  }

  /// Should be called whenever a connection to the server succeeds.
  void resetConnectionErrors() {
    _consecutiveConnectionErrors = 0;
    _connectionMessageShown = false;
  }

  /// Should be called whenever a connection to the server fails.  If several
  /// connection attempts in a row fail, we assume we are offline and pause downloads.
  /// Displays a message to the user when pausing if we are not currently in
  /// the background.
  void incrementConnectionErrors({int weight = 1}) {
    _consecutiveConnectionErrors += weight;
    if (_consecutiveConnectionErrors >= 10 && !_connectionMessageShown) {
      _connectionMessageShown = true;
      _downloadsLogger.info("Pausing downloads due to connection issues.");
      if (_showConnectionMessage &&
          !FinampSettingsHelper.finampSettings.isOffline) {
        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.connectionInterrupted);
      } else if (!FinampSettingsHelper.finampSettings.isOffline) {
        if (Platform.isAndroid) {
          GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!
              .connectionInterruptedBackgroundAndroid);
        } else {
          GlobalSnackbar.message((scaffold) =>
              AppLocalizations.of(scaffold)!.connectionInterruptedBackground);
        }
      }
    }
  }

  /// Begin processing stored downloads/deletes.  This should only be called
  /// after background_downloader is fully set up.
  Future<void> startQueues() async {
    if (FinampSettingsHelper.finampSettings.resyncOnStartup) {
      _isar.writeTxnSync(() {
        syncBuffer.addAll([_anchor.isarId], [], null);
      });
    }

    await downloadTaskQueue.initializeQueue();

    // Wait a few seconds to not slow initial library load
    unawaited(Future.delayed(const Duration(seconds: 5), () async {
      try {
        await syncBuffer.executeSyncs();
        await deleteBuffer.executeDeletes();
        await downloadTaskQueue.executeDownloads();
      } catch (e) {
        _downloadsLogger.severe(
            "Error $e while restarting download/delete queues on startup.");
      }
    }));
  }

  /// Attempt to resume syncing/downloading.  Called when leaving offline mode,
  /// coming out of background, and switching to downloads screen
  void restartDownloads() {
    if (!FinampSettingsHelper.finampSettings.isOffline) {
      unawaited(Future.sync(() async {
        try {
          resetConnectionErrors();
          _downloadsLogger.info("Attempting to restart queues.");
          await syncBuffer.executeSyncs();
          await deleteBuffer.executeDeletes();
          await downloadTaskQueue.executeDownloads();
        } catch (e) {
          _downloadsLogger.severe(
              "Error $e while restarting syncs/downloads while gaining focus");
        }
      }));
    }
  }

  /// Update download counts with current values.  Repeatedly called
  /// while on downloads screen to update overview.
  void updateDownloadCounts() {
    _isar.txnSync(() {
      downloadCounts["song"] = _isar.downloadItems
          .where()
          .typeEqualTo(DownloadItemType.song)
          .filter()
          .not()
          .stateEqualTo(DownloadItemState.notDownloaded)
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

  // TODO use download groups to send notification when item fully downloaded?
  /// Triggers a persistent and independent download of the given item by linking
  /// it to the anchor as required and then syncing.
  Future<void> addDownload({
    required DownloadStub stub,
    required DownloadProfile transcodeProfile,
    String? viewId,
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
          stub.asItem(transcodeProfile);
      canonItem.userTranscodingProfile = transcodeProfile;
      _isar.downloadItems.putSync(canonItem);
      var anchorItem = _anchor.asItem(null);
      // This may be the first download ever, so the anchor might not be present
      _isar.downloadItems.putSync(anchorItem);
      anchorItem.requires.updateSync(link: [canonItem]);
      // Update download location id/transcode profile for all our children
      syncItemDownloadSettings(canonItem);
    });

    await resync(stub, viewId);
  }

  /// Removes the anchor link to an item and sync deletes it.  This will allow the
  /// item to be deleted but may not result in deletion actually occurring as the
  /// item may be required by other collections.
  Future<void> deleteDownload({required DownloadStub stub}) async {
    DownloadItem? canonItem;
    _isar.writeTxnSync(() {
      var anchorItem = _anchor.asItem(null);
      canonItem = _isar.downloadItems.getSync(stub.isarId);
      if (canonItem == null) {
        _downloadsLogger
            .warning("User attempted to delete missing item ${stub.name}");
        return;
      }
      // This is required to trigger status recalculation
      _isar.downloadItems.putSync(anchorItem);
      deleteBuffer.addAll([stub.isarId]);
      // Actual item is not required for updating links
      anchorItem.requires.updateSync(unlink: [canonItem!]);
      canonItem!.userTranscodingProfile = null;
      _isar.downloadItems.putSync(canonItem!);
    });
    if (canonItem == null) {
      return;
    }
    fullSpeedSync = true;
    try {
      // Pause syncing/downloading if the user initiates a delete
      _userDeleteRunning = true;
      await deleteBuffer.executeDeletes();
      if (FinampSettingsHelper.finampSettings.isOffline) {
        _offlineDeletesStreamController.add(null);
      }
    } catch (error, stackTrace) {
      _downloadsLogger.severe("Isar failure $error", error, stackTrace);
      rethrow;
    } finally {
      _userDeleteRunning = false;
    }
    restartDownloads();
  }

  /// Re-syncs every download node.
  Future<void> resyncAll() => resync(_anchor, null);

  /// Re-syncs the specified stub and all descendants.  For this to work correctly
  /// it is required that [_syncDownload] strictly follows the node graph hierarchy
  /// and only syncs children appropriate for an info node if reaching a node along
  /// an info link, even if children appropriate for a required node are present.
  Future<void> resync(DownloadStub stub, String? viewId,
      {bool keepSlow = false}) async {
    _consecutiveConnectionErrors = 0;
    _fileSystemFull = false;
    // All sync actions from now until app closure are the direct result of user
    // input and should run at full speed.
    if (!keepSlow) {
      fullSpeedSync = true;
    }
    var requiredByCount = _isar.downloadItems
        .filter()
        .requires((q) => q.isarIdEqualTo(stub.isarId))
        .countSync();
    try {
      bool required = requiredByCount != 0;
      _downloadsLogger.info("Starting sync of ${stub.name}.");
      _isar.writeTxnSync(() {
        syncBuffer.addAll(required ? [stub.isarId] : [],
            required ? [] : [stub.isarId], viewId);
      });
      await syncBuffer.executeSyncs();
      _downloadsLogger.info("Moving to deletes for ${stub.name}.");
      await deleteBuffer.executeDeletes();
      _downloadsLogger.info("Triggering enqueues for ${stub.name}.");
      unawaited(downloadTaskQueue.executeDownloads());
      _downloadsLogger.info("Sync of ${stub.name} complete.");
    } catch (error, stackTrace) {
      _downloadsLogger.severe("Isar failure $error", error, stackTrace);
      rethrow;
    }
  }

  /// Attempts to clean up any possible issues with downloads by removing stuck downloads,
  /// deleting node links that violate the node hierarchy, running [_syncDelete] on every node
  /// to clear out any orphans, and deleting any file in the internal download locations with
  /// no completed metadata node pointing to it.  See additional comment on the node hierarchy.
  Future<void> repairAllDownloads() async {
    // Step 1 - Remove invalid links and restore node hierarchy.
    _downloadsLogger.info("Starting downloads repair step 1");
    downloadCounts[repairStepTrackingName] = 1;
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
        // Select albums/playlists that only info link songs or images
        (q) => q
            .typeEqualTo(DownloadItemType.collection)
            .anyOf([BaseItemDtoType.album, BaseItemDtoType.playlist],
                (q, element) => q.baseItemTypeEqualTo(element))
            .not()
            .info((q) => q.not().group((q) => q
                .typeEqualTo(DownloadItemType.song)
                .or()
                .typeEqualTo(DownloadItemType.image))),
        // Select required songs that only link collections or images
        (q) => q
            .typeEqualTo(DownloadItemType.song)
            .requiredByIsNotEmpty()
            .not()
            .info((q) => q.not().group((q) => q
                .typeEqualTo(DownloadItemType.collection)
                .or()
                .typeEqualTo(DownloadItemType.image))),
        // Select nodes which only info link images or have no info links
        (q) => q.not().info((q) => q.not().typeEqualTo(DownloadItemType.image)),
        (q) => q.typeEqualTo(DownloadItemType.anchor),
      ];
      // albums/playlist can require info on songs.  required songs can require info on
      // collections.  Anyone can require info on an image.  The anchor can info link
      // anyone.  All other info links are disallowed.
      var badInfoItems = _isar.downloadItems
          .filter()
          .not()
          .anyOf(infoFilters, (q, element) => element(q))
          .findAllSync();
      // All items not matching one of the three above filters are invalid
      for (var item in badInfoItems) {
        _downloadsLogger.severe("Unlinking invalid info on node ${item.name}.");
        _downloadsLogger
            .severe("Current children: ${item.info.filter().findAllSync()}.");
        item.info.resetSync();
      }
    });
    // Allow other tasks to run between these steps, which are both synchronous
    await Future.delayed(const Duration(milliseconds: 100));

    // Step 2 - Get all items into correct state matching filesystem and downloader.
    _downloadsLogger.info("Starting downloads repair step 2");
    downloadCounts[repairStepTrackingName] = 2;
    var itemsWithFiles = _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .or()
        .typeEqualTo(DownloadItemType.image)
        .findAllSync();
    for (var item in itemsWithFiles) {
      switch (item.state) {
        case DownloadItemState.complete:
          await _verifyDownload(item);
        case DownloadItemState.notDownloaded:
          break;
        case DownloadItemState.enqueued: // fall through
        case DownloadItemState.downloading:
        case DownloadItemState.failed:
        case DownloadItemState.syncFailed:
        case DownloadItemState.needsRedownload:
        case DownloadItemState.needsRedownloadComplete:
          await deleteBuffer.deleteDownload(item);
      }
    }
    _isar.writeTxnSync(() {
      var itemsWithChildren = _isar.downloadItems
          .where()
          .typeEqualTo(DownloadItemType.collection)
          .or()
          .typeEqualTo(DownloadItemType.finampCollection)
          .findAllSync();
      for (var item in itemsWithChildren) {
        syncItemState(item);
        syncItemDownloadSettings(item);
      }
    });
    markOutdatedTranscodes();

    // Step 3 - Resync all nodes from anchor to connect up all needed nodes
    _downloadsLogger.info("Starting downloads repair step 3");
    downloadCounts[repairStepTrackingName] = 3;
    forceFullSync = true;
    fullSpeedSync = true;
    await resyncAll();
    forceFullSync = false;

    // Step 4 - Fetch all missing lyrics
    _downloadsLogger.info("Starting downloads repair step 4");
    downloadCounts[repairStepTrackingName] = 4;
    final Map<int, LyricDto?> idsWithLyrics = HashMap();
    var allItems = _isar.downloadItems
        .where()
        .stateNotEqualTo(DownloadItemState.notDownloaded)
        .filter()
        .typeEqualTo(DownloadItemType.song)
        .findAllSync();
    final JellyfinApiHelper _jellyfinApiData =
        GetIt.instance<JellyfinApiHelper>();
    for (var item in allItems) {
      if (item.baseItem?.mediaStreams
              ?.any((stream) => stream.type == "Lyric") ??
          false) {
        // check if lyrics are already downloaded
        if (_isar.downloadedLyrics
                .where()
                .isarIdEqualTo(item.isarId)
                .countSync() >
            0) {
          continue;
        }
        idsWithLyrics[item.isarId] = null;
        LyricDto? lyrics;
        try {
          lyrics = await _jellyfinApiData.getLyrics(itemId: item.id);
          _downloadsLogger.finer("Fetched lyrics for ${item.name}");
          idsWithLyrics[item.isarId] = lyrics;
        } catch (e) {
          _downloadsLogger.warning("Failed to fetch lyrics for ${item.name}.");
        }
      }
    }
    _isar.writeTxnSync(() {
      for (var id in idsWithLyrics.keys) {
        var canonItem = _isar.downloadItems.getSync(id);
        if (canonItem != null && idsWithLyrics[id] != null) {
          final lyricsItem = DownloadedLyrics.fromItem(
              isarId: canonItem.isarId, item: idsWithLyrics[id]!);
          _isar.downloadedLyrics.putSync(lyricsItem);
        }
      }
    });

    // Step 5 - Make sure there are no unanchored nodes in metadata.
    _downloadsLogger.info("Starting downloads repair step 5");
    downloadCounts[repairStepTrackingName] = 5;
    var allIds = _isar.downloadItems.where().isarIdProperty().findAllSync();
    for (var id in allIds) {
      await deleteBuffer.syncDelete(id);
    }
    await deleteBuffer.executeDeletes();

    // Step 6 - Make sure there are no orphan files in song directory.
    _downloadsLogger.info("Starting downloads repair step 6");
    downloadCounts[repairStepTrackingName] = 6;
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

    _downloadsLogger.info("Downloads repair complete.");
    downloadCounts[repairStepTrackingName] = 0;
  }

  /// Verify a download is complete and the associated file exists.  Update
  /// the item to be notDownloaded otherwise.  Used by [getSongDownload] and
  /// [getImageDownload].
  bool _verifyDownload(DownloadItem item) {
    assert(item.type.hasFiles);
    if (!item.state.isComplete) return false;
    if (item.file?.existsSync() ?? false) return true;
    if (item.path != null) {
      for (var location
          in FinampSettingsHelper.finampSettings.downloadLocationsMap.values) {
        var path = path_helper.join(location.currentPath, item.path);
        if (File(path).existsSync()) {
          _isar.writeTxnSync(() {
            var canonItem = _isar.downloadItems.getSync(item.isarId);
            canonItem!.fileTranscodingProfile!.downloadLocationId = location.id;
            _isar.downloadItems.putSync(canonItem);
          });
          _downloadsLogger.info(
              "${item.name} found in unexpected location ${location.name}");
          return true;
        }
      }
    }
    _isar.writeTxnSync(() {
      var canonItem = _isar.downloadItems.getSync(item.isarId);
      if (canonItem != null) {
        updateItemState(canonItem, DownloadItemState.notDownloaded);
      }
    });
    _downloadsLogger.info(
        "${item.name} failed download verification, not located at ${item.file?.path}.");
    return false;
  }

  /// Updates the state of a DownloadItem and inserts into Isar.  If the state changed,
  /// the downloads status stream is updated and any parent items that may have changed
  /// state are recalculated.
  /// This should only be called inside an isar write transaction.
  void updateItemState(DownloadItem item, DownloadItemState newState,
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
      } else {
        if (item.state == DownloadItemState.syncFailed) {
          downloadStatuses[item.state] = downloadStatuses[item.state]! - 1;
          _downloadStatusesStreamController.add(downloadStatuses);
        } else if (newState == DownloadItemState.syncFailed) {
          downloadStatuses[newState] = downloadStatuses[newState]! + 1;
          _downloadStatusesStreamController.add(downloadStatuses);
        }
      }
      item.state = newState;
      _isar.downloadItems.putSync(item);
      List<DownloadItem> parents = _isar.downloadItems
          .where()
          .typeNotEqualTo(DownloadItemType.song)
          .filter()
          .requires((q) => q.isarIdEqualTo(item.isarId))
          .or()
          .info((q) => q.isarIdEqualTo(item.isarId))
          .findAllSync();
      for (var parent in parents) {
        syncItemState(parent);
      }
    }
  }

  /// Syncs the download state of a collection based on the states of its children.
  /// Non-required artists/genres may have unknown non-downloaded children and thus
  /// are always considered not downloaded.
  /// This should only be called inside an isar write transaction.
  void syncItemState(DownloadItem item, {bool removeSyncFailed = false}) {
    if (item.type.hasFiles) return;
    if (item.state == DownloadItemState.syncFailed && !removeSyncFailed) return;
    Set<DownloadItemState> childStates = {};
    if (item.baseItemType == BaseItemDtoType.album ||
        item.baseItemType == BaseItemDtoType.playlist) {
      // Use full list of songs in info links for album/playlist
      childStates.addAll(
          item.info.filter().distinctByState().stateProperty().findAllSync());
    } else {
      // Non-required artists/genres have unknown children and should never be considered downloaded.
      if (item.requiredBy.filter().countSync() == 0) {
        return updateItemState(item, DownloadItemState.notDownloaded);
      }
      childStates.addAll(item.requires
          .filter()
          .distinctByState()
          .stateProperty()
          .findAllSync());
      // playlist metadata info links collections which are not nessecarilly downloaded,
      // and should still be considered downloaded.
      if (item.finampCollection?.type !=
          FinampCollectionType.allPlaylistsMetadata) {
        // add dependency on image in info links
        childStates.addAll(
            item.info.filter().distinctByState().stateProperty().findAllSync());
      }
    }
    if (childStates.contains(DownloadItemState.notDownloaded)) {
      return updateItemState(item, DownloadItemState.notDownloaded);
    } else if (childStates.contains(DownloadItemState.failed) ||
        childStates.contains(DownloadItemState.syncFailed)) {
      return updateItemState(item, DownloadItemState.failed);
    } else if (childStates.contains(DownloadItemState.enqueued) ||
        childStates.contains(DownloadItemState.downloading)) {
      // DownloadItemState.enqueued should only be reachable via _initiateDownload
      return updateItemState(item, DownloadItemState.downloading);
    } else {
      return updateItemState(item, DownloadItemState.complete);
    }
  }

  /// Sync the downloadLocationId and transcodingProfile to match those of the items
  /// parent.  If there are multiple required parents with different values, the download
  /// location and transcode settings with the highest quality are selected.
  /// This should only be called inside an isar write transaction.
  void syncItemDownloadSettings(DownloadItem item) {
    if (item.type == DownloadItemType.image) {
      return;
    }
    var transcodeProfiles =
        item.requiredBy.filter().syncTranscodingProfileProperty().findAllSync();
    if (transcodeProfiles.isEmpty) {
      _downloadsLogger.severe(
          "Attempting to sync download settings for non-required item ${item.name}");
      return;
    }
    transcodeProfiles.add(item.userTranscodingProfile);
    if (transcodeProfiles.whereNotNull().isEmpty) {
      _downloadsLogger
          .severe("No valid download profiles for required item ${item.name}");
      return;
    }

    // Prioritize original quality if allowed, otherwise choose highest quality approximation
    DownloadProfile bestProfile = transcodeProfiles
        .whereNotNull()
        .sorted((i, j) => ((j.quality - i.quality) * 1000).toInt())
        .first;
    if (!transcodeProfiles
            .whereNotNull()
            .contains(item.syncTranscodingProfile) ||
        bestProfile.quality > (item.syncTranscodingProfile!.quality + 2000)) {
      _downloadsLogger.finest("Updating download settings for ${item.name}");
      item.syncTranscodingProfile = bestProfile;
      if ((item.state == DownloadItemState.enqueued ||
              item.state == DownloadItemState.downloading ||
              item.state == DownloadItemState.complete) &&
          item.type == DownloadItemType.song &&
          FinampSettingsHelper.finampSettings.shouldRedownloadTranscodes) {
        if (item.state == DownloadItemState.complete) {
          updateItemState(item, DownloadItemState.needsRedownloadComplete,
              alwaysPut: true);
        } else {
          updateItemState(item, DownloadItemState.needsRedownload,
              alwaysPut: true);
        }
        syncBuffer.addAll([item.isarId], [], null);
      } else {
        _isar.downloadItems.putSync(item);
      }
      for (var child in item.requires.filter().findAllSync()) {
        syncItemDownloadSettings(child);
      }
    }
  }

  /// Find all downloaded songs with outdated download location ID or transcoding profile
  /// and mark them for deletion, then resync to delete and redownload them.
  void markOutdatedTranscodes() {
    _isar.writeTxnSync(() {
      var items = _isar.downloadItems
          .where()
          .typeEqualTo(DownloadItemType.song)
          .filter()
          .not()
          .stateEqualTo(DownloadItemState.notDownloaded)
          .requiredByIsNotEmpty()
          .findAllSync();
      for (var item in items) {
        if (item.fileTranscodingProfile != item.syncTranscodingProfile) {
          updateItemState(item, DownloadItemState.needsRedownload);
        }
      }
    });
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
    _downloadsLogger.info("Migrating images from Hive");
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

      var isarItem = DownloadStub.fromItem(
              type: DownloadItemType.image, item: baseItem)
          .asItem(
              DownloadProfile(downloadLocationId: image.downloadLocationId));
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
      isarItem.fileTranscodingProfile =
          DownloadProfile(downloadLocationId: image.downloadLocationId);
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
    _downloadsLogger.info("Migrating songs from Hive");
    final downloadedItemsBox = Hive.box<DownloadedSong>("DownloadedItems");

    List<DownloadItem> nodes = [];

    for (final song in downloadedItemsBox.values) {
      var baseItem = song.song;
      baseItem.mediaSources = [song.mediaSourceInfo];
      var isarItem =
          DownloadStub.fromItem(type: DownloadItemType.song, item: baseItem)
              .asItem(DownloadProfile(
                  transcodeCodec: FinampTranscodingCodec.original,
                  downloadLocationId: song.downloadLocationId));
      String? newPath;
      if (song.downloadLocationId == null) {
        for (MapEntry<String, DownloadLocation> entry in FinampSettingsHelper
            .finampSettings.downloadLocationsMap.entries) {
          if (song.path.contains(entry.value.currentPath)) {
            isarItem.fileTranscodingProfile = DownloadProfile(
                transcodeCodec: FinampTranscodingCodec.original,
                downloadLocationId: entry.key);
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
      } else {
        isarItem.fileTranscodingProfile = DownloadProfile(
            transcodeCodec: FinampTranscodingCodec.original,
            downloadLocationId: song.downloadLocationId);
        if (song.downloadLocationId ==
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
    _downloadsLogger.info("Migrating parents from Hive");
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
          .asItem(DownloadProfile(
              transcodeCodec: FinampTranscodingCodec.original,
              downloadLocationId: song.downloadLocationId));
      isarItem.userTranscodingProfile = DownloadProfile(
          transcodeCodec: FinampTranscodingCodec.original,
          downloadLocationId: song.downloadLocationId);
      // This should only be used for IDs/links and does not need real download items.
      List<DownloadItem> required = parent.downloadedChildren.values
          .map((e) =>
              DownloadStub.fromItem(type: DownloadItemType.song, item: e)
                  .asItem(null))
          .toList();
      isarItem.orderedChildren = required.map((e) => e.isarId).toList();

      if (parent.item.blurHash != null || parent.item.imageId != null) {
        required.add(DownloadStub.fromItem(
                type: DownloadItemType.image, item: parent.item)
            .asItem(null));
      }

      isarItem.state = DownloadItemState.complete;
      if (isarItem.baseItemType != BaseItemDtoType.playlist) {
        isarItem.viewId = parent.viewId;
      }

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

  Future<void> addDefaultPlaylistInfoDownload() async {
    String? downloadLocation =
        FinampSettingsHelper.finampSettings.defaultDownloadLocation;
    if (!FinampSettingsHelper.finampSettings.downloadLocationsMap
        .containsKey(downloadLocation)) {
      downloadLocation = null;
    }
    downloadLocation ??= FinampSettingsHelper.finampSettings.internalSongDir.id;

    // Automatically download playlist metadata (to enhance the playlist actions dialog and offline mode)
    await addDownload(
      stub: DownloadStub.fromFinampCollection(
          FinampCollection(type: FinampCollectionType.allPlaylistsMetadata)),
      transcodeProfile: DownloadProfile(
        transcodeCodec: FinampTranscodingCodec.original,
        downloadLocationId: downloadLocation,
      ),
    );
  }

  /// Get all user-downloaded items.  Used to show items on downloads screen.
  List<DownloadStub> getUserDownloaded() => getVisibleChildren(_anchor);

  /// Get all non-image children of an item.  Used to show item children on
  /// downloads screen.
  List<DownloadStub> getVisibleChildren(DownloadStub stub) {
    return _isar.downloadItems
        .where()
        .typeNotEqualTo(DownloadItemType.image)
        .filter()
        .requiredBy((q) => q.isarIdEqualTo(stub.isarId))
        .findAllSync();
  }

  /// Gets an item which requires the given stub to be downloaded.  Used in
  /// DownloadButton tooltip for incidental downloads.
  DownloadStub? getFirstRequiringItem(DownloadStub stub) {
    return _isar.downloadItems
        .filter()
        .requires((q) => q.isarIdEqualTo(stub.isarId))
        .findFirstSync();
  }

  /// Check whether the given item is part of the given collection.  Returns null
  /// if there is no metadata for the collection.
  bool? checkIfInCollection(BaseItemDto collection, BaseItemDto item) {
    var parent = _isar.downloadItems.getSync(
        DownloadStub.getHash(collection.id, DownloadItemType.collection));
    var childId = DownloadStub.getHash(item.id, item.downloadType);
    return parent?.orderedChildren?.contains(childId);
  }

  // This is for album/playlist screen
  /// Get all songs in a collection, ordered correctly.  Used to show songs on
  /// album/playlist screen.  Can return all songs in the album/playlist or
  /// just fully downloaded ones.
  Future<List<BaseItemDto>> getCollectionSongs(BaseItemDto item,
      {bool playable = true}) async {
    var stub =
        DownloadStub.fromItem(type: DownloadItemType.collection, item: item);

    var id = DownloadStub.getHash(item.id, DownloadItemType.collection);
    var query = _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .filter()
        .infoFor((q) => q.isarIdEqualTo(id))
        .optional(
            playable,
            (q) => q.group((q) => q
                .stateEqualTo(DownloadItemState.complete)
                .or()
                .stateEqualTo(DownloadItemState.needsRedownloadComplete)));

    var canonItem = _isar.downloadItems.getSync(stub.isarId);
    if (canonItem?.orderedChildren == null) {
      var items = await query
          .sortByParentIndexNumber()
          .thenByBaseIndexNumber()
          .thenByName()
          .findAll();
      return items.map((e) => e.baseItem).whereNotNull().toList();
    } else {
      List<DownloadItem> playlist = await query.findAll();
      Map<int, DownloadItem> childMap =
          Map.fromIterable(playlist, key: (e) => e.isarId);
      return canonItem!.orderedChildren!
          .map((e) => childMap[e]?.baseItem)
          .whereNotNull()
          .toList();
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
      bool nullableViewFilters = true,
      bool onlyFavorites = false}) {
    List<int> favoriteIds = [];
    if (onlyFavorites) {
      favoriteIds = _getFavoriteIds() ?? [];
    }
    return _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.song)
        .filter()
        .group((q) => q
            .stateEqualTo(DownloadItemState.complete)
            .or()
            .stateEqualTo(DownloadItemState.needsRedownloadComplete))
        .optional(onlyFavorites,
            (q) => q.anyOf(favoriteIds, (q, v) => q.isarIdEqualTo(v)))
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
  /// + onlyFavorites - return only favorite items
  Future<List<DownloadStub>> getAllCollections(
      {String? nameFilter,
      BaseItemDtoType? baseTypeFilter,
      BaseItemDto? relatedTo,
      bool fullyDownloaded = false,
      String? viewFilter,
      String? childViewFilter,
      bool nullableViewFilters = true,
      bool onlyFavorites = false}) {
    List<int> favoriteIds = [];
    if (onlyFavorites && baseTypeFilter != BaseItemDtoType.genre) {
      favoriteIds = _getFavoriteIds() ?? [];
    }
    return _isar.downloadItems
        .where()
        .typeEqualTo(DownloadItemType.collection)
        .filter()
        .optional(nameFilter != null,
            (q) => q.nameContains(nameFilter!, caseSensitive: false))
        .optional(baseTypeFilter != null,
            (q) => q.baseItemTypeEqualTo(baseTypeFilter!))
        // If allPlaylists is info downloaded, we may have info for empty
        // playlists.  We should only return playlists with at least 1 required
        // song in them.
        .optional(
            baseTypeFilter == BaseItemDtoType.playlist,
            (q) => q.info((q) =>
                q.typeEqualTo(DownloadItemType.song).requiredByIsNotEmpty()))
        .optional(
            relatedTo != null,
            (q) => q.infoFor((q) => q.info((q) => q.isarIdEqualTo(
                DownloadStub.getHash(
                    relatedTo!.id, DownloadItemType.collection)))))
        .optional(fullyDownloaded,
            (q) => q.not().stateEqualTo(DownloadItemState.notDownloaded))
        .optional(onlyFavorites,
            (q) => q.anyOf(favoriteIds, (q, v) => q.isarIdEqualTo(v)))
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
  /// Exactly one of the two arguments should be provided.
  Future<DownloadStub?> getSongInfo({BaseItemDto? item, String? id}) {
    assert((item == null) != (id == null));
    return _isar.downloadItems
        .get(DownloadStub.getHash(id ?? item!.id, DownloadItemType.song));
  }

  /// Get information about a downloaded collection by BaseItemDto or id.
  /// Exactly one of the two arguments should be provided.
  Future<DownloadStub?> getCollectionInfo({BaseItemDto? item, String? id}) {
    assert((item == null) != (id == null));
    return _isar.downloadItems
        .get(DownloadStub.getHash(id ?? item!.id, DownloadItemType.collection));
  }

  /// Get a song's DownloadItem by BaseItemDto or id.  This method performs file
  /// verification and should only be used when the downloaded file is actually
  /// needed, such as when building MediaItems.  Otherwise, [getSongInfo] should
  /// be used instead.  Exactly one of the two arguments should be provided.
  DownloadItem? getSongDownload({BaseItemDto? item, String? id}) {
    assert((item == null) != (id == null));
    return _getDownloadByID(id ?? item!.id, DownloadItemType.song);
  }

  /// Get an image's DownloadItem by BaseItemDto or id.  This method performs file
  /// verification and should only be used when the downloaded file is actually
  /// needed, such as when building ImageProviders.  Exactly one of the two arguments
  /// should be provided.
  DownloadItem? getImageDownload({BaseItemDto? item, String? blurHash}) {
    assert((item?.blurHash == null) != (blurHash == null));
    String? imageId = blurHash ?? item!.blurHash ?? item!.imageId;
    if (imageId == null) {
      return null;
    }
    return _getDownloadByID(imageId, DownloadItemType.image);
  }

  /// Get DownloadedLyrics by the corresponding track's BaseItemDto.
  Future<DownloadedLyrics?> getLyricsDownload(
      {required BaseItemDto baseItem}) async {
    var item = _isar.downloadedLyrics
        .getSync(DownloadStub.getHash(baseItem.id, DownloadItemType.song));
    return item;
  }

  bool? isFavorite(BaseItemDto item) {
    var stubId = DownloadStub.getHash(item.id, item.downloadType);
    return _getFavoriteIds()?.contains(stubId);
  }

  List<int>? _getFavoriteIds() {
    var stub = DownloadStub.fromFinampCollection(
        FinampCollection(type: FinampCollectionType.favorites));
    return _isar.downloadItems.getSync(stub.isarId)?.orderedChildren ?? [];
  }

  /// Get a downloadItem with verified files by id.
  DownloadItem? _getDownloadByID(String id, DownloadItemType type) {
    assert(type.hasFiles);
    var item = _isar.downloadItems.getSync(DownloadStub.getHash(id, type));
    if (item != null && _verifyDownload(item)) {
      return item;
    }
    return null;
  }

  /// Returns a stream of the list of downloads of a given state. Used to display
  /// active/failed/enqueued downloads on the active downloads screen.
  Stream<List<DownloadStub>> getDownloadList(DownloadItemState? state) {
    return _isar.downloadItems
        .where()
        .optional(
            state != DownloadItemState.syncFailed,
            (q) => q
                .typeEqualTo(DownloadItemType.song)
                .or()
                .typeEqualTo(DownloadItemType.image))
        .filter()
        .optional(state != null, (q) => q.stateEqualTo(state!))
        .watch(fireImmediately: true);
  }

  /// Returns the size of a download by recursively calculating the size of all
  /// required children.  Used to display item sizes on downloads screen.
  Future<int> getFileSize(DownloadStub item) async {
    var canonItem = await _isar.downloadItems.get(item.isarId);
    if (canonItem == null) return 0;
    Set<DownloadItem> info = {};
    Set<DownloadItem> required = {};
    _getFileChildren(canonItem, required, info, true);
    info = info.difference(required);
    int size = 0;
    for (var item in required) {
      size += await _getFileSize(item, true);
    }
    for (var item in info) {
      size += await _getFileSize(item, false);
    }
    return size;
  }

  /// Recursive subcomponent of [getFileSize].
  void _getFileChildren(DownloadItem item, Set<DownloadItem> required,
      Set<DownloadItem> info, bool isRequired) {
    if (required.contains(item) || (info.contains(item) && !isRequired)) {
      return;
    } else {
      if (isRequired) {
        required.add(item);
      } else {
        info.add(item);
      }
    }
    if (isRequired || item.type == DownloadItemType.song) {
      var children = item.requires.filter().findAllSync();
      for (var child in children) {
        _getFileChildren(child, required, info, isRequired);
      }
    }
    if (isRequired || item.type != DownloadItemType.song) {
      var children = item.info.filter().findAllSync();
      for (var child in children) {
        _getFileChildren(child, required, info, false);
      }
    }
  }

  /// Recursive subcomponent of [getFileSize].
  Future<int> _getFileSize(DownloadItem item, bool required) async {
    if (item.type == DownloadItemType.song &&
        item.state.isComplete &&
        required) {
      if (item.fileTranscodingProfile == null ||
          item.fileTranscodingProfile!.codec !=
              FinampTranscodingCodec.original ||
          item.baseItem?.mediaSources == null) {
        return await item.file
                ?.stat()
                .then((value) => value.size)
                .catchError((e) {
              _downloadsLogger
                  .fine("No file for song ${item.name} when calculating size.");
              return 0;
            }) ??
            0;
      } else {
        return item.baseItem?.mediaSources?[0].size ?? 0;
      }
    }
    if (item.type == DownloadItemType.image &&
        item.state == DownloadItemState.complete) {
      return await item.file
              ?.stat()
              .then((value) => value.size)
              .catchError((e) {
            _downloadsLogger
                .fine("No file for image ${item.name} when calculating size.");
            return 0;
          }) ??
          0;
    }
    return 0;
  }

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
