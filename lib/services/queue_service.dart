import 'dart:async';
import 'dart:io';
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
    QueueItem(item: MediaItem(id: "", title: "No track playing", album: "No album", artist: "No artist"), source: QueueItemSource(id: "", name: "", type: QueueItemType.unknown))
  ); 
  final _queueStream = BehaviorSubject<QueueInfo>.seeded(QueueInfo(
    previousTracks: [],
    currentTrack: QueueItem(item: MediaItem(id: "", title: "No track playing", album: "No album", artist: "No artist"), source: QueueItemSource(id: "", name: "", type: QueueItemType.unknown)),
    queue: [],
  )); 

  // external queue state

  // the audio source used by the player. The first X items of all internal queues are merged together into this source, so that all player features, like gapless playback, are supported
  ConcatenatingAudioSource _queueAudioSource = ConcatenatingAudioSource(
    children: [],
    useLazyPreparation: true,
  );
  int _queueAudioSourceIndex = 0;

  QueueService() {

    _audioHandler.getPlaybackEventStream().listen((event) async {

      int indexDifference = (event.currentIndex ?? 0) - _queueAudioSourceIndex;

      _queueServiceLogger.finer("Play queue index changed, difference: $indexDifference");

      if (indexDifference == 0) {
        //TODO figure out a way to detect looped tracks (loopMode == LoopMode.one) to add them to the playback history
        return;
      } else if (indexDifference.abs() == 1) {
        // player skipped ahead/back
        if (indexDifference > 0) {
          // await _applyNextTrack(eventFromPlayer: true);
        } else if (indexDifference < 0) {
          //TODO properly handle rewinding instead of skipping back
          // await _applyPreviousTrack(eventFromPlayer: true);
        }
      } else if (indexDifference.abs() > 1) {
        // player skipped ahead/back by more than one track
        //TODO implement
        _queueServiceLogger.severe("Skipping ahead/back by more than one track not handled yet");
        // return;
      
      }

      _queueAudioSourceIndex = event.currentIndex ?? 0;

    });

    // register callbacks
    _audioHandler.setQueueCallbacks(
      nextTrackCallback: _applyNextTrack,
      previousTrackCallback: _applyPreviousTrack,
      skipToIndexCallback: _applySkipToTrackByOffset,
    );
    
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
    
    if (addCurrentTrackToPreviousTracks) {
      _queuePreviousTracks.add(_currentTrack!);
    }
    
    await pushQueueToExternalQueues();

    _currentTrack = _queue.removeAt(0);
    _currentTrackStream.add(_currentTrack!);

    _logQueues(message: "after skipping forward");

    _queueStream.add(getQueue());

    _queueAudioSourceIndex++; // increment external queue index so we can detect that the change has already been handled once

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
    
    if (addCurrentTrackToQueue) {
      _queue.insert(0, _currentTrack!);
    }

    await pushQueueToExternalQueues();
    
    _currentTrack = _queuePreviousTracks.removeLast();
    _currentTrackStream.add(_currentTrack!);

    // _queueAudioSourceIndex--; // increment external queue index so we can detect that the change has already been handled once

    _logQueues(message: "after skipping backwards");

    _queueStream.add(getQueue());

    // await pushQueueToExternalQueues();

    return true;
    
  }

  Future<bool> _applySkipToTrackByOffset(int offset) async {

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

    await pushQueueToExternalQueues();

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

      // log linear order and shuffled order
      String linearOrderString = "";
      for (int itemIndex in _order.linearOrder) {
        linearOrderString += "${newItems[itemIndex].item.title}, ";
      }
      String shuffledOrderString = "";
      for (int itemIndex in _order.shuffledOrder) {
        shuffledOrderString += "${newItems[itemIndex].item.title}, ";
      }

      _queueServiceLogger.finer("Linear order [${_order.linearOrder.length}]: $linearOrderString");
      _queueServiceLogger.finer("Shuffled order [${_order.shuffledOrder.length}]: $shuffledOrderString");

      // add items to queue
      for (int itemIndex in (playbackOrder == PlaybackOrder.linear ? _order.linearOrder : _order.shuffledOrder)) {
        _queue.add(_order.items[itemIndex]);
      }

      _currentTrack = _queue.removeAt(0);
      _currentTrackStream.add(_currentTrack!);
      _queueServiceLogger.info("Current track: '${_currentTrack!.item.title}'");

      _logQueues(message: "after replacing whole queue");

      // start playing first item in queue
      _queueAudioSourceIndex = 0;
      _audioHandler.setNextInitialIndex(_queueAudioSourceIndex);

      _queueAudioSource = ConcatenatingAudioSource(children: []);
      await _queueAudioSource.add(await _mediaItemToAudioSource(_currentTrack!.item));

      for (final queueItem in _queue) {
        await _queueAudioSource.add(await _mediaItemToAudioSource(queueItem.item));
      }

      await _audioHandler.initializeAudioSource(_queueAudioSource);

      _audioHandler.queue.add(_queue.map((e) => e.item).toList());

      _queueStream.add(getQueue());

      _audioHandler.mediaItem.add(_currentTrack!.item);
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
      );

      _order.items.add(queueItem);
      _order.linearOrder.add(_order.items.length - 1);
      _order.shuffledOrder.add(_order.items.length - 1); //TODO maybe the item should be shuffled into the queue instead of placed at the end? depends on user preference

      _queue.add(queueItem);

      _queueServiceLogger.fine("Added '${queueItem.item.title}' to queue from '${source.name}' (${source.type})");

      if (_loopMode == LoopMode.all && _queue.length == 0) {
        await pushQueueToExternalQueues();
      }
      
    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> addNext(jellyfin_models.BaseItemDto item) async {
    try {
      QueueItem queueItem = QueueItem(
        item: await _generateMediaItem(item),
        source: QueueItemSource(id: "up-next", name: "Up Next", type: QueueItemType.upNext),
      );

      // don't add to _order, because it wasn't added to the regular queue
      _queueNextUp.insert(0, queueItem);

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
        source: QueueItemSource(id: "up-next", name: "Up Next", type: QueueItemType.upNext),
      );

      // don't add to _order, because it wasn't added to the regular queue

      _queueNextUp.add(queueItem);

      _queueServiceLogger.fine("Prepended '${queueItem.item.title}' to Next Up");

    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  QueueInfo getQueue() {

    return QueueInfo(
      previousTracks: _queuePreviousTracks,
      currentTrack: _currentTrack!,
      queue: _queue,
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
    _currentTrackStream.add(_currentTrack ?? QueueItem(item: const MediaItem(id: "", title: "No track playing", album: "No album", artist: "No artist"), source: QueueItemSource(id: "", name: "", type: QueueItemType.unknown)));

    if (mode == LoopMode.one) {
      // _audioHandler.setRepeatMode(AudioServiceRepeatMode.one); // without the repeat mode, we cannot prevent the player from skipping to the next track
    } else {
      // _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);

      // handle enabling loop all when the queue is empty
      if (mode == LoopMode.all && (_queue.length + _queueNextUp.length == 0)) {
        // _applyLoopQueue();
      } else if (mode != LoopMode.all) {
        // find current track in `_order` and set the queue to the items after it
        int currentTrackIndex = _order.items.indexOf(_currentTrack!);
        int currentTrackOrderIndex = (_playbackOrder == PlaybackOrder.linear ? _order.linearOrder : _order.shuffledOrder).indexWhere((trackIndex) => trackIndex == currentTrackIndex);
        // use indices of current playback order to get the items after the current track
        List<int> itemsAfterCurrentTrack = (_playbackOrder == PlaybackOrder.linear ? _order.linearOrder : _order.shuffledOrder).sublist(currentTrackOrderIndex+1);
        // add items to queue
        _queue.clear();
        for (int itemIndex in itemsAfterCurrentTrack) {
          _queue.add(_order.items[itemIndex]);
        }

        _logQueues(message: "after looping");

        // update external queues
        // pushQueueToExternalQueues();

      }
    }
    
  }

  LoopMode get loopMode => _loopMode;

  set playbackOrder(PlaybackOrder order) {
    _playbackOrder = order;
    // _currentTrackStream.add(_currentTrack ?? QueueItem(item: MediaItem(id: "", title: "No track playing", album: "No album", artist: "No artist"), source: QueueItemSource(id: "", name: "", type: QueueItemType.unknown)));

    // update queue accordingly and generate new shuffled order if necessary
    if (_currentTrack != null) {
      _applyUpdatePlaybackOrder();
    }

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
