import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:window_manager/window_manager.dart';

import 'jellyfin_api_helper.dart';
import 'finamp_settings_helper.dart';
import 'offline_listen_helper.dart';
import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart' as jellyfin_models;

/// A track queueing service for Finamp.
class PlaybackHistoryService {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _audioService = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();
  final _offlineListenLogHelper = GetIt.instance<OfflineListenLogHelper>();
  final _playbackHistoryServiceLogger = Logger("PlaybackHistoryService");

  // internal state

  final List<FinampHistoryItem> _history =
      []; // contains **all** items that have been played, including "next up"
  FinampHistoryItem? _currentTrack; // the currently playing track

  PlaybackState? _previousPlaybackState;
  DateTime _lastPositionUpdate = DateTime.now();

  bool _wasOfflineBefore = false;
  FinampQueueItem?
      _lastReportedTrackStarted; // used to check if playback has already reported as "started" at some point for the current track
  FinampQueueItem?
      _lastReportedTrackStopped; // used to prevent reporting a track as stopped multiple times

  final _historyStream = BehaviorSubject<List<FinampHistoryItem>>.seeded(
    List.empty(growable: true),
  );

  Timer? _periodicUpdateTimer;

  // config
  final int _maxQueueLengthToReport = 100;

  PlaybackHistoryService() {
    _queueService.getCurrentTrackStream().listen((currentTrack) {
      if (![AudioProcessingState.idle, AudioProcessingState.completed]
          .contains(_audioService.playbackState.valueOrNull?.processingState)) {
        updateCurrentTrack(currentTrack);
      } else if (_audioService.playbackState.valueOrNull?.processingState ==
              AudioProcessingState.completed ||
          currentTrack == null) {
        _playbackHistoryServiceLogger.info("Handling playback stop event");
        _reportPlaybackStopped();
        // stop periodic background updates if playback has ended
        _periodicUpdateTimer?.cancel();
      }
    });

    FinampSettingsHelper.finampSettingsListener.addListener(() {
      final isOffline = FinampSettingsHelper.finampSettings.isOffline;
      if (!isOffline && _wasOfflineBefore) {
        _updatePlaybackInfo();
      }
      _wasOfflineBefore = FinampSettingsHelper.finampSettings.isOffline;
    });

    _audioService.playbackState.listen((event) {
      final prevState = _previousPlaybackState;
      final prevItem = _currentTrack?.item;
      final currentState = event;
      final currentIndex = currentState.queueIndex;

      final currentItem = _queueService.getCurrentTrack();

      if (currentIndex != null && currentItem != null) {
        // differences in queue index or item id are considered track changes
        if (currentItem.id != prevItem?.id) {
          if (currentState.playing != prevState?.playing) {
            // add to playback history if playback was stopped before
            updateCurrentTrack(currentItem, forceNewTrack: true);
          }
          if (currentState.processingState != AudioProcessingState.completed &&
              (currentState.queueIndex != prevState?.queueIndex ||
                  currentState.position != prevState?.position)) {
            _playbackHistoryServiceLogger.fine(
                "Handling track change event from ${prevItem?.item.title} to ${currentItem.item.title}");
            //TODO handle reporting track changes based on history changes, as that is more reliable
            onTrackChanged(currentItem, currentState, prevItem, prevState,
                currentIndex > (prevState?.queueIndex ?? 0));
          }
        }
        // handle events that don't change the current track (e.g. loop, pause, seek, etc.)

        // handle play/pause events
        else if (currentState.playing != prevState?.playing) {
          _playbackHistoryServiceLogger
              .fine("Handling play/pause event for ${currentItem.item.title}");
          onPlaybackStateChanged(currentItem, currentState, prevState);
        }
        // handle seeking (changes updateTime (= last abnormal position change))
        else if (currentState.playing &&
            prevState != null &&
            // comparing the updateTime timestamps directly is unreliable, as they might just have different microsecond values
            // instead, compare the difference in milliseconds, with a small margin of error
            (currentState.updateTime.millisecondsSinceEpoch -
                        prevState.updateTime.millisecondsSinceEpoch)
                    .abs() >
                1500) {
          bool isSeekEvent = true;

          // detect rewinding & looping a single track
          if (
              // same track
              prevItem?.id == currentItem.id &&
                  // current position is close to the beginning of the track
                  currentState.position.inMilliseconds <= 1000 * 10) {
            if ((prevState.position.inMilliseconds) >=
                ((prevItem?.item.duration?.inMilliseconds ?? 0) - 1000 * 10)) {
              // looping a single track
              // last position was close to the end of the track
              updateCurrentTrack(currentItem,
                  forceNewTrack: true); // add to playback history
              //TODO handle reporting track changes based on history changes, as that is more reliable
              onTrackChanged(
                  currentItem, currentState, prevItem, prevState, true);
              isSeekEvent = false; // don't report seek event
            } else {
              // rewinding
              updateCurrentTrack(currentItem,
                  forceNewTrack: true); // add to playback history
              // don't return, report seek event
              isSeekEvent = true;
            }
          }

          if (isSeekEvent) {
            // rate limit updates (only send update after no changes for 3 seconds) and if the track is still the same
            Future.delayed(const Duration(seconds: 3, milliseconds: 500), () {
              if (_lastPositionUpdate
                      .add(const Duration(seconds: 3))
                      .isBefore(DateTime.now()) &&
                  currentItem.id == _queueService.getCurrentTrack()?.id) {
                _playbackHistoryServiceLogger
                    .fine("Handling seek event for ${currentItem.item.title}");
                onPlaybackStateChanged(currentItem, currentState, prevState);
              }
              _lastPositionUpdate = DateTime.now();
            });
          }
        }
        // maybe handle toggling shuffle when sending the queue? would result in duplicate entries in the activity log, so maybe it's not desirable
        // same for updating the queue / next up
      }

      _previousPlaybackState = event;
    });

    // initialize periodic session updates
    _resetPeriodicUpdates();

    //TODO update progress if queue should be reported and queue changed (e.g. changed shuffle order)

    //TODO Tell Jellyfin we're not / no longer playing audio on startup - doesn't currently work because an item ID is required, and we don't have one (yet)
    // if (!FinampSettingsHelper.finampSettings.isOffline) {
    // final playbackInfo = generatePlaybackProgressInfoFromState(const MediaItem(id: "", title: ""), _audioService.playbackState.valueOrNull ?? PlaybackState());
    // if (playbackInfo != null) {
    // _playbackHistoryServiceLogger.info("Stopping playback progress after startup");
    // _jellyfinApiHelper.stopPlaybackProgress(playbackInfo);
    // }
    // }
  }

