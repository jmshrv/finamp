import 'dart:async';

import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import '../../services/music_player_background_task.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/finamp_settings_helper.dart';
import 'dart:convert';
import 'finamp_user_helper.dart';

import 'package:get_it/get_it.dart';

final _playOnHandlerLogger = Logger("PlayOnHandler");


class PlayonHandler {

  Future<void> initialize() async {
    try {
      await startListener();
    } catch (e) {
      _playOnHandlerLogger.severe("Error initializing PlayOnHandler: $e");
    }
  }
  
  Future<void> startListener() async {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final queueService = GetIt.instance<QueueService>();
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

    await jellyfinApiHelper.updateCapabilities(ClientCapabilities(
      supportsMediaControl: true,
      supportsPersistentIdentifier: true,
      playableMediaTypes: ["Audio"],
      supportedCommands: ["MoveUp", "MoveDown", "MoveLeft", "MoveRight", "PageUp", "PageDown", "PreviousLetter", "NextLetter", "ToggleOsd", "ToggleContextMenu", "Select", "Back", "TakeScreenshot", "SendKey", "SendString", "GoHome", "GoToSettings", "VolumeUp", "VolumeDown", "Mute", "Unmute", "ToggleMute", "SetVolume", "SetAudioStreamIndex", "SetSubtitleStreamIndex", "ToggleFullscreen", "DisplayContent", "GoToSearch", "DisplayMessage", "SetRepeatMode", "ChannelUp", "ChannelDown", "Guide", "ToggleStats", "PlayMediaSource", "PlayTrailers", "SetShuffleQueue", "PlayState", "PlayNext", "ToggleOsdMenu", "Play", "SetMaxStreamingBitrate", "SetPlaybackOrder"],
    ));
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    final url="${finampUserHelper.currentUser!.baseUrl}/socket?api_key=${finampUserHelper.currentUser!.accessToken}";
    final parsedUrl = Uri.parse(url);
    final wsUrl = parsedUrl.replace(scheme: parsedUrl.scheme == "https" ? "wss" : "ws");
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;
    _playOnHandlerLogger.info("WebSocket connection to server established");

    channel.sink.add('{"MessageType":"KeepAlive"}');

    final keepaliveSubscription = Stream.periodic(const Duration(seconds: 30), (count) {
      return count;
    }).listen((event) {
      _playOnHandlerLogger.info("Sent KeepAlive message through websocket");
      channel.sink.add('{"MessageType":"KeepAlive"}');
    });


    channel.stream.handleError((error, trace) {
        _playOnHandlerLogger.severe("WebSocket Error: $error");
      },
    );

    await for (final value in channel.stream) {

      _playOnHandlerLogger.finest("Received message: $value");
      
      var request = jsonDecode(value);

      if (request['MessageType'] != 'ForceKeepAlive' && request['MessageType'] != 'KeepAlive') {
        _playOnHandlerLogger.info("Received a '${request['MessageType']}' message: ${request['Data']}");

        switch(request['MessageType']) {
          case "GeneralCommand":
            switch (request['Data']['Name']) {
              case "DisplayMessage":
                final messageFromServer = request['Data']['Arguments']['Text'];
                final header = request['Data']['Arguments']['Header'];
                final timeout = request['Data']['Arguments']['Timeout'];
                _playOnHandlerLogger.info("Displaying message from server: '$messageFromServer'");
                GlobalSnackbar.message((context) => "$header: $messageFromServer");
                break;
              case "SetVolume":
                final desiredVolume=request['Data']['Arguments']['Volume'];
                await FlutterVolumeController.setVolume(float.parse(desiredVolume)/100.0);
                // We now have to report to jellyfin server, probably through playback_history_service, that we updated volume
            }
            break;
          default:
            switch (request['Data']['Command']) {
              case "Stop":
                await audioHandler.stop();
                break;
              case "Pause":
                await audioHandler.pause();
                break;
              case "Unpause":
                await audioHandler.play();
                break;
              case "NextTrack":
                await audioHandler.skipToNext();
                break;
              case "PreviousTrack":
                await audioHandler.skipToPrevious();
                break;
              case "Seek":
                // val to = message.data?.seekPositionTicks?.ticks ?: Duration.ZERO
                final seekPosition = request['Data']['SeekPositionTicks'] != null ? Duration(milliseconds: ((request['Data']['SeekPositionTicks'] as int) / 10000).round()) : Duration.zero; 
                await audioHandler.seek(seekPosition);
                break;
              case "Rewind":
                await audioHandler.rewind();
                break;
              case "FastForward":
                await audioHandler.fastForward();
                break;
              case "PlayPause":
                await audioHandler.togglePlayback();
                break;

              // Do nothing
              default:
                switch (request['Data']['PlayCommand']) {
                  case 'PlayNow':
                    channel.sink.add('{"MessageType":"KeepAlive"}');
                    if (request['Data'].containsKey('StartIndex')) { // User started a single song
                      var item = await jellyfinApiHelper.getItemById(request['Data']['ItemIds'][request['Data']['StartIndex']]);
                      if (FinampSettingsHelper
                        .finampSettings.startInstantMixForIndividualTracks) {
                      unawaited(audioServiceHelper.startInstantMixForItem(item));
                      } else {
                        unawaited(queueService.startPlayback(
                          items: [item],
                          source: QueueItemSource(
                            name: QueueItemSourceName(
                                type: QueueItemSourceNameType.preTranslated,
                                pretranslatedName: item.name),
                            type: QueueItemSourceType.song,
                            id: item.id,
                          ),
                        ));
                      }
                    } else { // User asked to play an album
                      var items=<BaseItemDto>[];
                      for (final itemId in request['Data']['ItemIds']) {
                        items.add(await jellyfinApiHelper.getItemById(itemId));
                      }
                      unawaited(queueService.startPlayback(
                          items: items,
                          source: QueueItemSource(
                            name: QueueItemSourceName(
                                type: QueueItemSourceNameType.preTranslated,
                                pretranslatedName: items[0].name),
                            type: QueueItemSourceType.song,
                            id: items[0].id,
                          ),
                        ));
                    }
                    
                      
                }
              }
            break;
        }

        }

        // channel.sink.add('{"MessageType":"KeepAlive"}');
        
    }
  }
}
