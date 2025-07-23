import 'dart:async';
import 'dart:core';

import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/media_state_stream.dart';
import 'package:finamp/services/music_player_background_task.dart';

import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

Logger _rpcLogger = Logger("DiscordRPC");
RPCActivity? lastState;
Timer? _timer;
final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
BaseItemDto? artistItem;
enum _RpcStatus {
    running,
    starting,
    stopped,
    stopping
}
_RpcStatus status = _RpcStatus.stopped;

class DiscordRpc {
  static void initialize() {
    var settingsListener = FinampSettingsHelper.finampSettingsListener;
    // Chaphasilor owns the Discord App in case of any issues with that :)
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
    if (status == _RpcStatus.stopped) {
      status = _RpcStatus.starting;
      _rpcLogger.info("Starting RPC");
      await FlutterDiscordRPC.instance.connect(autoRetry: true);
      _rpcLogger.info("Connected");
      // updates the rpc regularly to fix potential desyncs, keeps conection alive and also to prevent ratelimits
      _timer = Timer.periodic(Duration(seconds: 5), (Timer time) {
        _updateRPC();
      });
      status = _RpcStatus.running;
    }
    if (status == _RpcStatus.stopping) {
      await Future.delayed(const Duration(seconds: 1), _start);
    }
  }

  static Future<void> _stop() async {
    if (status == _RpcStatus.running) {
      status = _RpcStatus.stopping;
      _timer?.cancel();
      _timer = null;
      artistItem = null;
      await FlutterDiscordRPC.instance.clearActivity();
      await FlutterDiscordRPC.instance.disconnect();
      await FlutterDiscordRPC.instance.dispose();
      status = _RpcStatus.stopping;
      _rpcLogger.info("Stopped RPC");
    }
    if (status == _RpcStatus.starting) {
      await Future.delayed(const Duration(seconds: 1), _stop);
    }
  }

  static Future<void> _updateRPC() async {
    if (!FlutterDiscordRPC.instance.isConnected) return;

    RPCActivity? currentState = await _render();

    if (currentState == null) {
      if (lastState != null) {
        _rpcLogger.finer("Update: Not playing anymore, clearing activity");
        await FlutterDiscordRPC.instance.clearActivity();
        lastState = currentState;
      }
      return;
    }

    await FlutterDiscordRPC.instance.setActivity(activity: currentState);
    lastState = currentState;

    _rpcLogger.finest("Updated");
  }

  static Future<RPCActivity?> _render() async {
    final state = GetIt.instance<MusicPlayerBackgroundTask>();
    final playbackState = state.playbackState.valueOrNull;
    final mediaItem = state.mediaItem.valueOrNull;

    if (playbackState?.playing == null || !playbackState!.playing) {
      return null;
    }

    final baseItem = BaseItemDto.fromJson(mediaItem!.extras!["itemJson"] as Map<String, dynamic>);
    if (artistItem == null || !baseItem.artists!.any((v) => v == artistItem?.name)) {
      artistItem = await _jellyfinApiHelper.getItemById(baseItem.artistItems!.first.id);
    }

    final now = (DateTime.now().millisecondsSinceEpoch / 1000).truncate();
    final progress = playbackState.position.inSeconds;
    final duration = mediaItem.duration!.inSeconds;

    final start = now - progress;
    final end = now + (duration - progress);

    final title = mediaItem.title;
    final artist = mediaItem.artist;

    final local = GetIt.instance<FinampUserHelper>().currentUser!.isLocal;
    final smallImage = local
        ? null
        : _jellyfinApiHelper.getImageUrl(item: artistItem!, maxHeight: 128, maxWidth: 128).toString();
    final largeImage = local
        ? "finamp"
        : _jellyfinApiHelper.getImageUrl(item: baseItem, maxHeight: 128, maxWidth: 128).toString();

    final album = mediaItem.album;

    return RPCActivity(
      activityType: ActivityType.listening,
      details: title,
      state: artist,
      assets: RPCAssets(
        smallImage: smallImage,
        smallText: local ? null : artist,
        largeImage: largeImage,
        largeText: album == artist ? null : album,
      ),
      timestamps: RPCTimestamps(start: start, end: end),
    );
  }
}
