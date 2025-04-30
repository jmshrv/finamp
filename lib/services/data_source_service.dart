import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/network_manager.dart';
import 'package:finamp/services/playon_service.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/finamp_models.dart';
import 'finamp_settings_helper.dart';
import 'package:network_info_plus/network_info_plus.dart';
part 'data_source_service.g.dart';

Logger _dataSourceServiceLogger = Logger("Data Source Service");

enum SourceChangeType {
  toLocalUrl,
  toRemoteUrl,
  toOffline,
  toOnline,
}

@riverpod
class DataSourceService extends _$DataSourceService {
  StreamSubscription<String>? _baseUrlListener;

  @override
  void build() {
    final FinampUserHelper finampUserHelper =
        GetIt.instance<FinampUserHelper>();

    ref.listen(finampSettingsProvider.isOffline, (_, isOffline) {
      if (isOffline) {
        _dataSourceServiceLogger.info("Offline Mode Enabled");
      } else {
        _dataSourceServiceLogger.info("Offline Mode Disabled");
      }
      _onDataSourceChange(isOffline
          ? SourceChangeType.toOffline
          : SourceChangeType.toOnline);
    });

    _baseUrlListener?.cancel();
    _baseUrlListener = baseUrlChangeStream.listen((newBaseUrl) {
      _dataSourceServiceLogger.info("Base URL Changed: $newBaseUrl");
      bool isLocalUrl = finampUserHelper.currentUser?.isLocal ?? false;
      _onDataSourceChange(isLocalUrl
          ? SourceChangeType.toLocalUrl
          : SourceChangeType.toRemoteUrl);
    });
  }
}

Future<void> _onDataSourceChange(SourceChangeType event) async {
  final QueueService queueService = GetIt.instance<QueueService>();
  _dataSourceServiceLogger
      .finest("Connectivity Change Triggered, event is '$event'");

  final queueInfo = queueService.getQueue();

  if (queueInfo.trackCount > 0) {
    if ((event == SourceChangeType.toOffline &&
            queueInfo.undownloadedTracks > 0) ||
        (event == SourceChangeType.toLocalUrl &&
            queueInfo.undownloadedTracks > 0) ||
        (event == SourceChangeType.toRemoteUrl &&
            queueInfo.undownloadedTracks > 0)) {
      if (FinampSettingsHelper.finampSettings.autoReloadQueue) {
        await queueService.reloadQueue();
      } else {
        GlobalSnackbar.action(
          (context) =>
              "${AppLocalizations.of(context)!.autoReloadPrompt}${event == SourceChangeType.toOffline && queueInfo.undownloadedTracks > 0 ? ". ${AppLocalizations.of(context)!.autoReloadPromptMissingTracks(queueInfo.undownloadedTracks)}" : ""}",
          action: (context) => SnackBarAction(
            label: AppLocalizations.of(context)!.autoReloadPromptReloadButton,
            onPressed: () {
              queueService.reloadQueue();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
          isConfirmation: false,
        );
      }
    }
  }
}
