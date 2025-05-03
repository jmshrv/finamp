import 'dart:core';

import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'finamp_settings_helper.dart';

Logger _dataSourceServiceLogger = Logger("Data Source Service");

enum SourceChangeGenericType {
  network,
  transcoding,
}

enum SourceChangeType {
  toLocalUrl,
  toRemoteUrl,
  toOffline,
  toOnline,
  toDirectPlay,
  toTranscoding,
}

class DataSourceService {
  static void create() {
    final FinampUserHelper finampUserHelper =
        GetIt.instance<FinampUserHelper>();
    final ref = GetIt.instance<ProviderContainer>();

    ref.listen(finampSettingsProvider.isOffline, (_, isOffline) {
      if (isOffline) {
        _dataSourceServiceLogger.info("Offline Mode Enabled");
      } else {
        _dataSourceServiceLogger.info("Offline Mode Disabled");
      }
      _onDataSourceChange(
          isOffline ? SourceChangeType.toOffline : SourceChangeType.toOnline);
    });

    ref.listen(FinampUserHelper.finampCurrentUserProvider, (_, newUser) {
      _dataSourceServiceLogger
          .info("Base URL Changed: ${newUser.value?.baseURL}");
      bool isLocalUrl = finampUserHelper.currentUser?.isLocal ?? false;
      _onDataSourceChange(isLocalUrl
          ? SourceChangeType.toLocalUrl
          : SourceChangeType.toRemoteUrl);
    });
  }

  static Future<void> _onDataSourceChange(SourceChangeType event) async {
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
}