  List<FinampHistoryItem> get history => _history;
  BehaviorSubject<List<FinampHistoryItem>> get historyStream => _historyStream;

  void _resetPeriodicUpdates() {
    _periodicUpdateTimer?.cancel(); // remove old timer

    _periodicUpdateTimer = Timer.periodic(
        Duration(
            seconds: FinampSettingsHelper.finampSettings
                .periodicPlaybackSessionUpdateFrequencySeconds), (timer) {
      _reportPeriodicSessionStatus();
    });
  }

  /// method that converts history into a list grouped by date
  List<MapEntry<DateTime, List<FinampHistoryItem>>>
      getHistoryGroupedDynamically() {
    DateTime byDateGroupingConstructor(FinampHistoryItem element) {
      final now = DateTime.now();
      if (now.year == element.startTime.year &&
          now.month == element.startTime.month &&
          now.day == element.startTime.day &&
          now.hour == element.startTime.hour) {
        // group by minute
        return DateTime(
          element.startTime.year,
          element.startTime.month,
          element.startTime.day,
          element.startTime.hour,
          element.startTime.minute,
        );
      } else if (now.year == element.startTime.year &&
          now.month == element.startTime.month &&
          now.day == element.startTime.day) {
        // group by hour
        return DateTime(
          element.startTime.year,
          element.startTime.month,
          element.startTime.day,
          element.startTime.hour,
        );
      }
      // group by date
      return DateTime(
        element.startTime.year,
        element.startTime.month,
        element.startTime.day,
      );
    }

    return getHistoryGrouped(byDateGroupingConstructor);
  }

  /// method that converts history into a list grouped by date
  List<MapEntry<DateTime, List<FinampHistoryItem>>> getHistoryGroupedByDate() {
    DateTime byDateGroupingConstructor(FinampHistoryItem element) {
      return DateTime(
        element.startTime.year,
        element.startTime.month,
        element.startTime.day,
      );
    }

    return getHistoryGrouped(byDateGroupingConstructor);
  }

  /// method that converts history into a list grouped by hour
  List<MapEntry<DateTime, List<FinampHistoryItem>>> getHistoryGroupedByHour() {
    DateTime byHourGroupingConstructor(FinampHistoryItem element) {
      return DateTime(
        element.startTime.year,
        element.startTime.month,
        element.startTime.day,
        element.startTime.hour,
      );
    }

    return getHistoryGrouped(byHourGroupingConstructor);
  }

