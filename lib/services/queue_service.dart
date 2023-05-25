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

      int indexDifference = (event.currentIndex ?? 0) - _queueAudioSourceIndex;

      _queueServiceLogger.finer("Play queue index changed, difference: $indexDifference");

      _queueAudioSourceIndex = event.currentIndex ?? 0;

      _queueFromConcatenatingAudioSource(indexDifference); 

    });

    // register callbacks
    // _audioHandler.setQueueCallbacks(
    //   nextTrackCallback: _applyNextTrack,
    //   previousTrackCallback: _applyPreviousTrack,
    //   skipToIndexCallback: _applySkipToTrackByOffset,
    // );
    
  }

  void _queueFromConcatenatingAudioSource(int indexDifference) {

    //TODO handle shuffleIndices
    List<QueueItem> allTracks = _queueAudioSource.sequence.map((e) => e.tag as QueueItem).toList();

    _queuePreviousTracks.clear();
    _queueNextUp.clear();
    _queue.clear();

    // split the queue by old type
    for (int i = 0; i < allTracks.length; i++) {
      switch (allTracks[i].type) {
        case QueueItemQueueType.previousTracks:
          _queuePreviousTracks.add(allTracks[i]);
          break;
        case QueueItemQueueType.currentTrack:
          _currentTrack = allTracks[i];
          break;
        case QueueItemQueueType.nextUp:
          _queueNextUp.add(allTracks[i]);
          break;
        default:
          // queue
          _queue.add(allTracks[i]);
      }
    }

    // update types
    if (indexDifference > 0) {

      _currentTrack?.type = QueueItemQueueType.previousTracks;
      for (int i = 0; i < indexDifference-1; i++) {
        _queue[i].type = QueueItemQueueType.previousTracks;
      }
      _queue[indexDifference-1].type = QueueItemQueueType.currentTrack;

      _currentTrack = _queue[indexDifference-1];
      _queuePreviousTracks.addAll(_queue.sublist(0, indexDifference));
      _queue.removeRange(0, indexDifference);

    } else if (indexDifference < 0) {

      _currentTrack?.type = QueueItemQueueType.queue;
      for (int i = _queuePreviousTracks.length-1; i > _queuePreviousTracks.length+indexDifference; i--) {
        _queuePreviousTracks[i].type = QueueItemQueueType.queue;
      }
      _queue[_queue.length + indexDifference].type = QueueItemQueueType.currentTrack;

      _currentTrack = _queue[_queue.length + indexDifference];
      _queue.insertAll(0, _queuePreviousTracks.sublist(_queuePreviousTracks.length + indexDifference));
      _queuePreviousTracks.removeRange(_queuePreviousTracks.length + indexDifference, _queuePreviousTracks.length);
    }

    _queueStream.add(getQueue());
    if (_currentTrack != null) {
      _currentTrackStream.add(_currentTrack!);
      _audioHandler.mediaItem.add(_currentTrack!.item);
      _audioHandler.queue.add(_queuePreviousTracks.followedBy([_currentTrack!]).followedBy(_queue).map((e) => e.item).toList());
    }

    _logQueues(message: "(current)");

  }

  Future<bool> _applyNextTrack({bool eventFromPlayer = false}) async {
    //TODO handle "Next Up" queue

    // update internal queues

    bool addCurrentTrackToPreviousTracks = true;

    _queueServiceLogger.finer("Loop mode: $loopMode");

    if (loopMode == LoopMode.one) {
      _audioHandler.seek(Duration.zero);
      _queueServiceLogger.finer("Looping current track: '${_currentTrack!.item.title}'");

      //TODO update playback history

      if (eventFromPlayer) {
        return false; // player already skipped
      }

      return false; // perform the skip
    } if (
      (_queue.length + _queueNextUp.length == 0)
      && loopMode == LoopMode.all
    ) {

      await _applyLoopQueue();
      addCurrentTrackToPreviousTracks = false;
      // _queueAudioSourceIndex = -1; // so that incrementing the index below will set it to 0

    } else if (_queue.isEmpty && loopMode == LoopMode.none) {
      _queueServiceLogger.info("Cannot skip ahead, no tracks in queue");
      //TODO show snackbar
      return false;
    }
    
    await pushQueueToExternalQueues();
    if (addCurrentTrackToPreviousTracks) {
      _queuePreviousTracks.add(_currentTrack!);
    }
    
    _currentTrack = _queue.removeAt(0);
    _currentTrackStream.add(_currentTrack!);

    _logQueues(message: "after skipping forward");

    _queueStream.add(getQueue());

    // _queueAudioSourceIndex++; // increment external queue index so we can detect that the change has already been handled once

    return true;
    
  }

  Future<bool> _applyPreviousTrack({bool eventFromPlayer = false}) async {
    //TODO handle "Next Up" queue

    bool addCurrentTrackToQueue = true;

    // update internal queues

    if (loopMode == LoopMode.one) {

      _audioHandler.seek(Duration.zero);
      _queueServiceLogger.finer("Looping current track: '${_currentTrack!.item.title}'");
      //TODO update playback history

      if (eventFromPlayer) {
        return false; // player already skipped
      }

      return false; // perform the skip
    }

    if (_queuePreviousTracks.isEmpty) {

      if (loopMode == LoopMode.all) {

        await _applyLoopQueue(skippingBackwards: true);
        addCurrentTrackToQueue = false;
        
      } else {
        _queueServiceLogger.info("Cannot skip back, no previous tracks in queue");
        _audioHandler.seek(Duration.zero);
        return false;
      }
    }

    if (_audioHandler.getPlayPositionInSeconds() > 5) {
      _audioHandler.seek(Duration.zero);
      return false;
    }
    
    await pushQueueToExternalQueues();
    if (addCurrentTrackToQueue) {
      _queue.insert(0, _currentTrack!);
    }
    
    _currentTrack = _queuePreviousTracks.removeLast();
    _currentTrackStream.add(_currentTrack!);

    // _queueAudioSourceIndex--; // increment external queue index so we can detect that the change has already been handled once

    _logQueues(message: "after skipping backwards");

    _queueStream.add(getQueue());

    // await pushQueueToExternalQueues();

    return true;
    
  }

  Future<bool> _applySkipToTrackByOffset(int offset, {
    bool updateExternalQueues = true,
  }) async {

    //TODO handle "Next Up" queue


    bool addCurrentTrackToPreviousTracks = true;

    _logQueues(message: "before skipping by offset $offset");

    if (offset == 0) {
      return false;
    } else if (
      (offset > 0 && _queue.length < offset) ||
      (offset < 0 && _queuePreviousTracks.length < offset)
    ) {
      _queueServiceLogger.info("Cannot skip to offset $offset, not enough tracks in queue");
      //TODO show snackbar
      return false;
    }
    
    if (addCurrentTrackToPreviousTracks) {
      _queuePreviousTracks.add(_currentTrack!);
    }

    if (offset > 0) {
      _queuePreviousTracks.addAll(_queue.sublist(0, offset-1));
      _queue.removeRange(0, offset-1);

      _currentTrack = _queue.removeAt(0);
      _currentTrackStream.add(_currentTrack!);
    } else {
      _queue.insertAll(0, _queuePreviousTracks.sublist(_queuePreviousTracks.length + offset, _queuePreviousTracks.length));
      _queuePreviousTracks.removeRange(_queuePreviousTracks.length + offset, _queuePreviousTracks.length);

      _currentTrack = _queuePreviousTracks.removeLast();
      _currentTrackStream.add(_currentTrack!);
    }

    _logQueues(message: "after skipping by offset $offset");

    if (updateExternalQueues) {
      await pushQueueToExternalQueues();
    }

    _queueAudioSourceIndex = _queueAudioSourceIndex + offset;

    return true;
    
  }

  // Future<void> nextTrack() async {
  //   //TODO make _audioHandler._player call this function instead of skipping ahead itself

  //   if (await _applyNextTrack()) {

  //     // update external queues
  //     _audioHandler.skipToNext();
  //     _queueAudioSourceIndex++;

  //     _queueServiceLogger.info("Skipped ahead to next track: '${_currentTrack!.item.title}'");

  //   }
    
  // }

  // Future<void> previousTrack() async {
  //   //TODO handle "Next Up" queue
  //   // update internal queues

  //   if (_audioHandler.getPlayPositionInSeconds() > 5 || _queuePreviousTracks.isEmpty) {
  //     _audioHandler.seek(const Duration(seconds: 0));
  //     return;
  //   }

  //   if (await _applyPreviousTrack()) {

  //     // update external queues
  //     _audioHandler.skipToPrevious();
  //     _queueAudioSourceIndex--;

  //     _queueServiceLogger.info("Skipped back to previous track: '${_currentTrack!.item.title}'");

  //   }

  // }

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

      _queueAudioSource = ConcatenatingAudioSource(children: []);

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

      // if (_loopMode == LoopMode.all && _queue.length == 0) {
      //   await pushQueueToExternalQueues();
      // }
      
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

      _queueFromConcatenatingAudioSource(0); // update internal queues
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
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
    _queueFromConcatenatingAudioSource(0); // update queue

  }

  PlaybackOrder get playbackOrder => _playbackOrder;

  Future<void> _applyLoopQueue({
    skippingBackwards = false,
  }) async {

    _queueServiceLogger.fine("Looping queue for ${skippingBackwards ? "skipping backwards" : "skipping forward"} using `_order`");

    // log current queue
    _logQueues(message: "before looping");

    if (skippingBackwards) {

      // add items to previous tracks
      for (int itemIndex in (_playbackOrder == PlaybackOrder.linear ? _order.linearOrder : _order.shuffledOrder)) {
        _queuePreviousTracks.add(_order.items[itemIndex]);
      }

      _queue.clear();
      
    } else {

      // add items to queue
      for (int itemIndex in (_playbackOrder == PlaybackOrder.linear ? _order.linearOrder : _order.shuffledOrder)) {
        _queue.add(_order.items[itemIndex]);
      }

      _queuePreviousTracks.clear();
      
    }

    // log looped queue
    _logQueues(message: "after looping");
    
    // update external queues
    // await pushQueueToExternalQueues();
    
    _queueServiceLogger.info("Looped queue, added ${_order.items.length} items");

  }

  Future<void> _applyUpdatePlaybackOrder() async {

    _logQueues(message: "before playback order change to ${_playbackOrder.name}");

    // find current track in `_order`
    int currentTrackIndex = _currentTrack != null ? _order.items.indexOf(_currentTrack!) : 0;
    int currentTrackOrderIndex = 0;


    List<int> itemsBeforeCurrentTrack = [];
    List<int> itemsAfterCurrentTrack = [];

    if (_playbackOrder == PlaybackOrder.shuffled) {

      // calculate new shuffled order where the currentTrack has index 0
      _order.shuffledOrder = List.from(_order.linearOrder)..shuffle();

      currentTrackOrderIndex = _order.shuffledOrder.indexWhere((trackIndex) => trackIndex == currentTrackIndex);

      String shuffleOrderString = "";
      for (int index in _order.shuffledOrder) {
        shuffleOrderString += "$index, ";
      }
      _queueServiceLogger.finer("unmodified new shuffle order: $shuffleOrderString");

      // swap the current track to index 0
      int indexOfCurrentFirstTrackInShuffleOrder = _order.shuffledOrder[0];
      _order.shuffledOrder[0] = currentTrackIndex;
      _order.shuffledOrder[currentTrackOrderIndex] = indexOfCurrentFirstTrackInShuffleOrder;
      
      _queueServiceLogger.finer("indexOfCurrentFirstTrackInShuffleOrder: ${indexOfCurrentFirstTrackInShuffleOrder}");
      _queueServiceLogger.finer("current track first in shuffled order: ${currentTrackIndex == _order.shuffledOrder[0]}");

      String swappedShuffleOrderString = "";
      for (int index in _order.shuffledOrder) {
        swappedShuffleOrderString += "$index, ";
      }
      _queueServiceLogger.finer("swapped new shuffle order: $swappedShuffleOrderString");

      // use indices of current playback order to get the items after the current track
      // first item is always the current track, so skip it
      itemsAfterCurrentTrack = _order.shuffledOrder.sublist(1);
      String sublistString = "";
      for (int index in itemsAfterCurrentTrack) {
        sublistString += "$index, ";
      }
      _queueServiceLogger.finer("item indices after current track: $sublistString");
      
    } else {

      currentTrackOrderIndex = _order.linearOrder.indexWhere((trackIndex) => trackIndex == currentTrackIndex);

      // set the queue to the items after the current track and previousTracks to items before the current track
      // use indices of current playback order to get the items before the current track
      itemsBeforeCurrentTrack = _order.linearOrder.sublist(0, currentTrackOrderIndex);

      // use indices of current playback order to get the items after the current track
      itemsAfterCurrentTrack = _order.linearOrder.sublist(currentTrackOrderIndex+1);
      
    }

    // add items to previous tracks
    _queuePreviousTracks.clear();
    for (int itemIndex in itemsBeforeCurrentTrack) {
      // if (itemIndex != currentTrackIndex) {
        _queuePreviousTracks.add(_order.items[itemIndex]);
      // }
    }
    // add items to queue
    _queue.clear();
    for (int itemIndex in itemsAfterCurrentTrack) {
      // if (itemIndex != currentTrackIndex) {
        _queue.add(_order.items[itemIndex]);
      // }
    }

    _logQueues(message: "after playback order change to ${_playbackOrder.name}");

    await pushQueueToExternalQueues();

  }

  Future<void> pushQueueToExternalQueues() async {

    _audioHandler.queue.add(_queuePreviousTracks.followedBy([_currentTrack!]).followedBy(_queue).map((e) => e.item).toList());
    _currentTrackStream.add(_currentTrack!);
    _queueStream.add(getQueue());

    if (_queueAudioSource.length > 1) {
      // clear queue after the current track
      // do this first so that the current track index stays the same
      _queueAudioSource.removeRange(_queueAudioSourceIndex+1, _queueAudioSource.length);
      // clear queue before the current track
      _queueAudioSource.removeRange(0, _queueAudioSourceIndex);
    }

    // add items to queue
    List<AudioSource> previousAudioSources = [];
    for (QueueItem queueItem in _queuePreviousTracks.toList()) {
      previousAudioSources.add(await _mediaItemToAudioSource(queueItem.item));
    }
    await _queueAudioSource.insertAll(0, previousAudioSources);

    // add items to queue
    List<AudioSource> nextAudioSources = [];
    for (QueueItem queueItem in _queue) {
      nextAudioSources.add(await _mediaItemToAudioSource(queueItem.item));
    }
    await _queueAudioSource.addAll(nextAudioSources);

  }

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
  
  /// Syncs the list of MediaItems (_queue) with the internal queue of the player.
  /// Called by onAddQueueItem and onUpdateQueue.
  Future<AudioSource> _mediaItemToAudioSource(MediaItem mediaItem) async {
    if (mediaItem.extras!["downloadedSongJson"] == null) {
      // If DownloadedSong wasn't passed, we assume that the item is not
      // downloaded.

      // If offline, we throw an error so that we don't accidentally stream from
      // the internet. See the big comment in _songUri() to see why this was
      // passed in extras.
      if (mediaItem.extras!["isOffline"]) {
        return Future.error(
            "Offline mode enabled but downloaded song not found.");
      } else {
        if (mediaItem.extras!["shouldTranscode"] == true) {
          return HlsAudioSource(await _songUri(mediaItem), tag: mediaItem);
        } else {
          return AudioSource.uri(await _songUri(mediaItem), tag: mediaItem);
        }
      }
    } else {
      // We have to deserialise this because Dart is stupid and can't handle
      // sending classes through isolates.
      final downloadedSong =
          DownloadedSong.fromJson(mediaItem.extras!["downloadedSongJson"]);

      // Path verification and stuff is done in AudioServiceHelper, so this path
      // should be valid.
      final downloadUri = Uri.file(downloadedSong.file.path);
      return AudioSource.uri(downloadUri, tag: mediaItem);
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
  final indices = <int>[];

  NextUpShuffleOrder({Random? random, QueueService? queueService}) : _random = random ?? Random(), _queueService = queueService;

  @override
  void shuffle({int? initialIndex}) {
    assert(initialIndex == null || indices.contains(initialIndex));
    if (indices.length <= 1) return;
    indices.shuffle(_random);
    if (initialIndex == null) return;

    int nextUpLength = 0;
    if (_queueService == null) {
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
    for (int i = 0; i < nextUpLength; i++) {
      final swapIndex = indices.indexOf(initialPos + i);
      indices[i] = indices[initialPos + i];
      indices[initialPos + i] = swapIndex;
    }

  }

  @override
  void insert(int index, int count) {
    // // Offset indices after insertion point.
    // for (var i = 0; i < indices.length; i++) {
    //   if (indices[i] >= index) {
    //     indices[i] += count;
    //   }
    // }
    // // Insert new indices at random positions after currentIndex.
    // final newIndices = List.generate(count, (i) => index + i);
    // for (var newIndex in newIndices) {
    //   final insertionIndex = _random.nextInt(indices.length + 1);
    //   indices.insert(insertionIndex, newIndex);
    // }
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
