import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          CopyLogsButton(),
        ],
      ),
      body: const LogsView(),
    );
  }
}
