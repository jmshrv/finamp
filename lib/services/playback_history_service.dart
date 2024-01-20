import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

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
  final bool _reportQueueToServer = true;
  DateTime _lastPositionUpdate = DateTime.now();

  bool _wasOfflineBefore = false;

  final _historyStream = BehaviorSubject<List<FinampHistoryItem>>.seeded(
    List.empty(growable: true),
  );

  PlaybackHistoryService() {
    _queueService.getCurrentTrackStream().listen((currentTrack) {
      updateCurrentTrack(currentTrack);

      if (currentTrack == null) {
        _reportPlaybackStopped();
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
        if (currentItem.id != prevItem?.id ||
            (_reportQueueToServer && currentIndex != prevState?.queueIndex)) {
          _playbackHistoryServiceLogger.fine(
              "Reporting track change event from ${prevItem?.item.title} to ${currentItem.item.title}");
          //TODO handle reporting track changes based on history changes, as that is more reliable
          onTrackChanged(currentItem, currentState, prevItem, prevState,
              currentIndex > (prevState?.queueIndex ?? 0));
        }
        // handle events that don't change the current track (e.g. loop, pause, seek, etc.)

        // handle play/pause events
        else if (currentState.playing != prevState?.playing) {
          _playbackHistoryServiceLogger
              .fine("Reporting play/pause event for ${currentItem.item.title}");
          onPlaybackStateChanged(currentItem, currentState);
        }
        // handle seeking (changes updateTime (= last abnormal position change))
        else if (currentState.playing &&
            currentState.updateTime != prevState?.updateTime &&
            currentState.bufferedPosition == prevState?.bufferedPosition) {
          // detect rewinding & looping a single track
          if (
              // same track
              prevItem?.id == currentItem.id &&
                  // current position is close to the beginning of the track
                  currentState.position.inMilliseconds <= 1000 * 10) {
            if ((prevState?.position.inMilliseconds ?? 0) >=
                ((prevItem?.item.duration?.inMilliseconds ?? 0) - 1000 * 10)) {
              // looping a single track
              // last position was close to the end of the track
              updateCurrentTrack(currentItem, forceNewTrack: true); // add to playback history
              //TODO handle reporting track changes based on history changes, as that is more reliable
              onTrackChanged(
                  currentItem, currentState, prevItem, prevState, true);
              return; // don't report seek event
            } else {
              // rewinding
              updateCurrentTrack(currentItem, forceNewTrack: true); // add to playback history
              // don't return, report seek event
            }
          }

          // rate limit updates (only send update after no changes for 3 seconds) and if the track is still the same
          Future.delayed(const Duration(seconds: 3, milliseconds: 500), () {
            if (_lastPositionUpdate
                    .add(const Duration(seconds: 3))
                    .isBefore(DateTime.now()) &&
                currentItem.id == _queueService.getCurrentTrack()?.id) {
              _playbackHistoryServiceLogger
                  .fine("Reporting seek event for ${currentItem.item.title}");
              onPlaybackStateChanged(currentItem, currentState);
            }
            _lastPositionUpdate = DateTime.now();
          });
        }
        // maybe handle toggling shuffle when sending the queue? would result in duplicate entries in the activity log, so maybe it's not desirable
        // same for updating the queue / next up
      }

      _previousPlaybackState = event;
    });

    //TODO Tell Jellyfin we're not / no longer playing audio on startup - doesn't currently work because an item ID is required, and we don't have one (yet)
    // if (!FinampSettingsHelper.finampSettings.isOffline) {
    // final playbackInfo = generatePlaybackProgressInfoFromState(const MediaItem(id: "", title: ""), _audioService.playbackState.valueOrNull ?? PlaybackState());
    // if (playbackInfo != null) {
    // _playbackHistoryServiceLogger.info("Stopping playback progress after startup");
    // _jellyfinApiHelper.stopPlaybackProgress(playbackInfo);
    // }
    // }
  }

  get history => _history;
  BehaviorSubject<List<FinampHistoryItem>> get historyStream => _historyStream;

  /// method that converts history into a list grouped by date
  List<MapEntry<DateTime, List<FinampHistoryItem>>>
      getHistoryGroupedDynamically() {
    byDateGroupingConstructor(FinampHistoryItem element) {
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
    byDateGroupingConstructor(FinampHistoryItem element) {
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
    byHourGroupingConstructor(FinampHistoryItem element) {
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

  void updateCurrentTrack(FinampQueueItem? currentTrack, {
    bool forceNewTrack = false,
  }) {
    if (currentTrack == null ||
        !forceNewTrack && (
          currentTrack == _currentTrack?.item ||
          currentTrack.item.id == "" ||
          currentTrack.id == _currentTrack?.item.id
        )
      ) {
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
    if (FinampSettingsHelper.finampSettings.isOffline) {
      if (previousItem != null) {
        _offlineListenLogHelper.logOfflineListen(previousItem.item);
      }
      return;
    }

    jellyfin_models.PlaybackProgressInfo? previousTrackPlaybackData;
    if (previousItem != null &&
        previousState != null &&
        // don't submit stop events for idle tracks (at position 0 and not playing)
        (previousState.playing ||
            previousState.updatePosition != Duration.zero)) {
      previousTrackPlaybackData = generatePlaybackProgressInfoFromState(
        previousItem.item,
        previousState,
      );
    }

    // prevent reporting the same track twice if playback hasn't started yet
    if (!currentState.playing) {
      return;
    }

    final newTrackplaybackData = generatePlaybackProgressInfoFromState(
      currentItem.item,
      currentState,
    );

    //!!! always submit a "start" **AFTER** a "stop" to that Jellyfin knows there's still something playing
    if (previousTrackPlaybackData != null) {
      _playbackHistoryServiceLogger
          .info("Stopping playback progress for ${previousItem?.item.title}");
      try {
        await _jellyfinApiHelper.stopPlaybackProgress(previousTrackPlaybackData);
        //TODO also mark the track as played in the user data: https://api.jellyfin.org/openapi/api.html#tag/Playstate/operation/MarkPlayedItem
      } catch (e) {
        _playbackHistoryServiceLogger.warning(e);
        if (previousItem != null) {
          _offlineListenLogHelper.logOfflineListen(previousItem.item);
        }
      }
    }
    if (newTrackplaybackData != null) {
      _playbackHistoryServiceLogger
          .info("Starting playback progress for ${currentItem.item.title}");
      try {
        await _jellyfinApiHelper.reportPlaybackStart(newTrackplaybackData);
      } catch (e) {
        _playbackHistoryServiceLogger.warning(e);
        //!!! don't catch with offline listen log helper, as only stop events are logged
      }
    }
  }

  /// Report track changes to the Jellyfin Server if the user is not offline.
  Future<void> onPlaybackStateChanged(
    FinampQueueItem currentItem,
    PlaybackState currentState,
  ) async {
    if (FinampSettingsHelper.finampSettings.isOffline) {
      return;
    }

    final playbackData = generatePlaybackProgressInfoFromState(
      currentItem.item,
      currentState,
    );

    if (playbackData != null) {
      if (![AudioProcessingState.completed, AudioProcessingState.idle]
          .contains(currentState.processingState)) {
        _playbackHistoryServiceLogger
            .info("Starting playback progress for ${currentItem.item.title}");
        try {
          await _jellyfinApiHelper.reportPlaybackStart(playbackData);
        } catch (e) {
          _playbackHistoryServiceLogger.warning(e);
          //!!! don't catch with offline listen log helper, as only stop events are logged
        }
      } else {
        _playbackHistoryServiceLogger
            .info("Stopping playback progress for ${currentItem.item.title}");
        try {
          await _jellyfinApiHelper.stopPlaybackProgress(playbackData);
        } catch (e) {
          _playbackHistoryServiceLogger.warning(e);
          _offlineListenLogHelper.logOfflineListen(currentItem.item);
        }
      }
    }
  }

  /// Generates PlaybackProgressInfo for the supplied item and playback state.
  jellyfin_models.PlaybackProgressInfo? generatePlaybackProgressInfoFromState(
    MediaItem item,
    PlaybackState state,
  ) {
    final duration = item.duration;
    return generatePlaybackProgressInfo(
      item,
      isPaused: !state.playing,
      // always consider as unmuted
      isMuted: false,
      // ensure the (extrapolated) position doesn't exceed the duration
      playerPosition: duration != null && state.position > duration
          ? duration
          : state.position,
      repeatMode: _jellyfinRepeatModeFromRepeatMode(state.repeatMode),
      includeNowPlayingQueue: _reportQueueToServer,
    );
  }

  Future<void> _reportPlaybackStopped() async {
    if (FinampSettingsHelper.finampSettings.isOffline) {
      if (_currentTrack != null) {
        _offlineListenLogHelper.logOfflineListen(_currentTrack!.item.item);
      }
      return;
    }
    final playbackInfo = generateGenericPlaybackProgressInfo();
    if (playbackInfo != null) {
      try {
        await _jellyfinApiHelper.stopPlaybackProgress(playbackInfo);
      } catch (e) {
        _playbackHistoryServiceLogger.warning(e);
        _offlineListenLogHelper.logOfflineListen(_currentTrack!.item.item);
      }
    }
  }

  Future<void> _updatePlaybackInfo() async {
    if (FinampSettingsHelper.finampSettings.isOffline) {
      return;
    }
    final playbackInfo = generateGenericPlaybackProgressInfo();
    if (playbackInfo != null) {
      try {
        await _jellyfinApiHelper.reportPlaybackStart(playbackInfo);
      } catch (e) {
        _playbackHistoryServiceLogger.warning(e);
        _offlineListenLogHelper.logOfflineListen(_currentTrack!.item.item);
      }
    }
  }

  /// Generates PlaybackProgressInfo for the supplied item and player info.
  jellyfin_models.PlaybackProgressInfo? generatePlaybackProgressInfo(
    MediaItem item, {
    required bool isPaused,
    required bool isMuted,
    required Duration playerPosition,
    required String repeatMode,
    required bool includeNowPlayingQueue,
  }) {
    try {
      List<jellyfin_models.QueueItem>? nowPlayingQueue;
      if (includeNowPlayingQueue) {
        nowPlayingQueue = _queueService
            .getNextXTracksInQueue(30)
            .map((e) => jellyfin_models.QueueItem(
                  id: e.item.id,
                  playlistItemId: e.source.id,
                ))
            .toList();
      }

      return jellyfin_models.PlaybackProgressInfo(
        itemId: item.extras?["itemJson"]["Id"] ?? "",
        isPaused: isPaused,
        isMuted: isMuted,
        positionTicks: playerPosition.inMicroseconds * 10,
        repeatMode: repeatMode,
        playMethod: item.extras?["shouldTranscode"] ?? false
            ? "Transcode"
            : "DirectPlay",
        nowPlayingQueue: nowPlayingQueue,
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
        itemId: _currentTrack!.item.item.extras?["itemJson"]["Id"],
        isPaused: _audioService.paused,
        isMuted: _audioService.volume == 0.0,
        volumeLevel: _audioService.volume.round(),
        positionTicks: _audioService.playbackPosition.inMicroseconds * 10,
        repeatMode: _toJellyfinRepeatMode(_queueService.loopMode),
        playbackStartTimeTicks:
            _currentTrack!.startTime.millisecondsSinceEpoch * 1000 * 10,
        playMethod: _currentTrack!.item.item.extras!["shouldTranscode"]
            ? "Transcode"
            : "DirectPlay",
        // We don't send the queue since it seems useless and it can cause
        // issues with large queues.
        // https://github.com/jmshrv/finamp/issues/387
        nowPlayingQueue: includeNowPlayingQueue
            ? _queueService
                .getQueue()
                .nextUp
                .followedBy(_queueService.getQueue().queue)
                .map(
                  (e) => jellyfin_models.QueueItem(
                      id: e.item.extras!["itemJson"]["Id"],
                      playlistItemId: e.item.id),
                )
                .toList()
            : null,
      );
    } catch (e) {
      _playbackHistoryServiceLogger.warning(e);
      rethrow;
    }
  }

  String _jellyfinRepeatModeFromRepeatMode(AudioServiceRepeatMode repeatMode) {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        return "RepeatNone";
      case AudioServiceRepeatMode.one:
        return "RepeatOne";
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        return "RepeatAll";
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
