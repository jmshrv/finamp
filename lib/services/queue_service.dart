import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/gen/assets.gen.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:finamp/services/album_image_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path_helper;

import '../components/PlayerScreen/queue_source_helper.dart';
import 'downloads_service.dart';
import 'finamp_settings_helper.dart';
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';
import 'music_player_background_task.dart';

/// A track queueing service for Finamp.
class QueueService {
  /// Used to build content:// URIs that are handled by Finamp's built-in content provider.
  static final contentProviderPackageName = "com.unicornsonlsd.finamp";

  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final downloadsService = GetIt.instance<DownloadsService>();
  final _queueServiceLogger = Logger("QueueService");
  final _queuesBox = Hive.box<FinampStorableQueueInfo>("Queues");

  // internal state

  final List<FinampQueueItem> _queuePreviousTracks =
      []; // contains **all** items that have been played, including "next up"
  FinampQueueItem? _currentTrack; // the currently playing track
  final List<FinampQueueItem> _queueNextUp =
      []; // a temporary queue that gets appended to if the user taps "next up"
  final List<FinampQueueItem> _queue = []; // contains all regular queue items
  FinampQueueOrder _order = FinampQueueOrder(
      items: [],
      originalSource: QueueItemSource(
          id: "",
          name: const QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated),
          type: QueueItemSourceType.unknown),
      linearOrder: [],
      shuffledOrder: []); // contains all items that were at some point added to the regular queue, as well as their order when shuffle is enabled and disabled. This is used to loop the original queue once the end has been reached and "loop all" is enabled, **excluding** "next up" items and keeping the playback order.

  FinampPlaybackOrder _playbackOrder = FinampPlaybackOrder.linear;
  FinampLoopMode _loopMode = FinampLoopMode.none;
  double _playbackSpeed = 1.0;

  final _currentTrackStream = BehaviorSubject<FinampQueueItem?>.seeded(null);
  final _queueStream = BehaviorSubject<FinampQueueInfo?>.seeded(null);

  final _playbackOrderStream =
      BehaviorSubject<FinampPlaybackOrder>.seeded(FinampPlaybackOrder.linear);
  final _loopModeStream =
      BehaviorSubject<FinampLoopMode>.seeded(FinampLoopMode.none);
  final _playbackSpeedStream = BehaviorSubject<double>.seeded(1.0);

  // external queue state

  // the audio source used by the player. The first X items of all internal queues are merged together into this source, so that all player features, like gapless playback, are supported
  late final ShuffleOrder _shuffleOrder;
  late final ConcatenatingAudioSource _queueAudioSource;
  int _queueAudioSourceIndex = 0;

  // Flags for saving and loading saved queues
  int _saveUpdateCycleCount = 0;
  bool _saveUpdateImmediate = false;
  SavedQueueState _savedQueueState = SavedQueueState.preInit;
  FinampStorableQueueInfo? _failedSavedQueue = null;
  static const int _maxSavedQueues = 60;

  QueueService() {
    // _queueServiceLogger.level = Level.OFF;

    final finampSettings = FinampSettingsHelper.finampSettings;

    loopMode = finampSettings.loopMode;
    _queueServiceLogger.info("Restored loop mode to $loopMode from settings");

    playbackSpeed = finampSettings.playbackSpeed;
    _queueServiceLogger
        .info("Restored playback speed to $playbackSpeed from settings");

    _shuffleOrder = NextUpShuffleOrder(queueService: this);
    _queueAudioSource = ConcatenatingAudioSource(
      children: [],
      shuffleOrder: _shuffleOrder,
    );

    _audioHandler.playbackState.listen((event) async {
      // int indexDifference = (event.currentIndex ?? 0) - _queueAudioSourceIndex;

      final previousIndex = _queueAudioSourceIndex;
      _queueAudioSourceIndex = event.queueIndex ?? 0;

      if (previousIndex != _queueAudioSourceIndex) {
        _queueServiceLogger.finer(
            "Play queue index changed, new index: $_queueAudioSourceIndex");
        _queueFromConcatenatingAudioSource();
      } else {
        _saveUpdateImmediate = true;
      }
    });

    Stream.periodic(const Duration(seconds: 10)).listen((event) {
      // Update once per minute in background, and up to once every ten seconds if
      // pausing/seeking is occurring
      // We also update on every track switch.
      if (_saveUpdateCycleCount >= 5 || _saveUpdateImmediate) {
        if (_savedQueueState == SavedQueueState.pendingSave &&
            !_audioHandler.paused) {
          _savedQueueState = SavedQueueState.saving;
        }
        if (_savedQueueState == SavedQueueState.saving) {
          _saveUpdateImmediate = false;
          _saveUpdateCycleCount = 0;
          FinampStorableQueueInfo info = FinampStorableQueueInfo.fromQueueInfo(
              getQueue(), _audioHandler.playbackPosition.inMilliseconds);
          _queuesBox.put("latest", info);
          _queueServiceLogger.finest("Saved new periodic queue $info");
        }
      } else {
        _saveUpdateCycleCount++;
      }
    });

    // register callbacks
    // _audioHandler.setQueueCallbacks(
    //   nextTrackCallback: _applyNextTrack,
    //   previousTrackCallback: _applyPreviousTrack,
    //   skipToIndexCallback: _applySkipToTrackByOffset,
    // );
  }

  Future initializePlayer() =>
      _audioHandler.initializeAudioSource(_queueAudioSource, preload: true);

  void _queueFromConcatenatingAudioSource({
    logUpdate = true,
  }) {
    List<FinampQueueItem> allTracks = _audioHandler.effectiveSequence
            ?.map((e) => e.tag as FinampQueueItem)
            .toList() ??
        [];

    // final previousTrack = _currentTrack;
    // final previousTracksPreviousLength = _queuePreviousTracks.length;
    // final nextUpPreviousLength = _queueNextUp.length;
    // final queuePreviousLength = _queue.length;

    _queuePreviousTracks.clear();
    _queueNextUp.clear();
    _queue.clear();

    bool canHaveNextUp = true;

    // split the queue by old type
    for (int i = 0; i < allTracks.length; i++) {
      if (i < _queueAudioSourceIndex) {
        _queuePreviousTracks.add(allTracks[i]);
        if ([
          QueueItemSourceType.nextUp,
          QueueItemSourceType.nextUpAlbum,
          QueueItemSourceType.nextUpPlaylist,
          QueueItemSourceType.nextUpArtist
        ].contains(_queuePreviousTracks.last.source.type)) {
          _queuePreviousTracks.last.source = QueueItemSource(
              type: QueueItemSourceType.formerNextUp,
              name: const QueueItemSourceName(
                  type: QueueItemSourceNameType.tracksFormerNextUp),
              id: "former-next-up");
        }
        _queuePreviousTracks.last.type = QueueItemQueueType.previousTracks;
      } else if (i == _queueAudioSourceIndex) {
        _currentTrack = allTracks[i];
        _currentTrack!.type = QueueItemQueueType.currentTrack;
      } else {
        if (allTracks[i].type == QueueItemQueueType.currentTrack &&
            [
              QueueItemSourceType.nextUp,
              QueueItemSourceType.nextUpAlbum,
              QueueItemSourceType.nextUpPlaylist,
              QueueItemSourceType.nextUpArtist
            ].contains(allTracks[i].source.type)) {
          _queue.add(allTracks[i]);
          _queue.last.type = QueueItemQueueType.queue;
          _queue.last.source = QueueItemSource(
              type: QueueItemSourceType.formerNextUp,
              name: const QueueItemSourceName(
                  type: QueueItemSourceNameType.tracksFormerNextUp),
              id: "former-next-up");
          canHaveNextUp = false;
        } else if (allTracks[i].type == QueueItemQueueType.nextUp) {
          if (canHaveNextUp) {
            _queueNextUp.add(allTracks[i]);
            _queueNextUp.last.type = QueueItemQueueType.nextUp;
          } else {
            _queue.add(allTracks[i]);
            _queue.last.type = QueueItemQueueType.queue;
            _queue.last.source = QueueItemSource(
                type: QueueItemSourceType.formerNextUp,
                name: const QueueItemSourceName(
                    type: QueueItemSourceNameType.tracksFormerNextUp),
                id: "former-next-up");
          }
        } else {
          _queue.add(allTracks[i]);
          _queue.last.type = QueueItemQueueType.queue;
          canHaveNextUp = false;
        }
      }
    }

    if (allTracks.isEmpty) {
      _queueServiceLogger.fine("Queue is empty");
      _currentTrack = null;
      _audioHandler.playbackState.add(PlaybackState(
        processingState: AudioProcessingState.completed,
        playing: false,
        queueIndex: 0,
        updatePosition: Duration.zero,
        updateTime: DateTime.now(),
        bufferedPosition: Duration.zero,
      ));
    }

    refreshQueueStream();
    _currentTrackStream.add(_currentTrack);
    _audioHandler.mediaItem.add(_currentTrack?.item);
    _audioHandler.queue.add(_queuePreviousTracks
        .followedBy(_currentTrack != null ? [_currentTrack!] : [])
        .followedBy(_queueNextUp)
        .followedBy(_queue)
        .map((e) => e.item)
        .toList());
    // _audioHandler.queueTitle.add(_order.originalSource.name.toString());
    _audioHandler.queueTitle.add("Finamp");

    if (_savedQueueState == SavedQueueState.saving) {
      FinampStorableQueueInfo info =
          FinampStorableQueueInfo.fromQueueInfo(getQueue(), null);
      _queuesBox.put("latest", info);
      _queueServiceLogger.finest("Saved new rebuilt queue $info");
      _saveUpdateImmediate = false;
      _saveUpdateCycleCount = 0;
    }

    if (logUpdate) {
      _logQueues(message: "(current)");
    }
  }

  Future<void> performInitialQueueLoad() async {
    if (_savedQueueState == SavedQueueState.preInit) {
      try {
        _savedQueueState = SavedQueueState.init;
        await archiveSavedQueue(inInit: true);
        var info = _queuesBox.get("latest");
        if (info != null) {
          var keys = _queuesBox.values
              .map((x) => DateTime.fromMillisecondsSinceEpoch(x.creation))
              .toList();
          keys.sort();
          _queueServiceLogger.finest("Stored queue dates: $keys");
          if (keys.length > _maxSavedQueues) {
            var extra = keys
                .getRange(0, keys.length - _maxSavedQueues)
                .map((e) => e.millisecondsSinceEpoch.toString());
            _queueServiceLogger.finest("Deleting stored queues: $extra");
            await _queuesBox.deleteAll(extra);
          }

          if (FinampSettingsHelper.finampSettings.autoloadLastQueueOnStartup) {
            await loadSavedQueue(info);
          } else {
            _savedQueueState = SavedQueueState.pendingSave;
          }
        }
      } catch (e) {
        _queueServiceLogger.severe(e);
        rethrow;
      }
    }
  }

  /// Push latest queue into history if it is not empty and not a duplicate.
  /// If the caller is setting the queue state to saving, that should generally
  /// occur after this is called.
  Future<void> archiveSavedQueue({bool inInit = false}) async {
    if (_savedQueueState == SavedQueueState.saving || inInit) {
      var latest = _queuesBox.get("latest");
      if (latest != null && latest.songCount != 0) {
        await _queuesBox.put(latest.creation.toString(), latest);
      }
    }
  }

  Future<void> retryQueueLoad() async {
    if (_savedQueueState == SavedQueueState.failed &&
        _failedSavedQueue != null) {
      await loadSavedQueue(_failedSavedQueue!);
    }
  }

  Future<void> loadSavedQueue(FinampStorableQueueInfo info) async {
    if (_savedQueueState == SavedQueueState.loading) {
      return Future.error("A saved queue is currently loading");
    }
    // After loading queue, do not begin overwriting latest until the user modifies
    // the queue or begins playback.  This prevents saving unused queues that
    // had loading errors or were immediately overwritten.
    SavedQueueState? finalState = SavedQueueState.pendingSave;
    try {
      _savedQueueState = SavedQueueState.loading;
      if (info.songCount == 0) {
        return;
      }
      refreshQueueStream();

      List<String> allIds = info.previousTracks +
          ((info.currentTrack == null) ? [] : [info.currentTrack!]) +
          info.nextUp +
          info.queue;
      Map<String, jellyfin_models.BaseItemDto> idMap = {};
      Set<String> playlistIds = {};

      // If queue source is playlist, fetch via parent to retrieve metadata needed
      // for removal from playlist via queueItem
      if (!FinampSettingsHelper.finampSettings.isOffline &&
          info.source?.type == QueueItemSourceType.playlist &&
          info.source?.item != null) {
        var itemList = await _jellyfinApiHelper.getItems(
              parentItem: info.source!.item!,
              sortBy: "ParentIndexNumber,IndexNumber,SortName",
              includeItemTypes: "Audio",
            ) ??
            [];
        for (var d2 in itemList) {
          idMap[d2.id] = d2;
        }
        playlistIds = itemList.map((e) => e.id).toSet();
      }

      // Get list of unique ids that do not yet have an associated item.
      List<String> missingIds = allIds.toSet().difference(playlistIds).toList();

      if (FinampSettingsHelper.finampSettings.isOffline) {
        for (var id in missingIds) {
          jellyfin_models.BaseItemDto? item =
              downloadsService.getSongDownload(id: id)?.baseItem;
          if (item != null) {
            idMap[id] = item;
          }
        }
      } else {
        for (var slice in missingIds.slices(200)) {
          List<jellyfin_models.BaseItemDto> itemList =
              await _jellyfinApiHelper.getItems(itemIds: slice) ?? [];
          for (var d2 in itemList) {
            idMap[d2.id] = d2;
          }
        }
      }

      Map<String, List<jellyfin_models.BaseItemDto>> items = {
        "previous":
            info.previousTracks.map((e) => idMap[e]).whereNotNull().toList(),
        "current":
            [info.currentTrack].map((e) => idMap[e]).whereNotNull().toList(),
        "next": info.nextUp.map((e) => idMap[e]).whereNotNull().toList(),
        "queue": info.queue.map((e) => idMap[e]).whereNotNull().toList(),
      };
      int sumLengths(int sum, Iterable val) => val.length + sum;
      int loadedSongs = items.values.fold(0, sumLengths);
      int droppedSongs = info.songCount - loadedSongs;

      if (_savedQueueState != SavedQueueState.loading) {
        finalState = null;
        return Future.error("Loading of saved Queue was interrupted.");
      }

      await _replaceWholeQueue(
          itemList: items["previous"]! + items["current"]! + items["queue"]!,
          initialIndex: items["previous"]!.length,
          beginPlaying: false,
          source: info.source ??
              QueueItemSource(
                  type: QueueItemSourceType.unknown,
                  name: const QueueItemSourceName(
                      type: QueueItemSourceNameType.savedQueue),
                  id: "savedqueue"));

      Future<void> seekFuture = Future.value();
      if ((info.currentTrackSeek ?? 0) > 5000) {
        seekFuture = _audioHandler
            .seek(Duration(milliseconds: (info.currentTrackSeek ?? 0) - 1000));
      }

      await addToNextUp(items: items["next"]!);
      await seekFuture;
      _queueServiceLogger.info("Loaded saved queue.");
      if (loadedSongs == 0 && info.songCount > 0) {
        finalState = SavedQueueState.failed;
        _failedSavedQueue = info;
      } else if (droppedSongs > 0) {
        GlobalSnackbar.message((scaffold) =>
            AppLocalizations.of(scaffold)!.queueRestoreError(droppedSongs));
      }
    } finally {
      if (finalState != null) {
        _savedQueueState = finalState;
      }
      refreshQueueStream();
    }
  }

  Future<void> startPlayback({
    required List<jellyfin_models.BaseItemDto> items,
    required QueueItemSource source,
    FinampPlaybackOrder? order,
    int? startingIndex,
  }) async {
    // _initialQueue = list; // save original PlaybackList for looping/restarting and meta info

    if (items.isEmpty) {
      _queueServiceLogger
          .warning("Cannot start playback of empty queue! Source: $source");
      return;
    }

    if (startingIndex == null) {
      if (order == FinampPlaybackOrder.shuffled) {
        startingIndex = Random().nextInt(items.length);
      } else {
        startingIndex = 0;
      }
    }

    await archiveSavedQueue();
    _savedQueueState = SavedQueueState.saving;

    await _replaceWholeQueue(
        itemList: items,
        source: source,
        order: order,
        initialIndex: startingIndex);
    _queueServiceLogger.info(
        "Started playing '${GlobalSnackbar.materialAppScaffoldKey.currentContext != null ? source.name.getLocalized(GlobalSnackbar.materialAppScaffoldKey.currentContext!) : source.name.type}' (${source.type}) in order $order from index $startingIndex");
    _queueServiceLogger
        .info("Items for queue: [${items.map((e) => e.name).join(", ")}]");
  }

  /// Replaces the queue with the given list of items. If startAtIndex is specified, Any items below it
  /// will be ignored. This is used for when the user taps in the middle of an album to start from that point.
  Future<void> _replaceWholeQueue(
      {required List<jellyfin_models.BaseItemDto> itemList,
      required QueueItemSource source,
      required int initialIndex,
      FinampPlaybackOrder? order,
      bool beginPlaying = true}) async {
    try {
      if (initialIndex > itemList.length) {
        return Future.error(
            "initialIndex is bigger than the itemList! ($initialIndex > ${itemList.length})");
      }

      _queue.clear(); // empty queue
      _queuePreviousTracks.clear();
      _queueNextUp.clear();
      _currentTrack = null;
      playlistRemovalsCache.clear();

      List<FinampQueueItem> newItems = [];
      List<int> newLinearOrder = [];
      List<int> newShuffledOrder;
      for (int i = 0; i < itemList.length; i++) {
        jellyfin_models.BaseItemDto item = itemList[i];
        try {
          MediaItem mediaItem = await generateMediaItem(item,
              contextNormalizationGain: source.contextNormalizationGain);
          newItems.add(FinampQueueItem(
            item: mediaItem,
            source: source,
            type: i == 0
                ? QueueItemQueueType.currentTrack
                : QueueItemQueueType.queue,
          ));
          newLinearOrder.add(i);
        } catch (e, trace) {
          _queueServiceLogger.severe(e, e, trace);
        }
      }

      //await stopPlayback(); //TODO is this really needed?
      // await _audioHandler.initializeAudioSource(_queueAudioSource);
      await _audioHandler.stopPlayback();
      await _queueAudioSource.clear();

      List<AudioSource> audioSources = [];

      for (final queueItem in newItems) {
        audioSources.add(await _queueItemToAudioSource(queueItem));
      }

      await _queueAudioSource.addAll(audioSources);

      // set first item in queue
      _queueAudioSourceIndex = initialIndex;
      if (_playbackOrder == FinampPlaybackOrder.shuffled) {
        _queueAudioSourceIndex = _queueAudioSource.shuffleIndices[initialIndex];
      }
      _audioHandler.setNextInitialIndex(_queueAudioSourceIndex);

      await _audioHandler.initializeAudioSource(_queueAudioSource,
          preload: true);

      newShuffledOrder = List.from(_queueAudioSource.shuffleIndices);

      _order = FinampQueueOrder(
        items: newItems,
        originalSource: source,
        linearOrder: newLinearOrder,
        shuffledOrder: newShuffledOrder,
      );

      _queueServiceLogger.fine("Order items length: ${_order.items.length}");

      // set playback order to trigger shuffle if necessary (fixes indices being wrong when starting with shuffle enabled)

      if (order != null) {
        playbackOrder = order;
      }

      // _queueStream.add(getQueue());
      _queueFromConcatenatingAudioSource();

      if (beginPlaying) {
        unawaited(_audioHandler
            .play()); // don't await this, because it will not return until playback is finished
      } else {
        unawaited(_audioHandler.pause());
      }

      _audioHandler.nextInitialIndex = null;
    } catch (e) {
      _queueServiceLogger.severe(e);
      rethrow;
    }
  }

  Future<void> stopPlayback() async {
    queueServiceLogger.info("Stopping playback");

    await archiveSavedQueue();
    if (_savedQueueState == SavedQueueState.pendingSave) {
      _savedQueueState = SavedQueueState.saving;
    }

    await _queueAudioSource.clear();

    _queueFromConcatenatingAudioSource();

    await _audioHandler.stopPlayback();

    // await _audioHandler.initializeAudioSource(_queueAudioSource,
    //     preload: false);

    return;
  }

  Future<void> addToQueue({
    required List<jellyfin_models.BaseItemDto> items,
    QueueItemSource? source,
  }) async {
    if (_queueAudioSource.length == 0) {
      return _replaceWholeQueue(
        itemList: items,
        source: source ??
            QueueItemSource(
              type: QueueItemSourceType.queue,
              name: const QueueItemSourceName(
                  type: QueueItemSourceNameType.queue),
              id: "queue",
              item: null,
            ),
        initialIndex: 0,
        beginPlaying: false,
      );
    }

    try {
      if (_savedQueueState == SavedQueueState.pendingSave) {
        _savedQueueState = SavedQueueState.saving;
      }
      List<FinampQueueItem> queueItems = [];
      for (final item in items) {
        queueItems.add(FinampQueueItem(
          item: await generateMediaItem(item,
              contextNormalizationGain: source?.contextNormalizationGain),
          source: source ?? _order.originalSource,
          type: QueueItemQueueType.queue,
        ));
      }

      List<AudioSource> audioSources = [];
      for (final item in queueItems) {
        audioSources.add(await _queueItemToAudioSource(item));
        _queueServiceLogger.fine(
            "Added '${item.item.title}' to queue from '${source?.name}' (${source?.type})");
      }
      await _queueAudioSource.addAll(audioSources);

      _queueFromConcatenatingAudioSource(); // update internal queues
    } catch (e) {
      _queueServiceLogger.severe(e);
      rethrow;
    }
  }

  Future<void> addNext({
    required List<jellyfin_models.BaseItemDto> items,
    QueueItemSource? source,
  }) async {
    if (_queueAudioSource.length == 0) {
      return _replaceWholeQueue(
        itemList: items,
        source: source ??
            QueueItemSource(
              type: QueueItemSourceType.queue,
              name: const QueueItemSourceName(
                  type: QueueItemSourceNameType.queue),
              id: "queue",
              item: null,
            ),
        initialIndex: 0,
        beginPlaying: false,
      );
    }

    try {
      if (_savedQueueState == SavedQueueState.pendingSave) {
        _savedQueueState = SavedQueueState.saving;
      }
      List<FinampQueueItem> queueItems = [];
      for (final item in items) {
        queueItems.add(FinampQueueItem(
          item: await generateMediaItem(item,
              contextNormalizationGain: source?.contextNormalizationGain),
          source: source ??
              QueueItemSource(
                  id: "next-up",
                  name: const QueueItemSourceName(
                      type: QueueItemSourceNameType.nextUp),
                  type: QueueItemSourceType.nextUp),
          type: QueueItemQueueType.nextUp,
        ));
      }

      int adjustedQueueIndex =
          getActualIndexByLinearIndex(_queueAudioSourceIndex);

      for (final queueItem in queueItems.reversed) {
        int offset = min(_queueAudioSource.length, 1);
        await _queueAudioSource.insert(adjustedQueueIndex + offset,
            await _queueItemToAudioSource(queueItem));
        _queueServiceLogger.fine(
            "Appended '${queueItem.item.title}' to Next Up (index ${adjustedQueueIndex + offset})");
      }

      _queueFromConcatenatingAudioSource(); // update internal queues
    } catch (e) {
      _queueServiceLogger.severe(e);
      rethrow;
    }
  }

  Future<void> addToNextUp({
    required List<jellyfin_models.BaseItemDto> items,
    QueueItemSource? source,
  }) async {
    if (_queueAudioSource.length == 0) {
      return _replaceWholeQueue(
        itemList: items,
        source: source ??
            QueueItemSource(
              type: QueueItemSourceType.queue,
              name: const QueueItemSourceName(
                  type: QueueItemSourceNameType.queue),
              id: "queue",
              item: null,
            ),
        initialIndex: 0,
        beginPlaying: false,
      );
    }

    try {
      if (_savedQueueState == SavedQueueState.pendingSave) {
        _savedQueueState = SavedQueueState.saving;
      }
      List<FinampQueueItem> queueItems = [];
      for (final item in items) {
        queueItems.add(FinampQueueItem(
          item: await generateMediaItem(item,
              contextNormalizationGain: source?.contextNormalizationGain),
          source: source ??
              QueueItemSource(
                  id: "next-up",
                  name: const QueueItemSourceName(
                      type: QueueItemSourceNameType.nextUp),
                  type: QueueItemSourceType.nextUp),
          type: QueueItemQueueType.nextUp,
        ));
      }

      _queueFromConcatenatingAudioSource(
          logUpdate: false); // update internal queues
      int offset = _queueNextUp.length + min(_queueAudioSource.length, 1);

      int adjustedQueueIndex =
          getActualIndexByLinearIndex(_queueAudioSourceIndex);

      for (final queueItem in queueItems) {
        await _queueAudioSource.insert(adjustedQueueIndex + offset,
            await _queueItemToAudioSource(queueItem));
        _queueServiceLogger.fine(
            "Appended '${queueItem.item.title}' to Next Up (index ${adjustedQueueIndex + offset})");
        offset++;
      }

      _queueFromConcatenatingAudioSource(); // update internal queues
    } catch (e) {
      _queueServiceLogger.severe(e);
      rethrow;
    }
  }

  Future<void> skipByOffset(int offset) async {
    await _audioHandler.skipByOffset(offset);
  }

  Future<void> removeAtOffset(int offset) async {
    int adjustedQueueIndex =
        getActualIndexByLinearIndex(_queueAudioSourceIndex + offset);

    await _queueAudioSource.removeAt(adjustedQueueIndex);
    // await _audioHandler.removeQueueItemAt(index);
    _queueFromConcatenatingAudioSource();
  }

  Future<void> reorderByOffset(int oldOffset, int newOffset) async {
    _queueServiceLogger.fine(
        "Reordering queue item at offset $oldOffset to offset $newOffset");

    int adjustedQueueIndex =
        getActualIndexByLinearIndex(_queueAudioSourceIndex);

    //!!! the player will automatically change the shuffle indices of the ConcatenatingAudioSource if shuffle is enabled, so we need to use the regular track index here
    final oldIndex = adjustedQueueIndex + oldOffset;
    final newIndex = oldOffset < newOffset
        ? adjustedQueueIndex + newOffset - 1
        : adjustedQueueIndex + newOffset;

    await _queueAudioSource.move(oldIndex, newIndex);
    _queueFromConcatenatingAudioSource();
  }

  Future<void> clearNextUp() async {
    int adjustedQueueIndex =
        getActualIndexByLinearIndex(_queueAudioSourceIndex);

    // remove all items from Next Up
    if (_queueNextUp.isNotEmpty) {
      await _queueAudioSource.removeRange(
          adjustedQueueIndex + 1, adjustedQueueIndex + 1 + _queueNextUp.length);
      _queueNextUp.clear();
    }

    _queueFromConcatenatingAudioSource(); // update internal queues
  }

  FinampQueueInfo getQueue() {
    return FinampQueueInfo(
      id: _order.id,
      previousTracks: _queuePreviousTracks,
      currentTrack: _currentTrack,
      queue: _queue,
      nextUp: _queueNextUp,
      source: _order.originalSource,
      saveState: _savedQueueState,
    );
  }

  BehaviorSubject<FinampQueueInfo?> getQueueStream() {
    return _queueStream;
  }

  void refreshQueueStream() {
    _queueStream.add(getQueue());
  }

  /// Returns the entire queue (Next Up + regular queue)
  /// If [next] is provided (and greater than 0), at most [next] QueueItems from Next Up and the regular queue will be returned
  /// If [previous] is provided (and greater than 0), at most [previous] QueueItems from previous tracks will be additionally returned.
  /// The length of the returned list may be less than the sum of [next] and [previous] if there are not enough items in the queue
  /// The current track is *not* included
  List<FinampQueueItem> peekQueue({
    int? next,
    int previous = 0,
  }) {
    List<FinampQueueItem> nextTracks = [];
    if (_queuePreviousTracks.isNotEmpty && previous > 0) {
      nextTracks.addAll(_queuePreviousTracks.sublist(
          max(0, _queuePreviousTracks.length - previous),
          _queuePreviousTracks.length));
    }
    if (_queueNextUp.isNotEmpty) {
      if (next == null) {
        nextTracks.addAll(_queueNextUp);
      } else {
        nextTracks
            .addAll(_queueNextUp.sublist(0, min(next, _queueNextUp.length)));
        next -= _queueNextUp.length;
      }
    }
    if (_queue.isNotEmpty) {
      if (next == null) {
        nextTracks.addAll(_queue);
      } else if (next > 0) {
        nextTracks.addAll(_queue.sublist(0, min(next, _queue.length)));
      }
    }
    return nextTracks;
  }

  BehaviorSubject<FinampPlaybackOrder> getPlaybackOrderStream() {
    return _playbackOrderStream;
  }

  BehaviorSubject<FinampLoopMode> getLoopModeStream() {
    return _loopModeStream;
  }

  BehaviorSubject<double> getPlaybackSpeedStream() {
    return _playbackSpeedStream;
  }

  BehaviorSubject<FinampQueueItem?> getCurrentTrackStream() {
    return _currentTrackStream;
  }

  FinampQueueItem? getCurrentTrack() {
    return _currentTrack;
  }

  set playbackSpeed(double speed) {
    _playbackSpeed = speed;
    _playbackSpeedStream.add(speed);
    _audioHandler.setSpeed(speed);
    FinampSettingsHelper.setPlaybackSpeed(playbackSpeed);
    _queueServiceLogger.fine(
        "Playback speed set to ${FinampSettingsHelper.finampSettings.playbackSpeed}");
  }

  double get playbackSpeed => _playbackSpeed;

  set loopMode(FinampLoopMode mode) {
    _loopMode = mode;

    _loopModeStream.add(mode);

    if (mode == FinampLoopMode.one) {
      _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
    } else if (mode == FinampLoopMode.all) {
      _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
    } else {
      _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    }

    FinampSettingsHelper.setLoopMode(loopMode);
    _queueServiceLogger.fine(
        "Loop mode set to ${FinampSettingsHelper.finampSettings.loopMode}");
  }

  FinampLoopMode get loopMode => _loopMode;

  set playbackOrder(FinampPlaybackOrder order) {
    _playbackOrder = order;
    _queueServiceLogger.fine("Playback order set to $order");

    _playbackOrderStream.add(order);

    // update queue accordingly and generate new shuffled order if necessary
    if (_playbackOrder == FinampPlaybackOrder.shuffled) {
      _audioHandler.shuffle().then((_) => _audioHandler
          .setShuffleMode(AudioServiceShuffleMode.all)
          .then((_) => _queueFromConcatenatingAudioSource()));
    } else {
      _audioHandler
          .setShuffleMode(AudioServiceShuffleMode.none)
          .then((_) => _queueFromConcatenatingAudioSource());
    }
  }

  FinampPlaybackOrder get playbackOrder => _playbackOrder;

  void togglePlaybackOrder() {
    if (_playbackOrder == FinampPlaybackOrder.shuffled) {
      playbackOrder = FinampPlaybackOrder.linear;
    } else {
      playbackOrder = FinampPlaybackOrder.shuffled;
    }
  }

  void toggleLoopMode() {
    if (_loopMode == FinampLoopMode.all) {
      loopMode = FinampLoopMode.one;
    } else if (_loopMode == FinampLoopMode.one) {
      loopMode = FinampLoopMode.none;
    } else {
      loopMode = FinampLoopMode.all;
    }
  }

  Logger get queueServiceLogger => _queueServiceLogger;

  int getActualIndexByLinearIndex(int linearIndex) {
    if (_playbackOrder == FinampPlaybackOrder.shuffled &&
        _queueAudioSource.shuffleIndices.isNotEmpty) {
      return _queueAudioSource.shuffleIndices[linearIndex];
    } else {
      return linearIndex;
    }
  }

  void _logQueues({String message = ""}) {
    // generate string for `_queue`
    String queueString = "";
    for (FinampQueueItem queueItem in _queuePreviousTracks) {
      queueString += "${queueItem.item.title}, ";
    }
    queueString += "[[${_currentTrack?.item.title}]], ";
    queueString += "{";
    for (FinampQueueItem queueItem in _queueNextUp) {
      queueString += "${queueItem.item.title}, ";
    }
    queueString += "} ";
    for (FinampQueueItem queueItem in _queue) {
      queueString += "${queueItem.item.title}, ";
    }

    // generate string for `_queueAudioSource`
    // String queueAudioSourceString = "";
    // queueAudioSourceString += "[${_queueAudioSource.sequence.first.toString()}], ";
    // for (AudioSource queueItem in _queueAudioSource.sequence.sublist(1)) {
    //   queueAudioSourceString += "${queueItem.toString()}, ";
    // }

    // log queues
    _queueServiceLogger.finer(
        "Queue $message [${_queuePreviousTracks.length}-1-${_queueNextUp.length}-${_queue.length}]: $queueString");
    // _queueServiceLogger.finer(
    //   "Audio Source Queue $message [${_queue.length}]: $queueAudioSourceString"
    // )
  }

  /// [contextNormalizationGain] is the normalization gain of the context that the song is being played in, e.g. the album
  /// Should only be used when the tracks within that context come from the same source, e.g. the same album (or maybe artist?). Usually makes no sense for playlists.
  Future<MediaItem> generateMediaItem(
    jellyfin_models.BaseItemDto item, {
    double? contextNormalizationGain,
    MediaItemParentType? parentType,
    String? parentId,
    bool Function(
            {jellyfin_models.BaseItemDto? item, TabContentType? contentType})?
        isPlayable,
  }) async {
    const uuid = Uuid();

    MediaItemId? itemId;
    final tabContentType = TabContentType.fromItemType(item.type ?? "Audio");

    if (parentType != null) {
      itemId = MediaItemId(
        contentType: tabContentType,
        parentType: parentType,
        parentId: parentId ?? item.parentId,
        itemId: item.id,
      );
    }

    bool isDownloaded = false;
    bool isItemPlayable = isPlayable?.call(item: item) ?? true;
    DownloadItem? downloadedSong;
    DownloadStub? downloadedCollection;
    DownloadItem? downloadedImage;

    if (item.type == "Audio") {
      downloadedSong = downloadsService.getSongDownload(item: item);
      isDownloaded = downloadedSong != null;
    } else {
      downloadedCollection =
          await downloadsService.getCollectionInfo(item: item);
      if (downloadedCollection != null) {
        final downloadStatus =
            downloadsService.getStatus(downloadedCollection, null);
        isDownloaded = downloadStatus != DownloadItemStatus.notNeeded;
      }
    }

    try {
      downloadedImage = downloadsService.getImageDownload(item: item);
    } catch (e) {
      _queueServiceLogger.warning(
          "Couldn't get the offline image for track '${item.name}' because it's not downloaded or missing a blurhash");
    }

    Uri? artUri;

    // replace with content uri or jellyfin api uri
    if (downloadedImage != null) {
      artUri = downloadedImage.file?.uri;
    } else if (!FinampSettingsHelper.finampSettings.isOffline) {
      artUri = _jellyfinApiHelper.getImageUrl(item: item);
      // try to get image file (Android Automotive needs this)
      if (artUri != null) {
        try {
          final fileInfo =
              await AudioService.cacheManager.getFileFromCache(item.id);
          if (fileInfo != null) {
            artUri = fileInfo.file.uri;
          }
        } catch (e) {
          _queueServiceLogger.severe(
              "Error setting new media artwork uri for item: ${item.id} name: ${item.name}",
              e);
        }
      }
    }

    // use content provider for handling media art on Android
    if (Platform.isAndroid) {
      // replace with placeholder art
      if (artUri == null) {
        final applicationSupportDirectory =
            await getApplicationSupportDirectory();
        // artUri = Uri(
        //     scheme: "content",
        //     host: contentProviderPackageName,
        //     path: path_helper.join(applicationSupportDirectory.absolute.path,
        //         Assets.images.albumWhite.path));
        artUri = _jellyfinApiHelper.getImageUrl(item: item) ?? (await getFallbackImageFile()).uri;
      } else {
        // store the origin in fragment since it should be unused
        artUri = Uri(
            scheme: "content",
            host: contentProviderPackageName,
            path: artUri.path,
            fragment: ["http", "https"].contains(artUri.scheme)
                ? artUri.origin
                : null);
      }
    }

    _queueServiceLogger.fine("imageUri: $imageUri\ndownloadedImage: ${downloadedImage?.file != null}\njellyfinUri: ${_jellyfinApiHelper.getImageUrl(item: item)}\nfallbackUri: ${(await getFallbackImageFile()).uri}\nitem.imageId: ${item.imageId}\nitem.imageTags: ${item.imageTags}");

    return MediaItem(
      id: itemId?.toString() ?? uuid.v4(),
      playable:
          isItemPlayable, // this dictates whether clicking on an item will try to play it or browse it in media browsers like Android Auto
      album: item.album,
      artist: item.artists?.join(", ") ?? item.albumArtist,
      artUri: artUri,
      title: item.name ?? "unknown",
      extras: {
        "itemJson": item.toJson(setOffline: false),
        "shouldTranscode": FinampSettingsHelper.finampSettings.shouldTranscode,
        "downloadedSongPath": downloadedSong?.file?.path,
        "android.media.extra.DOWNLOAD_STATUS": isDownloaded ? 2 : 0,
        "isOffline": FinampSettingsHelper.finampSettings.isOffline,
        "contextNormalizationGain": contextNormalizationGain,
      },
      // Jellyfin returns microseconds * 10 for some reason
      duration: item.runTimeTicksDuration(),
    );
  }

  /// Syncs the list of MediaItems (_queue) with the internal queue of the player.
  /// Called by onAddQueueItem and onUpdateQueue.
  Future<AudioSource> _queueItemToAudioSource(FinampQueueItem queueItem) async {
    if (queueItem.item.extras!["downloadedSongPath"] == null) {
      // If DownloadedSong wasn't passed, we assume that the item is not
      // downloaded.

      // If offline, we throw an error so that we don't accidentally stream from
      // the internet. See the big comment in _songUri() to see why this was
      // passed in extras.
      if (queueItem.item.extras!["isOffline"]) {
        return Future.error(
            "Offline mode enabled but downloaded song not found.");
      } else {
        if (queueItem.item.extras!["shouldTranscode"] == true) {
          return HlsAudioSource(await _songUri(queueItem.item), tag: queueItem);
        } else {
          return AudioSource.uri(await _songUri(queueItem.item),
              tag: queueItem);
        }
      }
    } else {
      // We have to deserialise this because Dart is stupid and can't handle
      // sending classes through isolates.
      final downloadedSongPath = queueItem.item.extras!["downloadedSongPath"];

      // Path verification and stuff is done in AudioServiceHelper, so this path
      // should be valid.
      final downloadUri = Uri.file(downloadedSongPath);
      return AudioSource.uri(downloadUri, tag: queueItem);
    }
  }

  Future<Uri> _songUri(MediaItem mediaItem) async {
    // When creating the MediaItem (usually in AudioServiceHelper), we specify
    // whether or not to transcode. We used to pull from FinampSettings here,
    // but since audio_service runs in an isolate (or at least, it does until
    // 0.18), the value would be wrong if changed while a song was playing since
    // Hive is bad at multi-isolate stuff.

    final parsedBaseUrl = Uri.parse(_finampUserHelper.currentUser!.baseUrl);

    List<String> builtPath = List.from(parsedBaseUrl.pathSegments);

    Map<String, String> queryParameters =
        Map.from(parsedBaseUrl.queryParameters);

    // We include the user token as a query parameter because just_audio used to
    // have issues with headers in HLS, and this solution still works fine
    queryParameters["ApiKey"] = _finampUserHelper.currentUser!.accessToken;
    // // indicate which play session this stream belongs to, this will be referenced when reporting playback progress
    // queryParameters["PlaySessionId"] = _order.id; //!!! this currently breaks transcoding for some reason

    if (mediaItem.extras!["shouldTranscode"]) {
      builtPath.addAll([
        "Audio",
        mediaItem.extras!["itemJson"]["Id"],
        "main.m3u8",
      ]);

      queryParameters.addAll({
        "audioCodec": "aac",
        // Ideally we'd use 48kHz when the source is, realistically it doesn't
        // matter too much
        "audioSampleRate": "44100",
        "maxAudioBitDepth": "16",
        "audioBitRate":
            FinampSettingsHelper.finampSettings.transcodeBitrate.toString(),
        "segmentContainer": FinampSettingsHelper
            .finampSettings.transcodingSegmentContainer.container,
        "transcodeReasons": "ContainerBitrateExceedsLimit",
      });
    } else {
      builtPath.addAll([
        "Items",
        mediaItem.extras!["itemJson"]["Id"],
        "File",
      ]);
    }

    return Uri(
      host: parsedBaseUrl.host,
      port: parsedBaseUrl.port,
      scheme: parsedBaseUrl.scheme,
      userInfo: parsedBaseUrl.userInfo,
      pathSegments: builtPath,
      queryParameters: queryParameters,
    );
  }
}

