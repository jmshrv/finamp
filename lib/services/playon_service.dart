import 'dart:async';

import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
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

final _playOnServiceLogger = Logger("PlayOnService");
final _finampUserHelper = GetIt.instance<FinampUserHelper>();
final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
final _queueService = GetIt.instance<QueueService>();
final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
late WebSocketChannel _channel;
StreamSubscription<int>? _keepaliveSubscription;
StreamSubscription<int>? _reconnectionSubscription;
StreamSubscription<int>? _isControlledSubscription;

class PlayOnService {
  // If the websocket connection to the server is established
  bool isConnected = false;
  // If a remote client is controlling the session
  bool isControlled = false;

  Future<void> initialize() async {
    _playOnServiceLogger.info("Initializing PlayOn service");

    // Turn on/off when offline mode is toggled
    var settingsListener = FinampSettingsHelper.finampSettingsListener;
    settingsListener.addListener(() async {
      if (isConnected && FinampSettingsHelper.finampSettings.isOffline) {
        _playOnServiceLogger
            .info("Offline mode enabled, closing PlayOn listener now");
        await closeListener();
      } else if (!FinampSettingsHelper.finampSettings.enablePlayon) {
        if (isConnected) {
          await closeListener();
        }
      } else if (!isConnected &&
          FinampSettingsHelper.finampSettings.enablePlayon) {
        await startListener();
      }
    });

    //!!! not working, context is null during initialization
    // ProviderScope.containerOf(
    //         GlobalSnackbar.materialAppScaffoldKey.currentContext!)
    //     .listen(
    //         finampSettingsProvider.select((s) => (
    //               s.value?.isOffline ?? false,
    //               s.value?.enablePlayon ?? false
    //             )), (previous, next) async {
    //   final (isOffline, enablePlayon) = next;
    //   if (isConnected && isOffline) {
    //     _playOnServiceLogger
    //         .info("Offline mode enabled, closing PlayOn listener now");
    //     await closeListener();
    //   } else if (!enablePlayon) {
    //     await closeListener();
    //   } else if (!isConnected && enablePlayon) {
    //     await startListener();
    //   }
    // });

    // Sometimes we temporarily lose connection while the screen is locked.
    // Try reconnecting once again when the user begins interacting again, if still disconnected
    AppLifecycleListener(
        onRestart: () {},
        onHide: () {},
        onShow: () {
          if (!isConnected &&
              FinampSettingsHelper.finampSettings.enablePlayon) {
            _playOnServiceLogger.info(
                "App in foreground and visible, attempting to reconnect.");
            startReconnectionLoop();
          }
        },
        onPause: () {});

    await startListener();
  }

