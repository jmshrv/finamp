import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';
import 'finamp_settings_helper.dart';
import 'downloads_helper.dart';
import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart' as jellyfin_models;
import 'music_player_background_task.dart';

enum PlaybackOrder { shuffled, linear }
enum LoopMode { none, one, all }

/// A track queueing service for Finamp.
class QueueService {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _queueServiceLogger = Logger("QueueService");

  // internal state

  List<QueueItem> _queuePreviousTracks = []; // contains **all** items that have been played, including "next up"
  QueueItem? _currentTrack; // the currently playing track
  List<QueueItem> _queueNextUp = []; // a temporary queue that gets appended to if the user taps "next up"
  List<QueueItem> _queue = []; // contains all regular queue items
  QueueOrder _order = QueueOrder(items: [], linearOrder: [], shuffledOrder: []); // contains all items that were at some point added to the regular queue, as well as their order when shuffle is enabled and disabled. This is used to loop the original queue once the end has been reached and "loop all" is enabled, **excluding** "next up" items and keeping the playback order.

  PlaybackOrder _playbackOrder = PlaybackOrder.linear;
  LoopMode _loopMode = LoopMode.none;

  final _currentTrackStream = BehaviorSubject<QueueItem>.seeded(
    QueueItem(item: MediaItem(id: "", title: "No track playing", album: "No album", artist: "No artist"), source: QueueItemSource(id: "", name: "", type: QueueItemSourceType.unknown))
  ); 
  final _queueStream = BehaviorSubject<QueueInfo>.seeded(QueueInfo(
    previousTracks: [],
    currentTrack: QueueItem(item: MediaItem(id: "", title: "No track playing", album: "No album", artist: "No artist"), source: QueueItemSource(id: "", name: "", type: QueueItemSourceType.unknown)),
    queue: [],
    nextUp: [],
  )); 

  // external queue state

  // the audio source used by the player. The first X items of all internal queues are merged together into this source, so that all player features, like gapless playback, are supported
  ConcatenatingAudioSource _queueAudioSource = ConcatenatingAudioSource(
    children: [],
    useLazyPreparation: true,
  );
  int _queueAudioSourceIndex = 0;

  QueueService() {

    _queueAudioSource = ConcatenatingAudioSource(
      children: [],
      useLazyPreparation: true,
      shuffleOrder: NextUpShuffleOrder(queueService: this),
    );

    _audioHandler.getPlaybackEventStream().listen((event) async {

      // int indexDifference = (event.currentIndex ?? 0) - _queueAudioSourceIndex;

      // _queueServiceLogger.finer("Play queue index changed, difference: $indexDifference");

      _queueAudioSourceIndex = event.currentIndex ?? 0;
      _queueServiceLogger.finer("Play queue index changed, new index: $_queueAudioSourceIndex");

      _queueFromConcatenatingAudioSource(); 

    });

    // register callbacks
    // _audioHandler.setQueueCallbacks(
    //   nextTrackCallback: _applyNextTrack,
    //   previousTrackCallback: _applyPreviousTrack,
    //   skipToIndexCallback: _applySkipToTrackByOffset,
    // );
    
  }

  void _queueFromConcatenatingAudioSource() {

    //TODO handle shuffleIndices
    List<QueueItem> allTracks = _audioHandler.effectiveSequence?.map((e) => e.tag as QueueItem).toList() ?? [];
    int adjustedQueueIndex = (playbackOrder == PlaybackOrder.shuffled && _queueAudioSource.shuffleIndices.isNotEmpty) ? _queueAudioSource.shuffleIndices.indexOf(_queueAudioSourceIndex) : _queueAudioSourceIndex;

    _queuePreviousTracks.clear();
    _queueNextUp.clear();
    _queue.clear();

    // split the queue by old type
    for (int i = 0; i < allTracks.length; i++) {

      if (i < adjustedQueueIndex) {
        _queuePreviousTracks.add(allTracks[i]);
        if (_queuePreviousTracks.last.type == QueueItemQueueType.nextUp) {
          _queuePreviousTracks.last.source.type = QueueItemSourceType.formerNextUp;
        }
        _queuePreviousTracks.last.type = QueueItemQueueType.previousTracks;
      } else if (i == adjustedQueueIndex) {
        _currentTrack = allTracks[i];
        _currentTrack!.type = QueueItemQueueType.currentTrack;
      } else {
        if (allTracks[i].type == QueueItemQueueType.nextUp) {
          _queueNextUp.add(allTracks[i]);
        } else {
          _queue.add(allTracks[i]);
          _queue.last.type = QueueItemQueueType.queue;
        }
      }

    }

    _queueStream.add(getQueue());
    if (_currentTrack != null) {
      _currentTrackStream.add(_currentTrack!);
      _audioHandler.mediaItem.add(_currentTrack!.item);
      _audioHandler.queue.add(_queuePreviousTracks.followedBy([_currentTrack!]).followedBy(_queue).map((e) => e.item).toList());
    }

    _logQueues(message: "(current)");

  }

