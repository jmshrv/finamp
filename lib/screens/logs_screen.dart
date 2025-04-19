import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';

import '../components/LogsScreen/copy_logs_button.dart';
import '../components/LogsScreen/logs_view.dart';
import '../components/LogsScreen/share_logs_button.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  static const routeName = "/logs";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.logs),
        actions: const [
          ShareLogsButton(),
          // CopyLogsButton(), //!!! this doesn't return the full logs, only logs since the app started. Full logs can get quite large, so we need a better solution for this.
        ],
      ),
      body: const LogsView(),
    );
  }
}
