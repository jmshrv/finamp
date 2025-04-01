import 'dart:async';

import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logging/logging.dart';

class AutoOffline {
  final _autoOfflineLogger = Logger("AutoOffline");
  final StreamSubscription<List<ConnectivityResult>> listener =
      Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> result) {
    bool hasWifi = result.contains(ConnectivityResult.wifi);
    bool hasEth = result.contains(ConnectivityResult.ethernet);
    bool isConnected = hasWifi | hasEth;
    Logger("AutoOffline").info(isConnected);
    AutoOffline.setOfflineMode(!isConnected);
  });

  AutoOffline(WidgetRef ref) {
    bool featureEnabled = ref.watch(finampSettingsProvider.autoOffline);
    // false = user overwrote offline mode
    bool featureActive =
        ref.watch(finampSettingsProvider.autoOfflineListenerActive);

    if (featureEnabled && featureActive) {
      _autoOfflineLogger.info("Resumed Automation");
      listener.resume();
    } else {
      _autoOfflineLogger.info("Paused Automation");
      listener.pause();
    }
  }
  static void setOfflineMode(bool state) {
    // 

    // skip when feature not enabled
    if (!FinampSettingsHelper.finampSettings.autoOffline) return;
    // skip when user overwrote offline mode
    if (!FinampSettingsHelper.finampSettings.autoOfflineListenerActive) return;

    Logger("AutoOffline").info(state
        ? "Automatically Enabled Offline Mode"
        : "Automatically Disabled Offline Mode");

    FinampSetters.setIsOffline(state);
  }
}
