import 'dart:async';

import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class RestoreQueueMenuEntry extends ConsumerWidget implements HideableMenuEntry {
  final FinampStorableQueueInfo queueInfo;

  const RestoreQueueMenuEntry({super.key, required this.queueInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuEntry(
      icon: TablerIcons.restore,
      title: AppLocalizations.of(context)!.queueRestoreButtonLabel,
      onTap: () {
        final queueService = GetIt.instance<QueueService>();
        Navigator.pop(context); // close menu

        queueService.archiveSavedQueue();
        unawaited(queueService.loadSavedQueue(queueInfo).catchError(GlobalSnackbar.error));
        Navigator.of(context).popUntil((route) => route.isFirst && !route.willHandlePopInternally);
      },
    );
  }

  @override
  bool get isVisible => true;
}