class NextUpShuffleOrder extends ShuffleOrder {
  final Random _random;
  final QueueService _queueService;
  @override
  List<int> indices = <int>[];

  NextUpShuffleOrder({Random? random, required QueueService queueService})
      : _random = random ?? Random(),
        _queueService = queueService;

  @override
  void shuffle({int? initialIndex}) {
    assert(initialIndex == null || indices.contains(initialIndex));

    if (initialIndex == null) {
      // will only be called manually, when replacing the whole queue
      indices.shuffle(_random);
      return;
    }

    indices.clear();
    _queueService._queueFromConcatenatingAudioSource(logUpdate: false);
    FinampQueueInfo queueInfo = _queueService.getQueue();
    indices = List.generate(
        queueInfo.previousTracks.length +
            1 +
            queueInfo.nextUp.length +
            queueInfo.queue.length,
        (i) => i);
    if (indices.length <= 1) return;
    indices.shuffle(_random);

    _queueService.queueServiceLogger.finest("initialIndex: $initialIndex");

    // log indices
    String indicesString = "";
    for (int index in indices) {
      indicesString += "$index, ";
    }
    _queueService.queueServiceLogger.finest("Shuffled indices: $indicesString");
    _queueService.queueServiceLogger
        .finest("Current Track: ${queueInfo.currentTrack}");

    int nextUpLength = 0;
    nextUpLength = queueInfo.nextUp.length;

    const initialPos = 0; // current item will always be at the front

    // move current track and next up tracks to the front, pushing all other tracks back while keeping their order
    // remove current track and next up tracks from indices and save them in a separate list
    List<int> currentTrackIndices = [];
    for (int i = 0; i < 1 + nextUpLength; i++) {
      currentTrackIndices
          .add(indices.removeAt(indices.indexOf(initialIndex + i)));
    }
    // insert current track and next up tracks at the front
    indices.insertAll(initialPos, currentTrackIndices);

    // log indices
    indicesString = "";
    for (int index in indices) {
      indicesString += "$index, ";
    }
    _queueService.queueServiceLogger
        .finest("Shuffled indices (swapped): $indicesString");
  }

