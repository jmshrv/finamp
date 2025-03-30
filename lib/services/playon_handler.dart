import 'dart:async';

import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/playback_history_service.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finamp/services/favorite_provider.dart';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../services/music_player_background_task.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/finamp_settings_helper.dart';
import 'dart:convert';
import 'finamp_user_helper.dart';

import 'package:get_it/get_it.dart';

final _playOnHandlerLogger = Logger("PlayOnHandler");
final finampUserHelper = GetIt.instance<FinampUserHelper>();
final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
final queueService = GetIt.instance<QueueService>();
final audioServiceHelper = GetIt.instance<AudioServiceHelper>();
final playbackHistoryService = GetIt.instance<PlaybackHistoryService>();
final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
var channel;
var keepaliveSubscription;
var reconnectionSubscription = null;

class PlayonHandler {
  late WidgetRef ref;

  Future<void> initialize() async {
    // Turn on/off when offline mode is toggled
    var settingsListener = FinampSettingsHelper.finampSettingsListener;
    settingsListener.addListener(() async {
      _playOnHandlerLogger.info("Settings changed, restarting listener");
      if (FinampSettingsHelper.finampSettings.isOffline) {
        await closeListener();
      } else {
        await startListener();
      }
    });

    await startListener();
  }

  Future<void> startListener() async {
    try {
      if (!FinampSettingsHelper.finampSettings.isOffline) {
        await jellyfinApiHelper.updateCapabilitiesFull(ClientCapabilities(
          supportsMediaControl: true,
          supportsPersistentIdentifier: true,
          playableMediaTypes: ["Audio"],
          supportedCommands: [
            "MoveUp",
            "MoveDown",
            "MoveLeft",
            "MoveRight",
            "PageUp",
            "PageDown",
            "PreviousLetter",
            "NextLetter",
            "ToggleOsd",
            "ToggleContextMenu",
            "Select",
            "Back",
            "TakeScreenshot",
            "SendKey",
            "SendString",
            "GoHome",
            "GoToSettings",
            "VolumeUp",
            "VolumeDown",
            "Mute",
            "Unmute",
            "ToggleMute",
            "SetVolume",
            "SetAudioStreamIndex",
            "SetSubtitleStreamIndex",
            "ToggleFullscreen",
            "DisplayContent",
            "GoToSearch",
            "DisplayMessage",
            "SetRepeatMode",
            "ChannelUp",
            "ChannelDown",
            "Guide",
            "ToggleStats",
            "PlayMediaSource",
            "PlayTrailers",
            "SetShuffleQueue",
            "PlayState",
            "PlayNext",
            "ToggleOsdMenu",
            "Play",
            "SetMaxStreamingBitrate",
            "SetPlaybackOrder"
          ],
        ));
        await connectWebsocket();
      }
      reconnectionSubscription?.cancel();
      reconnectionSubscription = null;
    } catch (e) {
      if (reconnectionSubscription == null) {
        unawaited(startReconnectionLoop());
        _playOnHandlerLogger.severe("Error starting PlayOn listener: $e");
      }
    }
  }

  Future<void> startReconnectionLoop() async {
    reconnectionSubscription =
        Stream.periodic(const Duration(seconds: 5), (count) {
      return count;
    }).listen((count) {
      startListener();
      _playOnHandlerLogger.info("Attempted to restart listener");
    });
  }

  Future<void> connectWebsocket() async {
    final url =
        "${finampUserHelper.currentUser!.baseUrl}/socket?api_key=${finampUserHelper.currentUser!.accessToken}";
    final parsedUrl = Uri.parse(url);
    final wsUrl =
        parsedUrl.replace(scheme: parsedUrl.scheme == "https" ? "wss" : "ws");
    channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;
    _playOnHandlerLogger.info("WebSocket connection to server established");

    channel.sink.add('{"MessageType":"KeepAlive"}');

    channel.stream.listen(
      (dynamic message) {
        unawaited(handleMessage(message));
      },
      onDone: () {
        keepaliveSubscription?.cancel();
        if (FinampSettingsHelper.finampSettings.isOffline) {
          _playOnHandlerLogger
              .info("WebSocket connection closed, offline mode is on");
        } else {
          _playOnHandlerLogger
              .warning("WebSocket connection closed, attempting to reconnect");
          startReconnectionLoop();
        }
      },
      onError: (error) {
        _playOnHandlerLogger.severe("WebSocket Error: $error");
      },
    );

    keepaliveSubscription =
        Stream.periodic(const Duration(seconds: 30), (count) {
      return count;
    }).listen((event) {
      _playOnHandlerLogger.info("Sent KeepAlive message through websocket");
      channel.sink.add('{"MessageType":"KeepAlive"}');
    });
  }

  Future<void> closeListener() async {
    _playOnHandlerLogger.info("Closing playon session");
    channel.sink.add('{"MessageType":"SessionsStop"}');
    channel.sink.close();
    keepaliveSubscription?.cancel();

    // In case offline mod is turned on while attempting to reconnect
    reconnectionSubscription?.cancel();
    reconnectionSubscription = null;
  }

