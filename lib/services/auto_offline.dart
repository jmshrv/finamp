import 'dart:core';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/finamp_models.dart';
import 'finamp_settings_helper.dart';

part 'auto_offline.g.dart';

final _autoOfflineLogger = Logger("AutoOffline");

@riverpod
class AutoOffline extends _$AutoOffline {
  @override
  void build() {
    var listener = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _setOfflineMode(result);
    });

    bool featureEnabled = ref.watch(finampSettingsProvider.autoOffline) !=
        AutoOfflineOption.disabled;
    // false = user overwrote offline mode
    bool featureActive =
        ref.watch(finampSettingsProvider.autoOfflineListenerActive);

    if (featureEnabled && featureActive) {
      _autoOfflineLogger.info("Resumed Automation");
      listener.resume();
      // directly check if offline mode should be on to avoid desync
      _setOfflineMode(null);
    } else {
      _autoOfflineLogger.info("Paused Automation");
      listener.pause();
    }
    ref.onDispose(listener.cancel);
  }
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