  /// method that converts history into a list grouped by a custom date constructor controlling the granularity of the grouping
  List<MapEntry<DateTime, List<FinampHistoryItem>>> getHistoryGrouped(
      DateTime Function(FinampHistoryItem) dateTimeConstructor) {
    final groupedHistory = <MapEntry<DateTime, List<FinampHistoryItem>>>[];

    final groupedHistoryMap = <DateTime, List<FinampHistoryItem>>{};

    for (var element in _history) {
      final date = dateTimeConstructor(element);

      if (groupedHistoryMap.containsKey(date)) {
        groupedHistoryMap[date]!.add(element);
      } else {
        groupedHistoryMap[date] = [element];
      }
    }

    groupedHistoryMap.forEach((key, value) {
      groupedHistory.add(MapEntry(key, value));
    });

    // sort by minute (most recent first)
    groupedHistory.sort((a, b) => b.key.compareTo(a.key));

    return groupedHistory;
  }

  void updateCurrentTrack(
    FinampQueueItem? currentTrack, {
    bool forceNewTrack = false,
  }) {
    if (currentTrack == null ||
        !forceNewTrack &&
            (currentTrack == _currentTrack?.item ||
                currentTrack.item.id == "" ||
                currentTrack.id == _currentTrack?.item.id ||
                !_audioService.playbackState.value.playing)) {
      // current track hasn't changed
      return;
    }

    int previousTrackTotalPlayTimeInMilliseconds = 0;
    // if there is a **previous** track
    if (_currentTrack != null) {
      // update end time of previous track
      _currentTrack!.endTime = DateTime.now();
      previousTrackTotalPlayTimeInMilliseconds = _currentTrack!.endTime!
          .difference(_currentTrack!.startTime)
          .inMilliseconds;
    }

    if (previousTrackTotalPlayTimeInMilliseconds < 1000) {
      // replace history item with current track
      if (_history.isNotEmpty) {
        _history.removeLast();
      }
    }

    // if there is a **current** track
    _currentTrack = FinampHistoryItem(
      item: currentTrack,
      startTime: DateTime.now(),
    );
    _history.add(
        _currentTrack!); // current track is always the last item in the history

    _historyStream.add(_history);

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      WindowManager.instance.setTitle(
          "${_currentTrack?.item.item.artist != null ? '${_currentTrack?.item.item.artist} - ' : ''}${_currentTrack!.item.item.title} - Finamp");
    }
  }

  /// Report track changes to the Jellyfin Server if the user is not offline.
  /// If offline, log the track to the offline listen log.
  Future<void> onTrackChanged(
    FinampQueueItem currentItem,
    PlaybackState currentState,
    FinampQueueItem? previousItem,
    PlaybackState? previousState,
    bool skippingForward,
  ) async {
    final shouldReportPreviousTrack = previousItem != null &&
        previousState != null &&
        // don't submit stop events for idle tracks (at position 0 and not playing)
        (previousState.playing ||
            previousState.updatePosition != Duration.zero);

    if (FinampSettingsHelper.finampSettings.isOffline) {
      if (shouldReportPreviousTrack) {
        await _offlineListenLogHelper.logOfflineListen(previousItem.item);
      }
      return;
    }

    jellyfin_models.PlaybackProgressInfo? previousTrackPlaybackData;
    if (shouldReportPreviousTrack) {
      previousTrackPlaybackData = generatePlaybackProgressInfoFromState(
        previousItem,
        previousState,
      );
    }

    // prevent reporting the same track twice if playback hasn't started yet
    if (!currentState.playing) {
      return;
    }

    final newTrackplaybackData = generatePlaybackProgressInfoFromState(
      currentItem,
      currentState,
    );

    //!!! always submit a "start" **AFTER** a "stop" to that Jellyfin knows there's still something playing
    if (previousTrackPlaybackData != null) {
      _playbackHistoryServiceLogger
          .info("Stopping playback progress for ${previousItem?.item.title}");
      try {
        _resetPeriodicUpdates(); // delay next periodic update to avoid race conditions with old data
        //!!! allow reporting the same track here to skipping after looping a single track is reported correctly
        _lastReportedTrackStopped = previousItem;
        await _jellyfinApiHelper
            .stopPlaybackProgress(previousTrackPlaybackData);
        //TODO also mark the track as played in the user data: https://api.jellyfin.org/openapi/api.html#tag/Playstate/operation/MarkPlayedItem
      } catch (e) {
        _playbackHistoryServiceLogger.warning(e);
        if (previousItem != null) {
          await _offlineListenLogHelper.logOfflineListen(previousItem.item);
        }
      }
    }
    if (newTrackplaybackData != null) {
      _playbackHistoryServiceLogger
          .info("Starting playback progress for ${currentItem.item.title}");
      try {
        _resetPeriodicUpdates(); // delay next periodic update to avoid race conditions with old data
        //!!! allow reporting the same track here to ensure loop one reports correctly
        _lastReportedTrackStarted = _currentTrack?.item;
        await _jellyfinApiHelper.reportPlaybackStart(newTrackplaybackData);
      } catch (e) {
        _playbackHistoryServiceLogger.warning(e);
        // don't log start event to offline listen log helper, as only stop events are logged
      }
    }
  }

  /// Report track changes to the Jellyfin Server if the user is not offline.
  Future<void> onPlaybackStateChanged(
    FinampQueueItem currentItem,
    PlaybackState currentState,
    PlaybackState? previousState,
  ) async {
    if (FinampSettingsHelper.finampSettings.isOffline) {
      return;
    }

    final playbackData = generatePlaybackProgressInfoFromState(
      currentItem,
      currentState,
    );

    if (playbackData != null) {
      if (![AudioProcessingState.completed, AudioProcessingState.idle]
          .contains(currentState.processingState)) {
        _playbackHistoryServiceLogger
            .info("Updating playback state for ${currentItem.item.title}");
        await _updatePlaybackInfo(playbackData: playbackData);
      } else {
        _playbackHistoryServiceLogger
            .info("Stopping playback progress for ${currentItem.item.title}");
        try {
          _resetPeriodicUpdates(); // delay next periodic update to avoid race conditions with old data
          if (_lastReportedTrackStopped?.id != currentItem.id) {
            _lastReportedTrackStopped = currentItem;
            await _jellyfinApiHelper.stopPlaybackProgress(playbackData);
          }
        } catch (e) {
          _playbackHistoryServiceLogger.warning(e);
          await _offlineListenLogHelper.logOfflineListen(currentItem.item);
        }
      }
    }
  }

  /// Generates PlaybackProgressInfo for the supplied item and playback state.
  jellyfin_models.PlaybackProgressInfo? generatePlaybackProgressInfoFromState(
    FinampQueueItem item,
    PlaybackState state,
  ) {
    final duration = item.item.duration;
    return generatePlaybackProgressInfo(
      item,
      isPaused: !state.playing,
      // always consider as unmuted
      isMuted: false,
      // ensure the (extrapolated) position doesn't exceed the duration
      playerPosition: duration != null && state.position > duration
          ? duration
          : state.position,
      includeNowPlayingQueue:
          FinampSettingsHelper.finampSettings.reportQueueToServer,
    );
  }

  Future<void> _reportPlaybackStopped() async {
    final playbackInfo = generateGenericPlaybackProgressInfo();
    if (playbackInfo != null) {
      try {
        _resetPeriodicUpdates(); // delay next periodic update to avoid race conditions with old data
        if (_lastReportedTrackStopped?.id != _currentTrack?.item.id) {
          _lastReportedTrackStopped = _currentTrack?.item;
          if (FinampSettingsHelper.finampSettings.isOffline) {
            await _offlineListenLogHelper
                .logOfflineListen(_currentTrack!.item.item);
          } else {
            await _jellyfinApiHelper.stopPlaybackProgress(playbackInfo);
          }
        }
      } catch (e) {
        _playbackHistoryServiceLogger.warning(e);
        await _offlineListenLogHelper
            .logOfflineListen(_currentTrack!.item.item);
      }
    }
  }

  Future<void> _updatePlaybackInfo(
      {jellyfin_models.PlaybackProgressInfo? playbackData}) async {
    if (FinampSettingsHelper.finampSettings.isOffline) {
      return;
    }
    final playbackInfo = playbackData ?? generateGenericPlaybackProgressInfo();
    if (playbackInfo != null) {
      try {
        _resetPeriodicUpdates(); // delay next periodic update to avoid race conditions with old data
        if (_lastReportedTrackStarted?.id != _currentTrack?.item.id) {
          // _playbackStartNotYetReported = false;
          _lastReportedTrackStarted = _currentTrack?.item;
          await _jellyfinApiHelper.reportPlaybackStart(playbackInfo);
        } else {
          await _jellyfinApiHelper.updatePlaybackProgress(playbackInfo);
        }
      } catch (e) {
        _playbackHistoryServiceLogger.warning(e);
      }
    }
  }

  Future<void> _reportPeriodicSessionStatus() async {
    await _updatePlaybackInfo();
  }

  /// Generates PlaybackProgressInfo for the supplied item and player info.
  jellyfin_models.PlaybackProgressInfo? generatePlaybackProgressInfo(
    FinampQueueItem item, {
    required bool isPaused,
    required bool isMuted,
    required Duration playerPosition,
    required bool includeNowPlayingQueue,
  }) {
    try {
      return jellyfin_models.PlaybackProgressInfo(
        itemId: item.baseItem?.id ?? "",
        playSessionId: _queueService.getQueue().id,
        isPaused: isPaused,
        isMuted: isMuted,
        positionTicks: playerPosition.inMicroseconds * 10,
        playbackStartTimeTicks:
            _currentTrack!.startTime.millisecondsSinceEpoch * 1000 * 10,
        volumeLevel: (_audioService.volume * 100).round(),
        repeatMode: _toJellyfinRepeatMode(_queueService.loopMode),
        playMethod: item.item.extras?["shouldTranscode"] ?? false
            ? "Transcode"
            : "DirectPlay",
        playbackOrder:
            _queueService.playbackOrder == FinampPlaybackOrder.shuffled
                ? "Shuffle"
                : "Default",
        nowPlayingQueue:
            getQueueToReport(includeNowPlayingQueue: includeNowPlayingQueue),
        playlistItemId: _queueService.getQueue().source.id,
      );
    } catch (e) {
      _playbackHistoryServiceLogger.warning(e);
      return null;
      // rethrow;
    }
  }

  /// Generates PlaybackProgressInfo from current player info.
  jellyfin_models.PlaybackProgressInfo? generateGenericPlaybackProgressInfo({
    bool includeNowPlayingQueue = false,
  }) {
    if (_history.isEmpty || _currentTrack == null) {
      // This function relies on _history having items
      return null;
    }

    try {
      final itemId = _currentTrack!.item.item.extras?["itemJson"]["Id"];

      if (itemId == null) {
        _playbackHistoryServiceLogger.warning(
          "Current track item ID is null, cannot generate playback progress info.",
        );
        return null;
      }

      return jellyfin_models.PlaybackProgressInfo(
        itemId: _currentTrack!.item.baseItem?.id ?? "",
        playSessionId: _queueService.getQueue().id,
        canSeek: true,
        isPaused: _audioService.paused,
        isMuted: _audioService.volume == 0.0,
        positionTicks: _audioService.playbackPosition.inMicroseconds * 10,
        playbackStartTimeTicks:
            _currentTrack!.startTime.millisecondsSinceEpoch * 1000 * 10,
        volumeLevel: (_audioService.volume * 100).round(),
        playMethod: _currentTrack!.item.item.extras!["shouldTranscode"]
            ? "Transcode"
            : "DirectPlay",
        playbackOrder:
            _queueService.playbackOrder == FinampPlaybackOrder.shuffled
                ? "Shuffle"
                : "Default",
        repeatMode: _toJellyfinRepeatMode(_queueService.loopMode),
        nowPlayingQueue: getQueueToReport(),
        playlistItemId: _queueService.getQueue().source.id,
      );
    } catch (e) {
      _playbackHistoryServiceLogger.warning(e);
      rethrow;
    }
  }

  List<jellyfin_models.QueueItem>? getQueueToReport(
      {bool? includeNowPlayingQueue}) {
    if ((includeNowPlayingQueue ?? false) &&
        FinampSettingsHelper.finampSettings.reportQueueToServer) {
      final queue = _queueService
          .peekQueue(next: _maxQueueLengthToReport)
          .map((e) => jellyfin_models.QueueItem(
                id: e.item.id,
                playlistItemId: e.type.name,
              ))
          .toList();
      return queue;
    } else {
      return null;
    }
  }

  String _toJellyfinRepeatMode(FinampLoopMode loopMode) {
    switch (loopMode) {
      case FinampLoopMode.all:
        return "RepeatAll";
      case FinampLoopMode.one:
        return "RepeatOne";
      case FinampLoopMode.none:
        return "RepeatNone";
    }
  }
}
