import 'dart:async';
import 'dart:core';

import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/media_state_stream.dart';

import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
import 'package:logging/logging.dart';


Logger _rpcLogger = Logger("DiscordRPC");
var _running = false;
StreamSubscription<MediaState>? _listener;
RPCActivity? lastState;

bool _inRange(int? a, int? b) {
  int range = 2;
  if (b == null || a == null) return false;

  var min = a - range;
  var max = a + range;

  return b < max && b > min;
}

class DiscordRpc {
  static void initialize() {
    var settingsListener = FinampSettingsHelper.finampSettingsListener;
    settingsListener.addListener(reEvaluate);
    reEvaluate();
    _rpcLogger.info("Initialized");
  }

  static void reEvaluate() {
    FinampSettingsHelper.finampSettings.rpcEnabled ? start() : stop();
  }

  static Future<void> start() async {
    if (!_running) {
      _rpcLogger.info("Starting RPC");
      _running = true;
      await FlutterDiscordRPC.initialize("1363567299948314906");
      await FlutterDiscordRPC.instance.connect(autoRetry: true);
      startListener();
    } else {
      _rpcLogger.info("Attempted to Start RPC even though its already running");
    }
  }

  static Future<void> stop() async {
    if (_running) {
      _rpcLogger.info("Stopping RPC");
      _running = false;
      await stopListener();
      await FlutterDiscordRPC.instance.clearActivity();
      await FlutterDiscordRPC.instance.disconnect();
      await FlutterDiscordRPC.instance.dispose();
    } else {
      _rpcLogger.info("Attempted to Stop RPC even though its already stopped");
    }
  }

  static Future<void> stopListener( ) async {
    await _listener?.cancel();
  }


  static bool isDuplicate(RPCActivity? state) {
    if (state == null) {
      bool alreadyNull = lastState == null;
      lastState = null;
      return alreadyNull;
    }
    if (lastState == null) {
      lastState = state;
      return false;
    };

    bool details = state.details == lastState?.details;
    bool end = _inRange(state.timestamps?.end, lastState?.timestamps?.end);
    bool start = _inRange(state.timestamps?.start, lastState?.timestamps?.start);
    
    lastState = state;
    return details && end && start;
  }

  static void startListener() {
    _listener = mediaStateStream.listen((state) async {
      if (!state.playbackState.playing) {
        if (isDuplicate(null)) return;
        _rpcLogger.info("Update: Not playing anymore, clearing activity");
        await FlutterDiscordRPC.instance.clearActivity();
        return;
      }



      final now = (DateTime.now().millisecondsSinceEpoch / 1000).truncate();
      final progress = state.playbackState.position.inSeconds;
      final duration = state.mediaItem!.duration!.inSeconds;
      final start = now - progress;
      final end = now + (duration - progress);

      final details = state.mediaItem!.title;
      final state2 = state.mediaItem!.artist;



      RPCActivity rpc = RPCActivity(
        activityType: ActivityType.listening,
        details: details,
        state: state2,
        timestamps: RPCTimestamps(
          start: start,
          end: end
        )
      );

      if (isDuplicate(rpc)) return;
      _rpcLogger.info("Update: start=$start end=$end details=$details state=$state2");
      await FlutterDiscordRPC.instance.setActivity(activity: rpc);
    });
  }

}
