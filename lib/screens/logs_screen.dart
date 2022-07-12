import 'package:flutter/material.dart';

import '../components/LogsScreen/copy_logs_button.dart';
import '../components/LogsScreen/logs_view.dart';
import '../components/LogsScreen/share_logs_button.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({Key? key}) : super(key: key);

  static const routeName = "/logs";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
        actions: const [
          ShareLogsButton(),
          CopyLogsButton(),
        ],
      ),
      body: const LogsView(),
    );
  }
}
