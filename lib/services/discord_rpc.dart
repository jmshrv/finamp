import 'dart:async';
import 'dart:core';

import 'package:finamp/services/media_state_stream.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
part 'discord_rpc.g.dart';

var running = false;
StreamSubscription<MediaState>? listener;

@riverpod
class DiscordRpc extends _$DiscordRpc {
  @override
  bool build() {
    bool enabled = true;
    return enabled;
  }

  static void startWatching() async {
    ProviderContainer container = GetIt.instance<ProviderContainer>();
    container.listen(discordRpcProvider, (_, enabled) {
      enabled ? DiscordRpc.start() : DiscordRpc.stop(); 
    });
  }

  static Future<void> start() async {
    if (!running) {
      running = true;
      await FlutterDiscordRPC.initialize("1363567299948314906");
      await FlutterDiscordRPC.instance.connect(autoRetry: true);
      startListener();
    }
  }

  static Future<void> stop() async {
    if (running) {
      running = false;
      await listener?.cancel();
      await FlutterDiscordRPC.instance.clearActivity();
      await FlutterDiscordRPC.instance.disconnect();
      await FlutterDiscordRPC.instance.dispose();
    }
  }

  static void startListener() {
    listener = mediaStateStream.listen((state) {
      
      if (!state.playbackState.playing) {
        FlutterDiscordRPC.instance.setActivity(activity: RPCActivity(
          activityType: ActivityType.listening,
          timestamps: RPCTimestamps(
            start: 0,
            end: 0
          )
        ));

        return;
      }


      final current = (DateTime.now().millisecondsSinceEpoch / 1000).truncate();
      final progress = state.playbackState.position.inSeconds;
      final duration = state.mediaItem!.duration!.inSeconds;

      final start = current - progress;
      final end = current + (duration - progress);


      FlutterDiscordRPC.instance.setActivity(activity: RPCActivity(
        activityType: ActivityType.listening,
        timestamps: RPCTimestamps(
          start: start,
          end: end
        )
      ));

    });
  }

}