  /// `index` is the linear index of the item in the ConcatenatingAudioSource
  @override
  void insert(int index, int count) {
    int insertionPoint = index;
    int linearIndexOfPreviousItem = index - 1;

    // _queueService!._queueFromConcatenatingAudioSource(logUpdate: false);
    // QueueInfo queueInfo = _queueService!.getQueue();

    // // log indices
    // String indicesString = "";
    // for (int index in indices) {
    //   indicesString += "$index, ";
    // }
    // _queueService!.queueServiceLogger.finest("Shuffled indices: $indicesString");
    // _queueService!.queueServiceLogger.finest("Current Track: ${queueInfo.currentTrack}");

    if (index >= indices.length) {
      // handle appending to the queue
      insertionPoint = indices.length;
    } else {
      // handle adding to Next Up
      int shuffledIndexOfPreviousItem =
          indices.indexOf(linearIndexOfPreviousItem);
      if (shuffledIndexOfPreviousItem != -1) {
        insertionPoint = shuffledIndexOfPreviousItem + 1;
      }
      _queueService.queueServiceLogger.finest(
          "Inserting $count items at index $index (shuffled indices insertion point: $insertionPoint) (index of previous item: $shuffledIndexOfPreviousItem)");
    }

    // Offset indices after insertion point.
    for (var i = 0; i < indices.length; i++) {
      if (indices[i] >= index) {
        indices[i] += count;
      }
    }

    // Insert new indices at the specified position.
    final newIndices = List.generate(count, (i) => index + i);
    indices.insertAll(insertionPoint, newIndices);
  }

  @override
  void removeRange(int start, int end) {
    // log indices
    String indicesString = "";
    for (int index in indices) {
      indicesString += "$index, ";
    }
    _queueService.queueServiceLogger
        .finest("Shuffled indices before removing: $indicesString");
    final count = end - start;
    // Remove old indices.
    final oldIndices = List.generate(count, (i) => start + i).toSet();
    indices.removeWhere(oldIndices.contains);
    // Offset indices after deletion point.
    for (var i = 0; i < indices.length; i++) {
      if (indices[i] >= end) {
        indices[i] -= count;
      }
    }
    // log indices
    indicesString = "";
    for (int index in indices) {
      indicesString += "$index, ";
    }
    _queueService.queueServiceLogger
        .finest("Shuffled indices after removing: $indicesString");
  }

  @override
  void clear() {
    indices.clear();
  }
}