  Future<void> startPlayback({
    required List<jellyfin_models.BaseItemDto> items,
    required QueueItemSource source
  }) async {

    // _initialQueue = list; // save original PlaybackList for looping/restarting and meta info
    _replaceWholeQueue(itemList: items, source: source);
    _queueServiceLogger.info("Started playing '${source.name}' (${source.type})");
    
  }

  /// Replaces the queue with the given list of items. If startAtIndex is specified, Any items below it
  /// will be ignored. This is used for when the user taps in the middle of an album to start from that point.
  Future<void> _replaceWholeQueue({
    required List<jellyfin_models.BaseItemDto>
        itemList, //TODO create a custom type for item lists that can also hold the name of the list, etc.
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

      List<QueueItem> newItems = [];
      List<int> newLinearOrder = [];
      List<int> newShuffledOrder;
      for (int i = 0; i < itemList.length; i++) {
        jellyfin_models.BaseItemDto item = itemList[i];
        try {
          MediaItem mediaItem = await _generateMediaItem(item);
          newItems.add(QueueItem(
            item: mediaItem,
            source: source,
            type: i == 0 ? QueueItemQueueType.currentTrack : QueueItemQueueType.queue,
          ));
          newLinearOrder.add(i);
        } catch (e) {
          _queueServiceLogger.severe(e);
        }
      }

      newShuffledOrder = List.from(newLinearOrder)..shuffle();

      _order = QueueOrder(
        items: newItems,
        linearOrder: newLinearOrder,
        shuffledOrder: newShuffledOrder,
      );

      _queueServiceLogger.fine("Order items length: ${_order.items.length}");


      // start playing first item in queue
      _queueAudioSourceIndex = 0;
      _audioHandler.setNextInitialIndex(_queueAudioSourceIndex);

      _queueAudioSource.clear();

      for (final queueItem in newItems) {
        await _queueAudioSource.add(await _queueItemToAudioSource(queueItem));
      }

      await _audioHandler.initializeAudioSource(_queueAudioSource);

      _audioHandler.queue.add(_queue.map((e) => e.item).toList());

      // _queueStream.add(getQueue());

      _audioHandler.play();

      _audioHandler.nextInitialIndex = null;
      
    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> addToQueue(jellyfin_models.BaseItemDto item, QueueItemSource source) async {
    try {
      QueueItem queueItem = QueueItem(
        item: await _generateMediaItem(item),
        source: source,
        type: QueueItemQueueType.queue,
      );

      // _order.items.add(queueItem);
      // _order.linearOrder.add(_order.items.length - 1);
      // _order.shuffledOrder.add(_order.items.length - 1); //TODO maybe the item should be shuffled into the queue instead of placed at the end? depends on user preference

      _queueAudioSource.add(await _queueItemToAudioSource(queueItem));

      _queueServiceLogger.fine("Added '${queueItem.item.title}' to queue from '${source.name}' (${source.type})");

    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> addNext(jellyfin_models.BaseItemDto item) async {
    try {
      QueueItem queueItem = QueueItem(
        item: await _generateMediaItem(item),
        source: QueueItemSource(id: "up-next", name: "Up Next", type: QueueItemSourceType.nextUp),
        type: QueueItemQueueType.nextUp,
      );

      // don't add to _order, because it wasn't added to the regular queue
      _queueAudioSource.insert(_queueAudioSourceIndex+1, await _queueItemToAudioSource(queueItem));

      _queueServiceLogger.fine("Prepended '${queueItem.item.title}' to Next Up");

    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }   
  }

  Future<void> addToNextUp(jellyfin_models.BaseItemDto item) async {
    try {
      QueueItem queueItem = QueueItem(
        item: await _generateMediaItem(item),
        source: QueueItemSource(id: "up-next", name: "Up Next", type: QueueItemSourceType.nextUp),
        type: QueueItemQueueType.nextUp,
      );

      // don't add to _order, because it wasn't added to the regular queue

      _queueFromConcatenatingAudioSource(); // update internal queues
      int offset = _queueNextUp.length;

      _queueAudioSource.insert(_queueAudioSourceIndex+1+offset, await _queueItemToAudioSource(queueItem));

      _queueServiceLogger.fine("Appended '${queueItem.item.title}' to Next Up");

    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  QueueInfo getQueue() {

    return QueueInfo(
      previousTracks: _queuePreviousTracks,
      currentTrack: _currentTrack ?? QueueItem(item: const MediaItem(id: "", title: "No track playing", album: "No album", artist: "No artist"), source: QueueItemSource(id: "", name: "", type: QueueItemSourceType.unknown)),
      queue: _queue,
      // nextUp: _queueNextUp,
      nextUp: [
        QueueItem(item: MediaItem(id: "", title: "No track playing", album: "No album", artist: "No artist"), source: QueueItemSource(id: "", name: "", type: QueueItemSourceType.unknown)),
      ],
    );
    
  }

  BehaviorSubject<QueueInfo> getQueueStream() {
    return _queueStream;
  }

  BehaviorSubject<QueueItem> getCurrentTrackStream() {
    return _currentTrackStream;
  }

  QueueItem getCurrentTrack() {
    return _currentTrack!;
  }

  set loopMode(LoopMode mode) {
    _loopMode = mode;
    _currentTrackStream.add(_currentTrack ?? QueueItem(item: const MediaItem(id: "", title: "No track playing", album: "No album", artist: "No artist"), source: QueueItemSource(id: "", name: "", type: QueueItemSourceType.unknown)));

    if (mode == LoopMode.one) {
      _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
    } else if (mode == LoopMode.all) {
      _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
    } else {
      _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    }

  }

  LoopMode get loopMode => _loopMode;

  set playbackOrder(PlaybackOrder order) {
    _playbackOrder = order;
    // _currentTrackStream.add(_currentTrack ?? QueueItem(item: MediaItem(id: "", title: "No track playing", album: "No album", artist: "No artist"), source: QueueItemSource(id: "", name: "", type: QueueItemType.unknown)));

    // update queue accordingly and generate new shuffled order if necessary
    if (_playbackOrder == PlaybackOrder.shuffled) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all).then((value) => _queueFromConcatenatingAudioSource());
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none).then((value) => _queueFromConcatenatingAudioSource());
    }

  }

  PlaybackOrder get playbackOrder => _playbackOrder;

  Logger get queueServiceLogger => _queueServiceLogger;

  void _logQueues({ String message = "" }) {

    // generate string for `_queue`
    String queueString = "";
    for (QueueItem queueItem in _queuePreviousTracks) {
      queueString += "${queueItem.item.title}, ";
    }
    queueString += "[${_currentTrack?.item.title}], ";
    for (QueueItem queueItem in _queue) {
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
      "Queue $message [${_queuePreviousTracks.length}-1-${_queue.length}]: $queueString"
    );
    // _queueServiceLogger.finer(
    //   "Audio Source Queue $message [${_queue.length}]: $queueAudioSourceString"
    // )
    
  }

  Future<MediaItem> _generateMediaItem(jellyfin_models.BaseItemDto item) async {
    const uuid = Uuid();

    final downloadedSong = _downloadsHelper.getDownloadedSong(item.id);
    final isDownloaded = downloadedSong == null
        ? false
        : await _downloadsHelper.verifyDownloadedSong(downloadedSong);

    return MediaItem(
      id: uuid.v4(),
      album: item.album ?? "Unknown Album",
      artist: item.artists?.join(", ") ?? item.albumArtist,
      artUri: _downloadsHelper.getDownloadedImage(item)?.file.uri ??
          _jellyfinApiHelper.getImageUrl(item: item),
      title: item.name ?? "Unknown Name",
      extras: {
        // "parentId": item.parentId,
        // "itemId": item.id,
        "itemJson": item.toJson(),
        "shouldTranscode": FinampSettingsHelper.finampSettings.shouldTranscode,
        "downloadedSongJson": isDownloaded
            ? (_downloadsHelper.getDownloadedSong(item.id))!.toJson()
            : null,
        "isOffline": FinampSettingsHelper.finampSettings.isOffline,
        // TODO: Maybe add transcoding bitrate here?
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
  Future<AudioSource> _queueItemToAudioSource(QueueItem queueItem) async {
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
          return AudioSource.uri(await _songUri(queueItem.item), tag: queueItem);
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

  NextUpShuffleOrder({Random? random, QueueService? queueService}) : _random = random ?? Random(), _queueService = queueService;

  @override
  void shuffle({int? initialIndex}) {
    assert(initialIndex == null || indices.contains(initialIndex));
    indices.clear();
    QueueInfo queueInfo = _queueService!.getQueue();
    indices = List.generate(queueInfo.previousTracks.length + queueInfo.nextUp.length + queueInfo.queue.length, (i) => i);
    if (indices.length <= 1) return;
    indices.shuffle(_random);
    if (initialIndex == null) return;

    _queueService!.queueServiceLogger.finer("initialIndex: $initialIndex");

    // log indices
    String indicesString = "";
    for (int index in indices) {
      indicesString += "$index, ";
    }
    _queueService!.queueServiceLogger.finer("Shuffled indices: $indicesString");

    int nextUpLength = 0;
    if (_queueService != null) {
      QueueInfo queueInfo = _queueService!.getQueue();
      nextUpLength = queueInfo.nextUp.length;
    }

    const initialPos = 0;
    final swapPos = indices.indexOf(initialIndex);
    // Swap the indices at initialPos and swapPos.
    final swapIndex = indices[initialPos];
    indices[initialPos] = initialIndex;
    indices[swapPos] = swapIndex;

    // swap all Next Up items to the front
    for (int i = 1; i <= nextUpLength; i++) {
      final swapPos = indices.indexOf(initialIndex + i);
      final swapIndex = indices[initialPos + i];
      indices[initialPos + i] = initialIndex + i;
      indices[swapPos] = swapIndex;
    }

    // log indices
    indicesString = "";
    for (int index in indices) {
      indicesString += "$index, ";
    }
    _queueService!.queueServiceLogger.finer("Shuffled indices (swapped): $indicesString");


  }

  @override
  void insert(int index, int count) {
    // Offset indices after insertion point.
    for (var i = 0; i < count; i++) {
      indices.add(indices.length);
    }
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
