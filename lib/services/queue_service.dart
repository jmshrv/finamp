import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';
import 'finamp_settings_helper.dart';
import 'downloads_helper.dart';
import 'music_player_background_task.dart';

/// A track queueing service for Finamp.
class QueueService {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _queueServiceLogger = Logger("QueueService");
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

  final _currentTrackStream = BehaviorSubject<FinampQueueItem?>.seeded(FinampQueueItem(
      item: const MediaItem(
          id: "",
          title: "No track playing",
          album: "No album",
          artist: "No artist"),
      source: QueueItemSource(
          id: "",
          name: const QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated),
          type: QueueItemSourceType.unknown)));
  final _queueStream = BehaviorSubject<FinampQueueInfo>.seeded(FinampQueueInfo(
    previousTracks: [],
    currentTrack: FinampQueueItem(
        item: const MediaItem(
            id: "",
            title: "No track playing",
            album: "No album",
            artist: "No artist"),
        source: QueueItemSource(
            id: "",
            name: const QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated),
            type: QueueItemSourceType.unknown)),
    queue: [],
    nextUp: [],
    source: QueueItemSource(
        id: "",
        name: const QueueItemSourceName(
            type: QueueItemSourceNameType.preTranslated),
        type: QueueItemSourceType.unknown),
  ));

  final _playbackOrderStream =
      BehaviorSubject<FinampPlaybackOrder>.seeded(FinampPlaybackOrder.linear);
  final _loopModeStream = BehaviorSubject<FinampLoopMode>.seeded(FinampLoopMode.none);

  // external queue state

  // the audio source used by the player. The first X items of all internal queues are merged together into this source, so that all player features, like gapless playback, are supported
  ConcatenatingAudioSource _queueAudioSource = ConcatenatingAudioSource(
    children: [],
  );
  late ShuffleOrder _shuffleOrder;
  int _queueAudioSourceIndex = 0;

  QueueService() {
    // _queueServiceLogger.level = Level.OFF;

    final finampSettings = FinampSettingsHelper.finampSettings;

    loopMode = finampSettings.loopMode;
    _queueServiceLogger.info("Restored loop mode to $loopMode from settings");

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
        int adjustedQueueIndex = (playbackOrder == FinampPlaybackOrder.shuffled &&
            _queueAudioSource.shuffleIndices.isNotEmpty)
          ? _queueAudioSource.shuffleIndices.indexOf(_queueAudioSourceIndex)
          : _queueAudioSourceIndex;
        _queueServiceLogger.finer(
            "Play queue index changed, new index: $adjustedQueueIndex (actual index: $_queueAudioSourceIndex)");
        _queueFromConcatenatingAudioSource();
      }
    });

    // register callbacks
    // _audioHandler.setQueueCallbacks(
    //   nextTrackCallback: _applyNextTrack,
    //   previousTrackCallback: _applyPreviousTrack,
    //   skipToIndexCallback: _applySkipToTrackByOffset,
    // );
  }

  void _queueFromConcatenatingAudioSource() {
    List<FinampQueueItem> allTracks = _audioHandler.effectiveSequence
            ?.map((e) => e.tag as FinampQueueItem)
            .toList() ??
        [];
    int adjustedQueueIndex = (playbackOrder == FinampPlaybackOrder.shuffled &&
            _queueAudioSource.shuffleIndices.isNotEmpty)
        ? _queueAudioSource.shuffleIndices.indexOf(_queueAudioSourceIndex)
        : _queueAudioSourceIndex;

    final previousTrack = _currentTrack;
    final previousTracksPreviousLength = _queuePreviousTracks.length;
    final nextUpPreviousLength = _queueNextUp.length;
    final queuePreviousLength = _queue.length;

    _queuePreviousTracks.clear();
    _queueNextUp.clear();
    _queue.clear();

    bool canHaveNextUp = true;

    // split the queue by old type
    for (int i = 0; i < allTracks.length; i++) {
      if (i < adjustedQueueIndex) {
        _queuePreviousTracks.add(allTracks[i]);
        if ([QueueItemSourceType.nextUp, QueueItemSourceType.nextUpAlbum, QueueItemSourceType.nextUpPlaylist, QueueItemSourceType.nextUpArtist].contains(_queuePreviousTracks.last.source.type)) {
          _queuePreviousTracks.last.source = QueueItemSource(
              type: QueueItemSourceType.formerNextUp,
              name: const QueueItemSourceName(
                  type: QueueItemSourceNameType.tracksFormerNextUp),
              id: "former-next-up");
        }
        _queuePreviousTracks.last.type = QueueItemQueueType.previousTracks;
      } else if (i == adjustedQueueIndex) {
        _currentTrack = allTracks[i];
        _currentTrack!.type = QueueItemQueueType.currentTrack;
      } else {
        if (allTracks[i].type == QueueItemQueueType.currentTrack && [QueueItemSourceType.nextUp, QueueItemSourceType.nextUpAlbum, QueueItemSourceType.nextUpPlaylist, QueueItemSourceType.nextUpArtist].contains(allTracks[i].source.type)) {
          _queue.add(allTracks[i]);
          _queue.last.type = QueueItemQueueType.queue;
          _queue.last.source = QueueItemSource(
            type: QueueItemSourceType.formerNextUp,
            name: const QueueItemSourceName(type: QueueItemSourceNameType.tracksFormerNextUp),
            id: "former-next-up"
          );
          canHaveNextUp = false;
        }
        else if (allTracks[i].type == QueueItemQueueType.nextUp) {
          if (canHaveNextUp) {
            _queueNextUp.add(allTracks[i]);
            _queueNextUp.last.type = QueueItemQueueType.nextUp;
          }
          else {
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
      return;
    }

    final newQueueInfo = getQueue();
    _queueStream.add(newQueueInfo);
    _currentTrackStream.add(_currentTrack);
    _audioHandler.mediaItem.add(_currentTrack?.item);
    _audioHandler.queue.add(_queuePreviousTracks
        .followedBy([_currentTrack!])
        .followedBy(_queue)
        .map((e) => e.item)
        .toList());

    // only log queue if there's a change
    if (
      previousTrack?.id != _currentTrack?.id ||
      previousTracksPreviousLength != _queuePreviousTracks.length ||
      nextUpPreviousLength != _queueNextUp.length ||
      queuePreviousLength != _queue.length
    ) {
      _logQueues(message: "(current)");
    }
  }

  Future<void> startPlayback({
    required List<jellyfin_models.BaseItemDto> items,
    required QueueItemSource source,
    FinampPlaybackOrder? order,
    int startingIndex = 0,
  }) async {
    // _initialQueue = list; // save original PlaybackList for looping/restarting and meta info

    if (order != null) {
      playbackOrder = order;
    }
    
    if (_playbackOrder == FinampPlaybackOrder.shuffled) {
      items.shuffle();
    }
    await _replaceWholeQueue(
        itemList: items, source: source, initialIndex: startingIndex);
    _queueServiceLogger
        .info("Started playing '${source.name}' (${source.type})");
  }

  /// Replaces the queue with the given list of items. If startAtIndex is specified, Any items below it
  /// will be ignored. This is used for when the user taps in the middle of an album to start from that point.
  Future<void> _replaceWholeQueue({
    required List<jellyfin_models.BaseItemDto> itemList,
    required QueueItemSource source,
    int initialIndex = 0,
  }) async {
    try {
      if (initialIndex > itemList.length) {
        return Future.error(
            "initialIndex is bigger than the itemList! ($initialIndex > ${itemList.length})");
      }

      _queue.clear(); // empty queue
      _queuePreviousTracks.clear();
      _queueNextUp.clear();
      _currentTrack = null;

      List<FinampQueueItem> newItems = [];
      List<int> newLinearOrder = [];
      List<int> newShuffledOrder;
      for (int i = 0; i < itemList.length; i++) {
        jellyfin_models.BaseItemDto item = itemList[i];
        try {
          MediaItem mediaItem = await _generateMediaItem(item, source.contextLufs);
          newItems.add(FinampQueueItem(
            item: mediaItem,
            source: source,
            type: i == 0
                ? QueueItemQueueType.currentTrack
                : QueueItemQueueType.queue,
          ));
          newLinearOrder.add(i);
        } catch (e) {
          _queueServiceLogger.severe(e);
        }
      }

      await _audioHandler.stop();
      _queueAudioSource.clear();

      List<AudioSource> audioSources = [];

      for (final queueItem in newItems) {
        audioSources.add(await _queueItemToAudioSource(queueItem));
      }

      await _queueAudioSource.addAll(audioSources);
      // _shuffleOrder
      //     .shuffle(); // shuffle without providing an index to make sure shuffle doesn't always start at the first index

      // set first item in queue
      _queueAudioSourceIndex = initialIndex;
      if (_playbackOrder == FinampPlaybackOrder.shuffled) {
        _queueAudioSourceIndex = _queueAudioSource.shuffleIndices[initialIndex];
      }
      _audioHandler.setNextInitialIndex(_queueAudioSourceIndex);
      await _audioHandler.initializeAudioSource(_queueAudioSource);

      newShuffledOrder = List.from(_queueAudioSource.shuffleIndices);

      _order = FinampQueueOrder(
        items: newItems,
        originalSource: source,
        linearOrder: newLinearOrder,
        shuffledOrder: newShuffledOrder,
      );

      _queueServiceLogger.fine("Order items length: ${_order.items.length}");

      // _queueStream.add(getQueue());
      _queueFromConcatenatingAudioSource();

      await _audioHandler.play();

      _audioHandler.nextInitialIndex = null;
    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> stopPlayback() async {
    queueServiceLogger.info("Stopping playback");

    await _audioHandler.stop();

    _queueAudioSource.clear();

    _queueFromConcatenatingAudioSource();

    return;
  }

  Future<void> addToQueue(
      jellyfin_models.BaseItemDto item, QueueItemSource source) async {
    try {
      FinampQueueItem queueItem = FinampQueueItem(
        item: await _generateMediaItem(item, source.contextLufs),
        source: source,
        type: QueueItemQueueType.queue,
      );

      await _queueAudioSource.add(await _queueItemToAudioSource(queueItem));

      _queueServiceLogger.fine(
          "Added '${queueItem.item.title}' to queue from '${source.name}' (${source.type})");

      _queueFromConcatenatingAudioSource(); // update internal queues
    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> addNext({
    required List<jellyfin_models.BaseItemDto> items,
    QueueItemSource? source,
  }) async {
    try {
      List<FinampQueueItem> queueItems = [];
      for (final item in items) {
        queueItems.add(FinampQueueItem(
          item: await _generateMediaItem(item, source?.contextLufs),
          source: source ??
              QueueItemSource(
                  id: "next-up",
                  name: const QueueItemSourceName(
                      type: QueueItemSourceNameType.nextUp),
                  type: QueueItemSourceType.nextUp),
          type: QueueItemQueueType.nextUp,
        ));
      }

      for (final queueItem in queueItems.reversed) {
        await _queueAudioSource.insert(_queueAudioSourceIndex + 1,
            await _queueItemToAudioSource(queueItem));
        _queueServiceLogger.fine(
            "Appended '${queueItem.item.title}' to Next Up (index ${_queueAudioSourceIndex + 1})");
      }

      _queueFromConcatenatingAudioSource(); // update internal queues
    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> addToNextUp({
    required List<jellyfin_models.BaseItemDto> items,
    QueueItemSource? source,
  }) async {
    try {
      List<FinampQueueItem> queueItems = [];
      for (final item in items) {
        queueItems.add(FinampQueueItem(
          item: await _generateMediaItem(item, source?.contextLufs),
          source: source ??
              QueueItemSource(
                  id: "next-up",
                  name: const QueueItemSourceName(
                      type: QueueItemSourceNameType.nextUp),
                  type: QueueItemSourceType.nextUp),
          type: QueueItemQueueType.nextUp,
        ));
      }

      _queueFromConcatenatingAudioSource(); // update internal queues
      int offset = _queueNextUp.length;

      for (final queueItem in queueItems) {
        await _queueAudioSource.insert(_queueAudioSourceIndex + 1 + offset,
            await _queueItemToAudioSource(queueItem));
        _queueServiceLogger.fine(
            "Appended '${queueItem.item.title}' to Next Up (index ${_queueAudioSourceIndex + 1 + offset})");
        offset++;
      }

      _queueFromConcatenatingAudioSource(); // update internal queues
    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> skipByOffset(int offset) async {
    await _audioHandler.skipByOffset(offset);
  }

  Future<void> removeAtOffset(int offset) async {
    final index = _playbackOrder == FinampPlaybackOrder.shuffled
        ? _queueAudioSource.shuffleIndices[
            _queueAudioSource.shuffleIndices.indexOf((_queueAudioSourceIndex)) +
                offset]
        : (_queueAudioSourceIndex) + offset;

    await _queueAudioSource.removeAt(index);
    // await _audioHandler.removeQueueItemAt(index);
    _queueFromConcatenatingAudioSource();
  }

  Future<void> reorderByOffset(int oldOffset, int newOffset) async {
    _queueServiceLogger.fine(
        "Reordering queue item at offset $oldOffset to offset $newOffset");

    //!!! the player will automatically change the shuffle indices of the ConcatenatingAudioSource if shuffle is enabled, so we need to use the regular track index here
    final oldIndex = _queueAudioSourceIndex + oldOffset;
    final newIndex = oldOffset < newOffset
        ? _queueAudioSourceIndex + newOffset - 1
        : _queueAudioSourceIndex + newOffset;

    await _queueAudioSource.move(oldIndex, newIndex);
    _queueFromConcatenatingAudioSource();
  }

  Future<void> clearNextUp() async {

    // remove all items from Next Up
    if (_queueNextUp.isNotEmpty) {
      await _queueAudioSource.removeRange(_queueAudioSourceIndex + 1,
          _queueAudioSourceIndex + 1 + _queueNextUp.length);
      _queueNextUp.clear();
    }

    _queueFromConcatenatingAudioSource(); // update internal queues
  }

  FinampQueueInfo getQueue() {
    return FinampQueueInfo(
      previousTracks: _queuePreviousTracks,
      currentTrack: _currentTrack,
      queue: _queue,
      nextUp: _queueNextUp,
      source: _order.originalSource,
    );
  }

  BehaviorSubject<FinampQueueInfo> getQueueStream() {
    return _queueStream;
  }

  void refreshQueueStream() {
    _queueStream.add(getQueue());
  }

  /// Returns the next [amount] QueueItems from Next Up and the regular queue.
  /// The length of the returned list may be less than [amount] if there are not enough items in the queue
  List<FinampQueueItem> getNextXTracksInQueue(int amount) {
    List<FinampQueueItem> nextTracks = [];
    if (_queueNextUp.isNotEmpty) {
      nextTracks
          .addAll(_queueNextUp.sublist(0, min(amount, _queueNextUp.length)));
      amount -= _queueNextUp.length;
    }
    if (_queue.isNotEmpty && amount > 0) {
      nextTracks.addAll(_queue.sublist(0, min(amount, _queue.length)));
    }
    return nextTracks;
  }

  BehaviorSubject<FinampPlaybackOrder> getPlaybackOrderStream() {
    return _playbackOrderStream;
  }

  BehaviorSubject<FinampLoopMode> getLoopModeStream() {
    return _loopModeStream;
  }

  BehaviorSubject<FinampQueueItem?> getCurrentTrackStream() {
    return _currentTrackStream;
  }

  FinampQueueItem? getCurrentTrack() {
    return _currentTrack;
  }

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
    _queueServiceLogger.fine("Loop mode set to ${FinampSettingsHelper.finampSettings.loopMode}");
    
  }

  FinampLoopMode get loopMode => _loopMode;

  set playbackOrder(FinampPlaybackOrder order) {
    _playbackOrder = order;
    _queueServiceLogger.fine("Playback order set to $order");

    _playbackOrderStream.add(order);

    // update queue accordingly and generate new shuffled order if necessary
    if (_playbackOrder == FinampPlaybackOrder.shuffled) {
      _audioHandler
          .setShuffleMode(AudioServiceShuffleMode.all)
          .then((value) => _queueFromConcatenatingAudioSource());
    } else {
      _audioHandler
          .setShuffleMode(AudioServiceShuffleMode.none)
          .then((value) => _queueFromConcatenatingAudioSource());
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

  /// [contextLufs] is the LUFS of the context that the song is being played in, e.g. the album
  /// Should only be used when the tracks within that context come from the same source, e.g. the same album (or maybe artist?). Usually makes no sense for playlists.
  Future<MediaItem> _generateMediaItem(jellyfin_models.BaseItemDto item, double? contextLufs) async {
    const uuid = Uuid();

    final downloadedSong = _downloadsHelper.getDownloadedSong(item.id);
    final isDownloaded = downloadedSong == null
        ? false
        : await _downloadsHelper.verifyDownloadedSong(downloadedSong);

    return MediaItem(
      id: uuid.v4(),
      album: item.album ?? "unknown",
      artist: item.artists?.join(", ") ?? item.albumArtist,
      artUri: _downloadsHelper.getDownloadedImage(item)?.file.uri ??
          _jellyfinApiHelper.getImageUrl(item: item),
      title: item.name ?? "unknown",
      extras: {
        "itemJson": item.toJson(),
        "shouldTranscode": FinampSettingsHelper.finampSettings.shouldTranscode,
        "downloadedSongJson": isDownloaded
            ? (_downloadsHelper.getDownloadedSong(item.id))!.toJson()
            : null,
        "isOffline": FinampSettingsHelper.finampSettings.isOffline,
        "contextLufs": contextLufs,
      },
      // Jellyfin returns microseconds * 10 for some reason
      duration: Duration(
        microseconds:
            (item.runTimeTicks == null ? 0 : item.runTimeTicks! ~/ 10),
      ),
    );
  }

  /// Syncs the list of MediaItems (_queue) with the internal queue of the player.
  /// Called by onAddQueueItem and onUpdateQueue.
  Future<AudioSource> _queueItemToAudioSource(FinampQueueItem queueItem) async {
    if (queueItem.item.extras!["downloadedSongJson"] == null) {
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
      final downloadedSong =
          DownloadedSong.fromJson(queueItem.item.extras!["downloadedSongJson"]);

      // Path verification and stuff is done in AudioServiceHelper, so this path
      // should be valid.
      final downloadUri = Uri.file(downloadedSong.file.path);
      return AudioSource.uri(downloadUri, tag: queueItem);
    }
  }

  Future<Uri> _songUri(MediaItem mediaItem) async {
    // We need the platform to be Android or iOS to get device info
    assert(Platform.isAndroid || Platform.isIOS,
        "_songUri() only supports Android and iOS");

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
  final QueueService? _queueService;
  @override
  List<int> indices = <int>[];

  NextUpShuffleOrder({Random? random, QueueService? queueService})
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
    _queueService!._queueFromConcatenatingAudioSource();
    FinampQueueInfo queueInfo = _queueService!.getQueue();
    indices = List.generate(
        queueInfo.previousTracks.length +
            1 +
            queueInfo.nextUp.length +
            queueInfo.queue.length,
        (i) => i);
    if (indices.length <= 1) return;
    indices.shuffle(_random);

    _queueService!.queueServiceLogger.finest("initialIndex: $initialIndex");

    // log indices
    String indicesString = "";
    for (int index in indices) {
      indicesString += "$index, ";
    }
    _queueService!.queueServiceLogger
        .finest("Shuffled indices: $indicesString");
    _queueService!.queueServiceLogger
        .finest("Current Track: ${queueInfo.currentTrack}");

    int nextUpLength = 0;
    if (_queueService != null) {
      nextUpLength = queueInfo.nextUp.length;
    }

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
    _queueService!.queueServiceLogger
        .finest("Shuffled indices (swapped): $indicesString");
  }

  /// `index` is the linear index of the item in the ConcatenatingAudioSource
  @override
  void insert(int index, int count) {
    int insertionPoint = index;
    int linearIndexOfPreviousItem = index - 1;

    // _queueService!._queueFromConcatenatingAudioSource();
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
      _queueService!.queueServiceLogger.finest(
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
  }

  @override
  void clear() {
    indices.clear();
  }
}
