import 'dart:async';
import 'dart:core';

import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/media_state_stream.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

Logger _rpcLogger = Logger("DiscordRPC");
var _running = false;
StreamSubscription<MediaState>? _listener;
RPCActivity? lastState;
RPCActivity? currentState;
Timer? _timer;
final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
BaseItemDto? artistItem;

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
    FlutterDiscordRPC.initialize("1397542416201945221");
    settingsListener.addListener(_reEvaluate);
    _reEvaluate();
    _rpcLogger.info("Initialized");
  }

  static void _reEvaluate() {
    final enabled = FinampSettingsHelper.finampSettings.rpcEnabled;
    final offline = FinampSettingsHelper.finampSettings.isOffline;
    (enabled && !offline) ? _start() : _stop();
  }

  static Future<void> _start() async {
    if (!_running) {
      _running = true;
      _rpcLogger.info("Starting RPC");
      await FlutterDiscordRPC.instance.connect(autoRetry: true);
      // updates the rpc regularly to fix potential desyncs, keeps conection alive and also to prevent ratelimits
      _timer = Timer.periodic(Duration(seconds: 5), (Timer time) {_updateRPC();});
      _startListener();
    }
  }

  static Future<void> _stop() async {
    if (_running) {
      _rpcLogger.info("Stopping RPC");
      _running = false;
      _timer?.cancel();
      _timer = null;
      await _listener?.cancel();
      await FlutterDiscordRPC.instance.clearActivity();
      await FlutterDiscordRPC.instance.disconnect();
      await FlutterDiscordRPC.instance.dispose();
    }
  }
  
  static Future<void> _updateRPC() async {
    if (!FlutterDiscordRPC.instance.isConnected) return;
    if (currentState == null) {
      // if (_isDuplicate(null)) return;
      _rpcLogger.finer("Update: Not playing anymore, clearing activity");
      await FlutterDiscordRPC.instance.clearActivity();
      lastState = currentState;
      return;
    }

    // if (_isDuplicate(currentState)) return;

    await FlutterDiscordRPC.instance.setActivity(activity: currentState!);
    lastState = currentState;

    _rpcLogger.finer("Updated");
  }

  // static bool _isDuplicate() {
  //   if (currentState == null) {
  //     bool alreadyNull = lastState == null;
  //     lastState = null;
  //     return alreadyNull;
  //   }
  //   if (lastState == null) {
  //     lastState = currentState;
  //     return false;
  //   }

  //   bool details = currentState!.details == lastState?.details;
  //   bool end = _inRange(currentState!.timestamps?.end, lastState?.timestamps?.end);
  //   bool start = _inRange(currentState!.timestamps?.start, lastState?.timestamps?.start);
  //   bool largeImage = currentState!.assets?.largeImage == lastState?.assets?.largeImage;
  //   bool smallImage = currentState!.assets?.smallImage == lastState?.assets?.smallImage;
  //   bool largeText = currentState!.assets?.largeText == lastState?.assets?.largeText;
  //   bool smallText = currentState!.assets?.smallText == lastState?.assets?.smallText;

  //   lastState = currentState;
  //   return details && end && start && largeImage && smallImage && largeText && smallText;
  // }


  static void _startListener() {
    _listener = mediaStateStream.listen((state) async {
      if (!state.playbackState.playing) {
        if (lastState != null) {
          currentState = null;
          await _updateRPC();
        };
        return;
      }

      final baseItem = BaseItemDto.fromJson(state.mediaItem!.extras!["itemJson"] as Map<String, dynamic>);
      if (artistItem == null || !baseItem.artists!.any((v) => v == artistItem?.name)) {
        artistItem = await _jellyfinApiHelper.getItemById(baseItem.artistItems!.first.id);
      }

      final now = (DateTime.now().millisecondsSinceEpoch / 1000).truncate();
      final progress = state.playbackState.position.inSeconds;
      final duration = state.mediaItem!.duration!.inSeconds;

      final start = now - progress;
      final end = now + (duration - progress);

      final title = state.mediaItem!.title;
      final artist = state.mediaItem!.artist;

      final smallImage = _jellyfinApiHelper.getImageUrl(item: artistItem!, maxHeight: 128, maxWidth: 128).toString();
      final largeImage = _jellyfinApiHelper.getImageUrl(item: baseItem, maxHeight: 128, maxWidth: 128).toString();

      final album = state.mediaItem!.album;

      final local = GetIt.instance<FinampUserHelper>().currentUser!.isLocal;

      currentState = RPCActivity(
        activityType: ActivityType.listening,
        details: title,
        state: artist,
        assets: RPCAssets(
          smallImage: local ? null : smallImage,
          smallText: local ? null : artist,
          largeImage: local ? "finamp" : largeImage,
          largeText: album == artist ? null : album
        ),
        timestamps: RPCTimestamps(start: start, end: end),
      );
    });
  }
}
