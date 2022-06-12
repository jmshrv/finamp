import 'package:flutter/material.dart';

import '../components/LogsScreen/CopyLogsButton.dart';
import '../components/LogsScreen/LogsView.dart';
import '../components/LogsScreen/ShareLogsButton.dart';

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
