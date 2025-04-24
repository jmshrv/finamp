import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/finamp_models.dart';
import 'finamp_settings_helper.dart';
import 'package:network_info_plus/network_info_plus.dart';
part 'network_manager.g.dart';

// this is to avoid an infinite loop.
// `finampCurrentUserProvider` fires for every change on the object
// including when changing the baseURL. So basically this happens:
// urlChange -> Update -> reload listener -> urlChange -> Update -> ...
bool? _lastState;

Logger _networkAutomationLogger = Logger("Network Automation");
Logger _autoOfflineLogger = Logger("Auto Offline");
Logger _networKSwitcherLogger = Logger("Network Switcher"); 

final StreamSubscription<List<ConnectivityResult>> _listener = Connectivity()
    .onConnectivityChanged
    .listen(_onConnectivityChange);

@riverpod
class AutoOffline extends _$AutoOffline {
  @override
  void build() {

    bool autoOfflineEnabled = ref.watch(finampSettingsProvider.autoOffline) !=
        AutoOfflineOption.disabled;

    // false = user overwrote offline mode
    bool autoOfflineActive =
        ref.watch(finampSettingsProvider.autoOfflineListenerActive);

    bool autoServerSwitch =
        ref.watch(FinampUserHelper.finampCurrentUserProvider).valueOrNull?.preferHomeNetwork ?? DefaultSettings.preferHomeNetwork;

    bool state = (autoOfflineEnabled && autoOfflineActive) || autoServerSwitch;

    // Avoid infinite loop as described above
    if (state != _lastState) {
      if (state) {
        _networkAutomationLogger.info("Resumed Automation");
        _listener.resume();
        // directly check if offline mode should be on
        _onConnectivityChange(null);
      } else {
        _networkAutomationLogger.info("Paused Automation");
        _listener.pause();
      }
    }

    _lastState = state;
  }
}

Future<void> _onConnectivityChange(List<ConnectivityResult>? connections) async {
  _networkAutomationLogger.finest("Network Change: ${
    connections?.map((element) => element.toString()).join(", ") ?? "None (likely a manual function call)"}");
  connections ??= await Connectivity().checkConnectivity();
  await Future.wait([
    _setOfflineMode(connections),
    changeTargetUrl(),
  ]);
  notifyOfPausedDownloads(connections);
}

Future<void> _setOfflineMode(List<ConnectivityResult> connections) async {
  // skip when feature not enabled
  if (FinampSettingsHelper.finampSettings.autoOffline ==
      AutoOfflineOption.disabled) return;
  // skip when user overwrote offline mode
  if (!FinampSettingsHelper.finampSettings.autoOfflineListenerActive) return;

  bool state = _shouldBeOffline(connections);

  // Attempt to combat IOS reliability problems
  if (Platform.isIOS) {
    await Future.delayed(Duration(seconds: 7), () => {});
    state = _shouldBeOffline(await Connectivity().checkConnectivity());
  }

  // skip if nothing changed
  if (FinampSettingsHelper.finampSettings.isOffline == state) return;

  GlobalSnackbar.message((context) => AppLocalizations.of(context)!
      .autoOfflineNotification(state ? "enabled" : "disabled"));

  _autoOfflineLogger.info("Automatically ${state ? "Enabled" : "Disabled"} Offline Mode");

  FinampSetters.setIsOffline(state);
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

Future<void> changeTargetUrl({bool? isLocal}) async {
  FinampUser? user = GetIt.instance<FinampUserHelper>().currentUser;
  if (user == null) return;

  if (isLocal != null && isLocal != user.isLocal) {
    _networKSwitcherLogger.info("Changed active network to ${isLocal ? "home" : "public"} address");
    GetIt.instance<FinampUserHelper>()
      .currentUser
      ?.update(newIsLocal: isLocal);
    return;
  }
  // this avoids an infinite loop... again :)
  if (isLocal != null) {return;}

  // Disable this feature
  if (!user.preferHomeNetwork) return changeTargetUrl(isLocal: false);

  // Avoid Further Calculation when no network name is set
  String targetWifi = user.homeNetworkName;
  if (targetWifi.isEmpty) return changeTargetUrl(isLocal: false);

  String? currentWifi = await NetworkInfo().getWifiName();
  if (currentWifi == null) return changeTargetUrl(isLocal: false);

  // Android returns wifi name with quotes
  currentWifi = currentWifi.replaceAll("\"", "");
  _networkAutomationLogger.finest("Wifi Name detected: $currentWifi");

  await changeTargetUrl(isLocal: currentWifi == targetWifi);
}

int _getDownloads() {
    final downloadsService = GetIt.instance<DownloadsService>();
    downloadsService.updateDownloadCounts();

    final downloadingTracks = downloadsService.downloadCounts["track"]!;
    final downloadingImage = downloadsService.downloadCounts["image"]!;
    final downloadingSyncs = downloadsService.downloadCounts["sync"]!;

    final downloads = downloadingTracks + downloadingImage + downloadingSyncs;
    return downloads;
}

void notifyOfPausedDownloads(List<ConnectivityResult> connections) async {
  if (connections.contains(ConnectivityResult.none)) {
    if (_getDownloads() == 0) return;
    GlobalSnackbar.message((context) => AppLocalizations.of(context)!.downloadPaused);
    return;
  }

  // desktop doesn't have this setting
  if (!(Platform.isAndroid || Platform.isIOS)) return;

  if (FinampSettingsHelper.finampSettings.requireWifiForDownloads) {
    final connectedToWifi = connections.contains(ConnectivityResult.wifi);
    if (connectedToWifi) return;

    if (_getDownloads() == 0) return;

    GlobalSnackbar.message((context) => AppLocalizations.of(context)!.downloadPaused);
  }
}
