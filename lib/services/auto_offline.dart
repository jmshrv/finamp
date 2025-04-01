import 'dart:async';

import 'package:finamp/models/finamp_models.dart';
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
    AutoOffline.setOfflineMode(!AutoOffline.shouldBeOffline(result));
  });

  AutoOffline(WidgetRef ref) {
    bool featureEnabled = ref.watch(finampSettingsProvider.autoOffline) != AutoOfflineOption.disabled;
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
    // skip when feature not enabled
    if (FinampSettingsHelper.finampSettings.autoOffline == AutoOfflineOption.disabled) return;
    // skip when user overwrote offline mode
    if (!FinampSettingsHelper.finampSettings.autoOfflineListenerActive) return;

    Logger("AutoOffline").info(state
        ? "Automatically Enabled Offline Mode"
        : "Automatically Disabled Offline Mode");

    FinampSetters.setIsOffline(state);
  }

  static bool shouldBeOffline(List<ConnectivityResult> connections) {
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
}
