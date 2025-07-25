import 'dart:async';
import 'dart:core';

import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

Logger _rpcLogger = Logger("DiscordRPC");
bool lastState = false;
Timer? _timer;
final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
final _finampUserHelper = GetIt.instance<FinampUserHelper>();
BaseItemDto? artistItem;

enum _RpcStatus { running, transition, stopped }

_RpcStatus _status = _RpcStatus.stopped;
_RpcStatus _targetStatus = _RpcStatus.stopped;

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
    (enabled && !offline) ? start() : stop();
  }

  static Future<void> start() async {
    _targetStatus = _RpcStatus.running;
    if (_status == _RpcStatus.stopped) {
      _status = _RpcStatus.transition;
      _rpcLogger.info("Starting RPC");

      await FlutterDiscordRPC.instance.connect(autoRetry: true, retryDelay: Duration(seconds: 20));
      await FlutterDiscordRPC.instance.clearActivity();

      _rpcLogger.info("Connected");

      // updates the rpc regularly to fix potential desyncs, keeps connection alive and also to prevent ratelimiting
      // From my research the most mentioned ratelimit is 15 seconds (though inconsistently? a lot of the time rpc can be updated faster, just not all the time)
      // One of the repos which mention 15 seconds is this one: https://github.com/dhinakg/vm-rpc
      // I couldn't find any official ratelimit regarding RPC :/
      _timer = Timer.periodic(Duration(seconds: 15), _updateRPC);
      _status = _RpcStatus.running;

      if (_targetStatus == _RpcStatus.stopped) stop();
    }
  }

  static Future<void> stop() async {
    _targetStatus = _RpcStatus.stopped;
    if (_status == _RpcStatus.running) {
      _status = _RpcStatus.transition;
      _timer?.cancel();
      _timer = null;
      artistItem = null;

      await FlutterDiscordRPC.instance.clearActivity();
      await FlutterDiscordRPC.instance.disconnect();
      await FlutterDiscordRPC.instance.dispose();

      _status = _RpcStatus.stopped;
      _rpcLogger.info("Stopped RPC");

      if (_targetStatus == _RpcStatus.running) start();
    }
  }

  static Future<void> _updateRPC(Timer _) async {
    if (!FlutterDiscordRPC.instance.isConnected) return;
    RPCActivity? currentState;
    try {
      currentState = await _render();
    } catch (e) {
      _rpcLogger.warning("Something went wrong during RPC rendering", e);
      return;
    }

    if (currentState == null) {
      if (lastState) {
        _rpcLogger.finer("Not playing anymore, clearing activity");
        await FlutterDiscordRPC.instance.clearActivity();
        lastState = false;
      }
      return;
    }

    await FlutterDiscordRPC.instance.setActivity(activity: currentState);
    lastState = true;

    _rpcLogger.finest("Updated");
  }

  /// Known limitations:
  /// - doesnt match something like `jellyfin:8096`
  /// - may not work on custom DNS
  /// - may not work for selfhosted VPNs depending on configuration
  ///
  /// Only Matches:
  ///
  /// *Note: `.X` values **ARENT** validated.*
  ///
  /// - `127.X.X.X`
  /// - `172.16.X.X` - `172.19.X.X` - `172.20.X.X` - `172.29.X.X` - `172.30.X.X` - `172.31.X.X`
  /// - `192.168.X.X`
  static bool isAddressInLocalAddressRange(String address) {
    // regex from https://stackoverflow.com/a/2814102
    final regex = RegExp(r"(^127\.)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)");
    final host = Uri.parse(address).host;
    return regex.hasMatch(host);
  }

  static (String?, String) _fetchImageUrls(BaseItemDto baseItem) {
    String? smallImage;
    String largeImage = FinampSettingsHelper.finampSettings.rpcIcon.toString();

    final activeAddress = _finampUserHelper.currentUser!.baseURL;
    final activeAddressIsPrivate = isAddressInLocalAddressRange(activeAddress);

    bool forcePublicAddress = false;
    bool skipUrlGetting = false;

    if (activeAddressIsPrivate) {
      final publicAddress = _finampUserHelper.currentUser!.publicAddress;
      final publicAddressIsPrivate = isAddressInLocalAddressRange(publicAddress);
      forcePublicAddress = true;
      skipUrlGetting = publicAddressIsPrivate;
    }
    if (!skipUrlGetting) {
      smallImage = _jellyfinApiHelper
          .getImageUrl(item: artistItem!, maxHeight: 128, maxWidth: 128, forcePublicAddress: forcePublicAddress)
          .toString();
      largeImage = _jellyfinApiHelper
          .getImageUrl(item: baseItem, maxHeight: 128, maxWidth: 128, forcePublicAddress: forcePublicAddress)
          .toString();
    }

    return (smallImage, largeImage);
  }

  static Future<RPCActivity?> _render() async {
    final state = GetIt.instance<MusicPlayerBackgroundTask>();
    final playbackState = state.playbackState.valueOrNull;
    final mediaItem = state.mediaItem.valueOrNull;

    if (playbackState?.playing == null || !playbackState!.playing) {
      return null;
    }

    final baseItem = BaseItemDto.fromJson(mediaItem!.extras!["itemJson"] as Map<String, dynamic>);

    if (artistItem == null || !baseItem.artistItems!.any((v) => v.id == artistItem?.id)) {
      artistItem = await _jellyfinApiHelper.getItemById(baseItem.artistItems!.first.id);
    }

    final now = (DateTime.now().millisecondsSinceEpoch / 1000).truncate();
    final progress = playbackState.position.inSeconds;
    final duration = mediaItem.duration!.inSeconds;

    final images = _fetchImageUrls(baseItem);
    final start = now - progress;
    final end = now + (duration - progress);
    final title = mediaItem.title;
    final artist = mediaItem.artist;
    final album = mediaItem.album;

    return RPCActivity(
      activityType: ActivityType.listening,
      details: title,
      state: artist,
      assets: RPCAssets(
        smallImage: images.$1,
        smallText: images.$1 == null ? null : artist,
        largeImage: images.$2,
        largeText: (album == artist || album == title) ? null : album,
      ),
      timestamps: RPCTimestamps(start: start, end: end),
    );
  }
}