  Future<void> handleMessage(dynamic value) async {
    _playOnHandlerLogger.finest("Received message: $value");

    var request = jsonDecode(value as String);

    if (request['MessageType'] != 'ForceKeepAlive' &&
        request['MessageType'] != 'KeepAlive') {
      switch (request['MessageType']) {
        case "GeneralCommand":
          switch (request['Data']['Name']) {
            case "DisplayMessage":
              final messageFromServer = request['Data']['Arguments']['Text'];
              final header = request['Data']['Arguments']['Header'];
              final timeout = request['Data']['Arguments']['Timeout'];
              _playOnHandlerLogger
                  .info("Displaying message from server: '$messageFromServer'");
              GlobalSnackbar.message(
                  (context) => "$header: $messageFromServer");
              break;
            case "SetVolume":
              _playOnHandlerLogger.info("Server requested a volume adjustment");
              // Currently very broken

              // final desiredVolume = request['Data']['Arguments']['Volume'] as String;
              // FinampSettingsHelper.setCurrentVolume(
              //     double.parse(desiredVolume) / 100.0);
          }
          break;
        case "UserDataChanged":
          var item = await jellyfinApiHelper
              .getItemById(BaseItemId(request['Data']['UserDataList'][0]['ItemId'] as String));

          // Handle favoritig from remote client
          _playOnHandlerLogger.info("Updating favorite ui state");
          ref
              .read(isFavoriteProvider(item).notifier)
              .updateState(item.userData!.isFavorite);
          break;
        default:
          switch (request['Data']['Command']) {
            case "Stop":
              await audioHandler.stop();
              break;
            case "Pause":
              unawaited(audioHandler.pause());
              break;
            case "Unpause":
              unawaited(audioHandler.play());
              break;
            case "NextTrack":
              await audioHandler.skipToNext();
              break;
            case "PreviousTrack":
              await audioHandler.skipToPrevious();
              break;
            case "Seek":
              // val to = message.data?.seekPositionTicks?.ticks ?: Duration.ZERO
              final seekPosition = request['Data']['SeekPositionTicks'] != null
                  ? Duration(
                      milliseconds:
                          ((request['Data']['SeekPositionTicks'] as int) /
                                  10000)
                              .round())
                  : Duration.zero;
              await audioHandler.seek(seekPosition);
              final currentItem = queueService.getCurrentTrack();
              if (currentItem != null) {
                unawaited(playbackHistoryService.onPlaybackStateChanged(
                    currentItem, audioHandler.playbackState.value, null));
              }
              break;
            case "Rewind":
              await audioHandler.rewind();
              break;
            case "FastForward":
              await audioHandler.fastForward();
              break;
            case "PlayPause":
              audioHandler.togglePlayback();
              break;

            // Do nothing
            default:
              switch (request['Data']['PlayCommand']) {
                case 'PlayNow':
                  if (!(request['Data'].containsKey('StartIndex') as bool)) {
                    request['Data']['StartIndex'] = 0;
                  }
                  var items = await jellyfinApiHelper.getItems(
                    // sortBy: "IndexNumber", //!!! don't sort, use the sorting provided by the command!
                    includeItemTypes: "Audio",
                    itemIds:
                        List<BaseItemId>.from(request['Data']['ItemIds'] as List<dynamic>),
                  );
                  if (items!.isNotEmpty) {
                    //TODO check if all tracks in the request are in the upcoming queue (peekQueue). If they are, we should try to only reorder the upcoming queue instead of treating it as a new queue, and then skip to the correct index.
                    unawaited(queueService.startPlayback(
                      items: items,
                      source: QueueItemSource(
                        name: QueueItemSourceName(
                            type: QueueItemSourceNameType.preTranslated,
                            pretranslatedName: items[0].name),
                        type: QueueItemSourceType.track,
                        id: items[0].id,
                      ),
                       // seems like Jellyfin isn't always sending the correct index
                      startingIndex: request['Data']['StartIndex'] as int,
                    ));
                  } else {
                    _playOnHandlerLogger
                        .severe("Server asked to start an unplayable item");
                  }
                  break;
                case 'PlayNext':
                  var items = await jellyfinApiHelper.getItems(
                    sortBy: "IndexNumber",
                    includeItemTypes: "Audio",
                    itemIds:
                        List<BaseItemId>.from(request['Data']['ItemIds'] as List<dynamic>),
                  );
                  unawaited(queueService.addToNextUp(
                    items: items!,
                  ));
                  break;
                case 'PlayLast':
                  var items = await jellyfinApiHelper.getItems(
                    sortBy: "IndexNumber",
                    includeItemTypes: "Audio",
                    itemIds:
                        List<BaseItemId>.from(request['Data']['ItemIds'] as List<dynamic>),
                  );
                  unawaited(queueService.addToQueue(
                    items: items!,
                  ));
                  break;
              }
          }
          break;
      }
    }
  }
}
