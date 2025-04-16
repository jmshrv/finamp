import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:logging/logging.dart';
import '../models/finamp_models.dart';
import 'finamp_settings_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:network_info_plus/network_info_plus.dart';
part 'auto_offline.g.dart';

StreamSubscription<List<ConnectivityResult>> _listener = Connectivity()
    .onConnectivityChanged
    .listen(_onConnectivityChange);

@riverpod
class AutoOffline extends _$AutoOffline {
  @override
  void build() {
    _listener = Connectivity()
        .onConnectivityChanged
        .listen(_onConnectivityChange);

    bool autoOfflineEnabled = ref.watch(finampSettingsProvider.autoOffline) !=
        AutoOfflineOption.disabled;

    // false = user overwrote offline mode
    bool autoOfflineActive =
        ref.watch(finampSettingsProvider.autoOfflineListenerActive);

    bool autoServerSwitch =
        ref.watch(finampSettingsProvider.preferHomeNetwork);

    Logger _autoOfflineLogger = Logger("AutoOffline");
    if ((autoOfflineEnabled && autoOfflineActive) || autoServerSwitch) {
      _autoOfflineLogger.info("Resumed Automation");
      _listener.resume();
      // directly check if offline mode should be on to avoid desync
      _onConnectivityChange(null);
    } else {
      _autoOfflineLogger.info("Paused Automation");
      _listener.pause();
    }
    ref.onDispose(_listener.cancel);
  }
}

Future<void> _onConnectivityChange(List<ConnectivityResult>? connections) async {
  await Future.wait([
    _setOfflineMode(connections),
    changeTargetUrl()
  ]);
}

Future<void> _setOfflineMode(List<ConnectivityResult>? connections) async {
  // skip when feature not enabled
  if (FinampSettingsHelper.finampSettings.autoOffline ==
      AutoOfflineOption.disabled) return;
  // skip when user overwrote offline mode
  if (!FinampSettingsHelper.finampSettings.autoOfflineListenerActive) return;
  
  bool state = await _shouldBeOffline(connections);

  // Attempt to combat IOS reliability problems
  if (Platform.isIOS) {
    await Future.delayed(Duration(seconds: 7));
    state = await _shouldBeOffline(null);
  }

  // skip if nothing changed
  if (FinampSettingsHelper.finampSettings.isOffline == state) return;

  GlobalSnackbar.message((context) => AppLocalizations.of(context)!
      .autoOfflineNotification(state ? "enabled" : "disabled"));

  Logger("AutoOffline").info(state
      ? "Automatically Enabled Offline Mode"
      : "Automatically Disabled Offline Mode");

  FinampSetters.setIsOffline(state);
}

Future<bool> _shouldBeOffline(List<ConnectivityResult>? connections) async {
  connections ??= await Connectivity().checkConnectivity();
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
  if (isLocal != null) {
    if (isLocal) {
        Logger("Network Switcher").info("Changed active network to home address");
        FinampUserHelper()
        .currentUser!
        .changeUrl(FinampSettingsHelper
            .finampSettings.homeNetworkAddress);}
    else {
        Logger("Network Switcher").info("Changed active network to public address");
        FinampUserHelper()
        .currentUser!
        .changeUrl(FinampSettingsHelper
            .finampSettings.publicAddress);}
    return;
  }


  if (!FinampSettingsHelper.finampSettings.preferHomeNetwork) {
    return changeTargetUrl(isLocal: false);}


  String? currentWifi = await NetworkInfo().getWifiName();
  String targetWifi = FinampSettingsHelper.finampSettings.homeNetworkName;

  await changeTargetUrl(isLocal: currentWifi == targetWifi);
}
