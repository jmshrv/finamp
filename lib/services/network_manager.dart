import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/playon_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/finamp_models.dart';
import 'finamp_settings_helper.dart';

part 'network_manager.g.dart';

Logger _networkAutomationLogger = Logger("Network Automation");
Logger _autoOfflineLogger = Logger("Auto Offline");
Logger _networKSwitcherLogger = Logger("Network Switcher");

int activeDelayCounter = 0;
/// This stream receives update when autoOffline enters/exists the 7 second confirmation/validation timeout
final autoOfflineStatusStream = StreamController<int>.broadcast();
final autoOfflineStatusProvider = StreamProvider((ref) async* {
  await for (final value in autoOfflineStatusStream.stream) {
    yield value;
  }
}).select((v) => v.valueOrNull ?? 0);


final StreamSubscription<List<ConnectivityResult>> _listener =
    Connectivity().onConnectivityChanged.listen(_onConnectivityChange);

@riverpod
class AutoOffline extends _$AutoOffline {
  static void startWatching() {
    GetIt.instance<ProviderContainer>().listen(autoOfflineProvider,
        (_, newState) {
      if (newState) {
        _networkAutomationLogger.info("Resumed Automation");
        _listener.resume();
        // directly check if offline mode should be on
        _onConnectivityChange(null);
      } else {
        _networkAutomationLogger.info("Paused Automation");
        _listener.pause();
      }
    });

    AppLifecycleListener(onRestart: () {
      if (GetIt.instance<ProviderContainer>().read(autoOfflineProvider)) {
        _autoOfflineLogger.finer("Lifecycle restarted automation");
        _listener.resume();
      } else {
        _autoOfflineLogger.finer("Lifecycle kept automation paused");
      }
    }, onPause: () {
      _listener.pause();
      _autoOfflineLogger.finer("Lifecycle paused automation");
    });
  }

  @override
  bool build() {
    bool autoOfflineEnabled = ref.watch(finampSettingsProvider.autoOffline) !=
        AutoOfflineOption.disabled;

    // false = user overwrote offline mode
    bool autoOfflineActive =
        ref.watch(finampSettingsProvider.autoOfflineListenerActive);

    bool autoServerSwitch = ref
            .watch(FinampUserHelper.finampCurrentUserProvider)
            .valueOrNull
            ?.preferHomeNetwork ??
        DefaultSettings.preferHomeNetwork;

    return (autoOfflineEnabled && autoOfflineActive) || autoServerSwitch;
  }
}

Future<void> _onConnectivityChange(
    List<ConnectivityResult>? connections) async {
  _networkAutomationLogger.finest(
      "Network Change: ${connections?.map((element) => element.toString()).join(", ") ?? "None (likely a manual function call)"}");
  connections ??= await Connectivity().checkConnectivity();
  final [offlineModeActive, baseUrlChanged] = await Future.wait([
    _setOfflineMode(connections),
    changeTargetUrl(),
  ]);
  _notifyOfPausedDownloads(connections);
  if (baseUrlChanged) {
    _reconnectPlayOnService(connections);
  }
}

