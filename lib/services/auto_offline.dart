import 'dart:async';

import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logging/logging.dart';

class AutoOffline {
  final _autoOfflineLogger = Logger("AutoOffline");
  final StreamSubscription<List<ConnectivityResult>> listener =
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool hasWifi = result.contains(ConnectivityResult.wifi);
      FinampSetters.setIsOffline(!hasWifi);
      Logger("AutoOffline").info(hasWifi ? "Auto turned off offline mode" : "Auto turned on offline mode");
    });

  AutoOffline(WidgetRef ref) {
    bool featureEnabled = ref.watch(finampSettingsProvider.autoOffline);
    if (!featureEnabled) {
      listener.pause();
      _autoOfflineLogger.info("Disabled feature. Listener Stopped");
      return;
    }

    // false if user manually enabled offline mode
    bool featureActive = ref.watch(finampSettingsProvider.autoOfflineListenerActive);
    if (featureActive) {
        listener.resume();
        _autoOfflineLogger.info("Temporarily enabled feature because user disabled offline mode");
        return;
    }
    // feature not active
    listener.pause();
    _autoOfflineLogger.info("Temporarily disabled feature until user disabled offline mode");
  }
}
