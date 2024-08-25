import 'dart:async';

import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../services/music_player_background_task.dart';
import '../../services/jellyfin_api_helper.dart';
import 'dart:convert';
import 'finamp_user_helper.dart';

import 'package:get_it/get_it.dart';


class PlayonHandler {
  Future<void> startListener()  async {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    // final url="ws://192.168.1.30:8096/socket?api_key=${finampUserHelper.currentUser!.accessToken}&deviceId=AP2A.240705.005";  this should work but doesn't
    final url="ws://192.168.1.30:8096/socket?api_key=${finampUserHelper.currentUser!.accessToken}&deviceId=TW96aWxsYS81LjAgKFgxMTsgTGludXggeDg2XzY0OyBydjoxMjguMCkgR2Vja28vMjAxMDAxMDEgRmlyZWZveC8xMjguMHwxNzIyODczMDk3MDcy";
    final wsUrl = Uri.parse(url);
    final channel = WebSocketChannel.connect(wsUrl);
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final _queueService = GetIt.instance<QueueService>();

    await channel.ready;

    // Will need to send a Keepalive message every 30 seconds, the code below didn't work

    // final Stream _myStream =
    //     Stream.periodic(const Duration(seconds: 30), (int count) {
    //       channel.sink.add('{"MessageType":"KeepAlive"}');
    // });

    await for (final value in channel.stream) {
      var response = jsonDecode(value);

      if (response['MessageType'] != 'ForceKeepAlive' && response['MessageType'] != 'KeepAlive') {
        switch (response['Data']['PlayCommand']) {
          case 'PlayNow':
            channel.sink.add('{"MessageType":"KeepAlive"}');
            // print(response['Data']);
            // print(response['Data']['ItemIds']);
            var item = await _jellyfinApiHelper.getItemById(response['Data']['ItemIds'][0]);
            unawaited(_queueService.startPlayback(
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
      }

    }
  }
}