/// Sets the offline mode based on the current connectivity and user settings
Future<bool> _setOfflineMode(List<ConnectivityResult> connections) async {
  // skip when feature not enabled
  if (FinampSettingsHelper.finampSettings.autoOffline ==
          AutoOfflineOption.disabled ||
      !FinampSettingsHelper.finampSettings.autoOfflineListenerActive) {
    return FinampSettingsHelper.finampSettings.isOffline;
  }

  bool state1 = _shouldBeOffline(connections);

  // this prevents an issue on ios (and mac?) where the
  // listener gets called even though it shouldnt.
  // The wait also acts as an timeout so offline mode is less
  // likely to engage when it doesnt need to and this helps
  // with queue reloading
  autoOfflineStatusStream.add(++activeDelayCounter);
  await Future.delayed(Duration(seconds: 7), () => {});
  autoOfflineStatusStream.add(--activeDelayCounter);
  bool state2 = _shouldBeOffline(await Connectivity().checkConnectivity());

  // skip if we are already in the target offline state, or the auto switch was disabled
  // while we waited out intermittent changes.  Also skip if the connection status changed
  // during the waiting period, because we aren't sure which is better to use.  There should be
  // another copy of this function triggered by the mid-wait switch which will handle
  // if the final state is stable.
  if (state1 != state2 ||
      FinampSettingsHelper.finampSettings.isOffline == state2 ||
      FinampSettingsHelper.finampSettings.autoOffline ==
          AutoOfflineOption.disabled ||
      !FinampSettingsHelper.finampSettings.autoOfflineListenerActive) {
    return FinampSettingsHelper.finampSettings.isOffline;
  }

  GlobalSnackbar.message((context) => AppLocalizations.of(context)!
      .autoOfflineNotification(state2 ? "enabled" : "disabled"));

  _autoOfflineLogger
      .info("Automatically ${state2 ? "Enabled" : "Disabled"} Offline Mode");

  FinampSetters.setIsOffline(state2);
  return state2;
}

bool _shouldBeOffline(List<ConnectivityResult> connections) {
  switch (FinampSettingsHelper.finampSettings.autoOffline) {
    case AutoOfflineOption.disconnected:
      return !connections.contains(ConnectivityResult.mobile) &&
          !connections.contains(ConnectivityResult.ethernet) &&
          !connections.contains(ConnectivityResult.wifi);
    case AutoOfflineOption.network:
      return !connections.contains(ConnectivityResult.ethernet) &&
          !connections.contains(ConnectivityResult.wifi);
    default:
      return false;
  }
}

Future<bool> changeTargetUrl({bool? isLocal}) async {
  FinampUser? user = GetIt.instance<FinampUserHelper>().currentUser;
  if (user == null) return false;

  if (isLocal != null && isLocal != user.isLocal) {
    _networKSwitcherLogger.info(
        "Changed active network to ${isLocal ? "home" : "public"} address");
    GetIt.instance<FinampUserHelper>().currentUser?.update(newIsLocal: isLocal);
    return true;
  }
  // this avoids an infinite loop... again :)
  if (isLocal != null) {
    return false;
  }

  // Disable this feature
  if (!user.preferHomeNetwork) return changeTargetUrl(isLocal: false);

  bool reachable = await GetIt.instance<JellyfinApiHelper>().pingLocalServer();
  return await changeTargetUrl(isLocal: reachable);
}

int _getDownloads() {
  final downloadsService = GetIt.instance<DownloadsService>();
  downloadsService.updateDownloadCounts();

  final nodesSyncing = downloadsService.downloadCounts["sync"]!;
  final downloadingEnqueued =
      downloadsService.downloadStatuses[DownloadItemState.enqueued]!;
  final downloadingRunning =
      downloadsService.downloadStatuses[DownloadItemState.downloading]!;

  final activeDownloads =
      nodesSyncing + downloadingEnqueued + downloadingRunning;
  return activeDownloads;
}

void _notifyOfPausedDownloads(List<ConnectivityResult> connections) async {
  if (connections.contains(ConnectivityResult.none)) {
    if (_getDownloads() == 0) return;
    GlobalSnackbar.message(
        (context) => AppLocalizations.of(context)!.downloadPaused);
    return;
  }

  // desktop doesn't have this setting
  if (!(Platform.isAndroid || Platform.isIOS)) return;

  if (FinampSettingsHelper.finampSettings.requireWifiForDownloads) {
    final connectedToWifi = connections.contains(ConnectivityResult.wifi);
    if (connectedToWifi) return;

    if (_getDownloads() == 0) return;

    GlobalSnackbar.message(
        (context) => AppLocalizations.of(context)!.downloadPaused);
  }
}

void _reconnectPlayOnService(List<ConnectivityResult> connections) async {
  final playOnService = GetIt.instance<PlayOnService>();

  playOnService.closeListener();
  if (!connections.contains(ConnectivityResult.none)) {
    await playOnService.startListener();
  }
}