  Future<void> startListener() async {
    try {
      if (!FinampSettingsHelper.finampSettings.isOffline &&
          FinampSettingsHelper.finampSettings.enablePlayon) {
        await _jellyfinApiHelper.updateCapabilitiesFull(ClientCapabilities(
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
      await _reconnectionSubscription?.cancel();
      _reconnectionSubscription = null;
    } catch (e) {
      if (_reconnectionSubscription == null) {
        unawaited(startReconnectionLoop());
        _playOnServiceLogger.severe("Error starting PlayOn listener: $e");
      }
    }
  }

  Future<void> startReconnectionLoop() async {
    unawaited(_reconnectionSubscription?.cancel());
    _reconnectionSubscription = Stream.periodic(
        Duration(
            seconds: FinampSettingsHelper
                .finampSettings.playOnReconnectionDelay), (count) {
      return count;
    }).listen((count) {
      // We try to connect for five minutes before giving up
      if (count <
          (Duration(minutes: 5).inSeconds /
                  FinampSettingsHelper.finampSettings.playOnReconnectionDelay)
              .round()) {
        _playOnServiceLogger
            .warning("Attempt $count to restart playon listener");
        startListener();
      } else {
        _playOnServiceLogger.warning("Stopped attempting to connect playon");
        _reconnectionSubscription?.cancel();
      }
    });
  }

  Future<void> connectWebsocket() async {
    final url =
        "${_finampUserHelper.currentUser!.baseURL}/socket?api_key=${_finampUserHelper.currentUser!.accessToken}";
    final parsedUrl = Uri.parse(url);
    final wsUrl =
        parsedUrl.replace(scheme: parsedUrl.scheme == "https" ? "wss" : "ws");
    _channel = WebSocketChannel.connect(wsUrl);

    await _channel.ready;
    _playOnServiceLogger.info("WebSocket connection to server established");
    isConnected = true;

    _channel.sink.add('{"MessageType":"KeepAlive"}');

    _channel.stream.listen(
      (dynamic message) {
        unawaited(handleMessage(message));
      },
      onDone: () {
        _keepaliveSubscription?.cancel();
        isConnected = false;
        if (!FinampSettingsHelper.finampSettings.isOffline &&
            FinampSettingsHelper.finampSettings.enablePlayon) {
          _playOnServiceLogger
              .warning("WebSocket connection closed, attempting to reconnect");
          isConnected = false;
          startReconnectionLoop();
        }
      },
      onError: (error) {
        _playOnServiceLogger.severe("WebSocket Error: $error");
        isConnected = false;
      },
    );

    _keepaliveSubscription =
        Stream.periodic(const Duration(seconds: 30), (count) {
      return count;
    }).listen((event) {
      _playOnServiceLogger.info("Sent KeepAlive message through websocket");
      _channel.sink.add('{"MessageType":"KeepAlive"}');
    });
  }

  Future<void> closeListener() async {
    _playOnServiceLogger.info("Closing playon session");
    _channel.sink.add('{"MessageType":"SessionsStop"}');
    unawaited(_channel.sink.close());
    unawaited(_keepaliveSubscription?.cancel());
    isConnected = false;

    // In case offline mod is turned on while attempting to reconnect
    unawaited(_reconnectionSubscription?.cancel());
    _reconnectionSubscription = null;
  }

  Future<void> handleMessage(dynamic value) async {
    try {
      _playOnServiceLogger.finest("Received message: $value");

      var request = jsonDecode(value as String);

      if (request['MessageType'] != 'ForceKeepAlive' &&
          request['MessageType'] != 'KeepAlive') {
        // Because the Jellyfin server doesn't notify remote client connection/disconnection,
        // we mark the remote controlling as stale after 5 minutes without input as a workaround.
        // This is particularly useful to stop agressively reporting playback when it's not needed
        await _isControlledSubscription?.cancel();
        isControlled = true;
        _isControlledSubscription = Stream.periodic(
            Duration(
                seconds: FinampSettingsHelper.finampSettings.playOnStaleDelay),
            (count) {
          return count;
        }).listen((event) {
          _playOnServiceLogger.info("Mark remote controlling as stale");
          isControlled = false;
          _isControlledSubscription?.cancel();
        });

        switch (request['MessageType']) {
          case "GeneralCommand":
            switch (request['Data']['Name']) {
              case "DisplayMessage":
                final messageFromServer = request['Data']['Arguments']['Text'];
                final header = request['Data']['Arguments']['Header'];
                final timeout = request['Data']['Arguments']['Timeout'];
                _playOnServiceLogger.info(
                    "Displaying message from server: '$messageFromServer'");
                GlobalSnackbar.message(
                    (context) => "$header: $messageFromServer");
                break;
              case "SetVolume":
                _playOnServiceLogger
                    .info("Server requested a volume adjustment");

                final desiredVolume =
                    request['Data']['Arguments']['Volume'] as String;
                _audioHandler.setVolume(double.parse(desiredVolume) / 100.0);
            }
            break;
          case "UserDataChanged":
            var item = await _jellyfinApiHelper.getItemById(BaseItemId(
                request['Data']['UserDataList'][0]['ItemId'] as String));

            // Handle toggling favorite status from remote client
            _playOnServiceLogger.info("Updating favorite ui state");
            ProviderScope.containerOf(
                    GlobalSnackbar.materialAppScaffoldKey.currentContext!,
                    listen: false)
                .read(isFavoriteProvider(item).notifier)
                .updateState(item.userData!.isFavorite);
            break;
          default:
            switch (request['Data']['Command']) {
              case "Stop":
                await _audioHandler.stop();
                break;
              case "Pause":
                await _audioHandler.pause();
                break;
              case "Unpause":
                await _audioHandler.play();
                break;
              case "NextTrack":
                await _audioHandler.skipToNext();
                break;
              case "PreviousTrack":
                await _audioHandler.skipToPrevious();
                break;
              case "Seek":
                // val to = message.data?.seekPositionTicks?.ticks ?: Duration.ZERO
                final seekPosition =
                    request['Data']['SeekPositionTicks'] != null
                        ? Duration(
                            milliseconds:
                                ((request['Data']['SeekPositionTicks'] as int) /
                                        10000)
                                    .round())
                        : Duration.zero;
                await _audioHandler.seek(seekPosition);
                final currentItem = _queueService.getCurrentTrack();
                break;
              case "Rewind":
                await _audioHandler.rewind();
                break;
              case "FastForward":
                await _audioHandler.fastForward();
                break;
              case "PlayPause":
                await _audioHandler.togglePlayback();
                break;

              // Do nothing
              default:
                switch (request['Data']['PlayCommand']) {
                  case 'PlayNow':
                    if (!(request['Data'].containsKey('StartIndex') as bool)) {
                      request['Data']['StartIndex'] = 0;
                    }
                    var items = await _jellyfinApiHelper.getItems(
                      // sortBy: "IndexNumber", //!!! don't sort, use the sorting provided by the command!
                      includeItemTypes: "Audio",
                      itemIds: List<BaseItemId>.from(
                              request['Data']['ItemIds'] as List<dynamic>)
                          // limit amount of requested tracks. Jellyfin sometimes sends more item IDs than the GET request can handle in the query string
                          .take(200)
                          .toList(),
                    );
                    if (items!.isNotEmpty) {
                      //TODO check if all tracks in the request are in the upcoming queue (peekQueue). If they are, we should try to only reorder the upcoming queue instead of treating it as a new queue, and then skip to the correct index.
                      unawaited(_queueService.startPlayback(
                        items: items,
                        source: QueueItemSource(
                          name: QueueItemSourceName(
                            type: QueueItemSourceNameType.remoteClient,
                          ),
                          type: QueueItemSourceType.remoteClient,
                          id: items[0].id,
                        ),
                        // seems like Jellyfin isn't always sending the correct index
                        startingIndex: request['Data']['StartIndex'] as int,
                      ));
                    } else {
                      _playOnServiceLogger
                          .severe("Server asked to start an unplayable item");
                    }
                    break;
                  case 'PlayNext':
                    var items = await _jellyfinApiHelper.getItems(
                      sortBy:
                          "IndexNumber", //!!! don't sort, use the sorting provided by the command!
                      includeItemTypes: "Audio",
                      itemIds: List<BaseItemId>.from(
                              request['Data']['ItemIds'] as List<dynamic>)
                          // limit amount of requested tracks. Jellyfin sometimes sends more item IDs than the GET request can handle in the query string
                          .take(200)
                          .toList(),
                    );
                    unawaited(_queueService.addToNextUp(
                      items: items!,
                    ));
                    break;
                  case 'PlayLast':
                    var items = await _jellyfinApiHelper.getItems(
                      sortBy:
                          "IndexNumber", //!!! don't sort, use the sorting provided by the command!
                      includeItemTypes: "Audio",
                      itemIds: List<BaseItemId>.from(
                              request['Data']['ItemIds'] as List<dynamic>)
                          // limit amount of requested tracks. Jellyfin sometimes sends more item IDs than the GET request can handle in the query string
                          .take(200)
                          .toList(),
                    );
                    unawaited(_queueService.addToQueue(
                      items: items!,
                    ));
                    break;
                }
            }
            break;
        }
      }
    } catch (e) {
      _playOnServiceLogger.severe("Error handling message: $e");
    }
  }
}
