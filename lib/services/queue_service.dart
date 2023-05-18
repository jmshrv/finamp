import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'finamp_user_helper.dart';
import 'jellyfin_api_helper.dart';
import 'finamp_settings_helper.dart';
import 'downloads_helper.dart';
import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import 'music_player_background_task.dart';

/// A track queueing service for Finamp.
class QueueService {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _queueServiceLogger = Logger("QueueService");

  // internal state

  // the audio source used by the player. The first X items of all internal queues are merged together into this source, so that all player features, like gapless playback, are supported
  ConcatenatingAudioSource _queueAudioSource = ConcatenatingAudioSource(
    children: [],
    useLazyPreparation: true,
  );
  final int _audioSourceItemCount = 1 + 1 + 5; 

  List<MediaItem> _queue = []; // contains all regular queue items
  int _currentQueueIndex = 0;
  List<MediaItem> _nextUpQueue = []; // a temporary queue that gets appended to if the user taps "next up"
  List<MediaItem> _queueHistory = []; // contains **all** items that have been played, including "next up"
  PlaybackList _initialQueue = PlaybackList.create(items: [], type: PlaybackListType.unknown, name: "Somewhere"); // contains the original queue that was set when the queue was last fully replaced using `replaceQueueWithItems`. This is used to repeat the original queue once the end has been reached, **excluding** "next up" items.

  QueueService() {

    _audioHandler.getPlaybackEventStream().listen((event) async {

      _currentQueueIndex = event.currentIndex ?? 0;

    });
    
  }

  Future<void> startPlayback(PlaybackList list) async {

    _initialQueue = list; // save original PlaybackList for looping/restarting and meta info
    _replaceWithItems(itemList: list.items);
    _queueServiceLogger.info("Started playing PlaybackList '${list.info.name}' (${list.info.type})");
    
  }

  /// Replaces the queue with the given list of items. If startAtIndex is specified, Any items below it
  /// will be ignored. This is used for when the user taps in the middle of an album to start from that point.
  Future<void> _replaceWithItems({
    required List<BaseItemDto>
        itemList, //TODO create a custom type for item lists that can also hold the name of the list, etc.
    int initialIndex = 0,
    bool shuffle = false,
  }) async {
    try {
      if (initialIndex > itemList.length) {
        return Future.error(
            "initialIndex is bigger than the itemList! ($initialIndex > ${itemList.length})");
      }

      _queue.clear(); // empty queue

      for (BaseItemDto item in itemList) {
        try {
          _queue.add(await _generateMediaItem(item));
        } catch (e) {
          _queueServiceLogger.severe(e);
        }
      }

      // start playing first item in queue
      _currentQueueIndex = 0;
      _audioHandler.setNextInitialIndex(_currentQueueIndex);

      _queueAudioSource.clear();

      for (final mediaItem in _queue) {
        _queueAudioSource.add(await _mediaItemToAudioSource(mediaItem));
      }

      //TODO implement shuffle

      _audioHandler.initializeAudioSource(_queueAudioSource);

      _audioHandler.queue.add(_queue);

      _audioHandler.mediaItem.add(_queue[_currentQueueIndex]);
      _audioHandler.play();

      _audioHandler.nextInitialIndex = null;
      

    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> addItemAtEnd(BaseItemDto item) async {
    try {
      // If the queue is empty (like when the app is first launched), run the
      // replace queue function instead so that the song gets played
      if ((_audioHandler.queue.valueOrNull?.length ?? 0) == 0) {
        await _replaceWithItems(itemList: [item]);
        return;
      }

      final itemMediaItem = await _generateMediaItem(item);
      await _audioHandler.addQueueItem(itemMediaItem);
    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  Future<void> addItemAtNext(BaseItemDto item) async {
    try {
      // If the queue is empty (like when the app is first launched), run the
      // replace queue function instead so that the song gets played
      if ((_queueAudioSource.length ?? 0) == 0) {
        await _replaceWithItems(itemList: [item]);
        return;
      }

      final itemMediaItem = await _generateMediaItem(item);
      await _audioHandler.addQueueItem(itemMediaItem);

      
      
    } catch (e) {
      _queueServiceLogger.severe(e);
      return Future.error(e);
    }
  }

  PlaybackListInfo getPlaybackListInfo() {
    return _initialQueue.info;
  }

  Future<MediaItem> _generateMediaItem(BaseItemDto item) async {
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
